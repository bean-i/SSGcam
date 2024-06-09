import logging
from flask import Blueprint, request, jsonify, Response
import tensorflow as tf
import numpy as np
import pandas as pd
from sentence_transformers import SentenceTransformer
import os
from dotenv import load_dotenv
import json

voice_bp = Blueprint('voice_phishing', __name__)

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.DEBUG)

# Model initialization
try:
    logging.debug("Loading models...")
    model1 = SentenceTransformer('sentence-transformers/all-mpnet-base-v2')
    logging.debug("Model1 loaded")
    model2 = SentenceTransformer('jhgan/ko-sbert-sts')
    logging.debug("Model2 loaded")
    logging.debug("SentenceTransformers models loaded successfully")

    process1_model_v2_path = os.getenv('PROCESS1_MODEL_V2_PATH')
    process1_model_jhgan_path = os.getenv('PROCESS1_MODEL_JHGAN_PATH')
    process2_model_v2_path = os.getenv('PROCESS2_MODEL_V2_PATH')
    process2_model_jhgan_path = os.getenv('PROCESS2_MODEL_JHGAN_PATH')

    logging.debug(f"process1_model_v2_path: {process1_model_v2_path}")
    logging.debug(f"process1_model_jhgan_path: {process1_model_jhgan_path}")
    logging.debug(f"process2_model_v2_path: {process2_model_v2_path}")
    logging.debug(f"process2_model_jhgan_path: {process2_model_jhgan_path}")

    logging.debug("Loading Keras models...")
    process1_model_v2 = tf.keras.models.load_model(process1_model_v2_path)
    logging.debug("process1_model_v2 loaded")
    process1_model_jhgan = tf.keras.models.load_model(process1_model_jhgan_path)
    logging.debug("process1_model_jhgan loaded")
    process2_model_v2 = tf.keras.models.load_model(process2_model_v2_path)
    logging.debug("process2_model_v2 loaded")
    process2_model_jhgan = tf.keras.models.load_model(process2_model_jhgan_path)
    logging.debug("process2_model_jhgan loaded")
    logging.debug("Keras models loaded successfully")
except Exception as e:
    logging.error(f"Error loading models: {e}")

@voice_bp.route('/', methods=['POST'])
def predict():
    logging.debug("Received request")
    data = request.get_json()

    if 'text' not in data:
        logging.debug("No text in request")
        return jsonify({'error': 'text is required'}), 400

    text_list = data['text']
    if not isinstance(text_list, list):
        logging.debug("Text is not a list")
        return jsonify({'error': 'text should be a list of strings'}), 400

    logging.debug(f"Text list: {text_list}")

    try:
        A1 = model1.encode(text_list)
        A2 = model2.encode(text_list)
        logging.debug("Text encoding successful")
    except Exception as e:
        logging.error(f"Error encoding text: {e}")
        return jsonify({'error': 'error encoding text'}), 500

    def process_model_input(A):
        feature_list = [i for i in range(A.shape[1])]
        x_train = pd.DataFrame(index=range(1), columns=feature_list)
        for i in range(x_train.shape[1]):
            x_train.iloc[0, i] = A[0][i]
        x_train = x_train.values
        x_train_tensor = tf.convert_to_tensor(x_train, dtype=tf.float32)
        x_train_reshaped = tf.reshape(x_train_tensor, (x_train_tensor.shape[0], x_train_tensor.shape[1], 1))
        return x_train_reshaped

    try:
        process1_target = process_model_input(A1)
        process2_target = process_model_input(A2)

        pred1_v2 = process1_model_v2.predict(process1_target)
        pred1_jhgan = process1_model_jhgan.predict(process1_target)
        # pred2 추가
        pred2_v2 = process2_model_v2.predict(process2_target)
        pred2_jhgan = process2_model_jhgan.predict(process2_target)

        pred1_v2 = pred1_v2[0][0]
        pred1_jhgan = pred1_jhgan[0][0]

        pred2_v2=pred2_v2[0][0]
        pred2_jhgan=pred2_jhgan[0][0]

    except Exception as e:
        logging.error(f"Error in process1 prediction: {e}")
        return jsonify({'error': 'error in process1 prediction'}), 500

    try:
        logging.debug(pred1_v2)
        logging.debug(pred1_jhgan)
        logging.debug(pred2_v2)
        logging.debug(pred2_jhgan)

        process1_class=None
        process1_probability=None
        process2_class=None
        voicephishing_class_results = None
        probability = None


        if pred1_v2>=0.5 or pred1_jhgan>=0.5:
            process1_class=1
            probability = max(pred1_v2, pred1_jhgan)
            # 보이스피싱이라고 판단하면 process2 결과로 
            if pred2_v2>pred2_jhgan:
                process2_class = np.where(pred2_v2 > 0.5, 1, 0)
            elif pred2_v2<pred2_jhgan:
                process2_class = np.where(pred2_jhgan > 0.5, 1, 0)

            if process2_class == 1:
                voicephishing_class_results = "기관 사칭형 보이스피싱"
            elif process2_class == 0:
                voicephishing_class_results = "대출 사기형 보이스피싱"

        else:
            process1_class=0


        response = {
            'phishing': process1_class,
            'probability': "{:.2f}%".format(probability * 100) if probability is not None else "N/A",
            'voicephishing_class_results': voicephishing_class_results
        }


        json_response = json.dumps(response, ensure_ascii=False)
        return Response(response=json_response, status=200, mimetype='application/json')
    except Exception as e:
        logging.error(f"Error in process2 prediction: {e}")
        logging.error(f"Exception details: {e}")
        return jsonify({'error': f'error in process2 prediction: {str(e)}'}), 500
