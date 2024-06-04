from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import pandas as pd
from sentence_transformers import SentenceTransformer
import logging
logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

logging.debug("Loading Sentence Transformer model")
model1 = SentenceTransformer('sentence-transformers/all-mpnet-base-v2')
model2 = SentenceTransformer('jhgan/ko-sbert-sts')
logging.debug("Sentence Transformer model loaded")

process1_model_v2_path = 'AI/Flask/models/process 1 base v2.keras'
process1_model_jhgan_path = 'AI/Flask/models/process 1 jhgan.keras'
process2_model_v2_path = 'AI/Flask/models/process2 base v2.keras'
process2_model_jhgan_path = 'AI/Flask/models/process2 jhgan.keras'

logging.debug("Loading models")
process1_model_v2 = tf.keras.models.load_model(process1_model_v2_path)
process1_model_jhgan = tf.keras.models.load_model(process1_model_jhgan_path)
process2_model_v2 = tf.keras.models.load_model(process2_model_v2_path)
process2_model_jhgan = tf.keras.models.load_model(process2_model_jhgan_path)
logging.debug("Models loaded successfully")

@app.route('/predict/voicephishing', methods=['POST'])
def predict():
    data = request.get_json()

    if 'text' not in data:
        return jsonify({'error': 'text is required'}), 400

    text_list = data['text']
    if not isinstance(text_list, list):
        return jsonify({'error': 'text should be a list of strings'}), 400

    A1 = model1.encode(text_list)
    A2 = model2.encode(text_list)

    def process_model_input(A):
        feature_list = [i for i in range(A.shape[1])]
        x_train = pd.DataFrame(index=range(1), columns=feature_list)
        for i in range(x_train.shape[1]):
            x_train.iloc[0, i] = A[0][i]
        x_train = x_train.values
        x_train_tensor = tf.convert_to_tensor(x_train, dtype=tf.float32)
        x_train_reshaped = tf.reshape(x_train_tensor, (x_train_tensor.shape[0], x_train_tensor.shape[1], 1))
        return x_train_reshaped

    process1_target_v2 = process_model_input(A1)
    process1_target_jhgan = process_model_input(A2)

    pred1_v2 = process1_model_v2.predict(process1_target_v2)
    pred1_jhgan = process1_model_jhgan.predict(process1_target_jhgan)

    process1_probability = "{:.0f}%".format((pred1_v2[0][0] + pred1_jhgan[0][0]) / 2 * 100)
    process1_output_v2 = np.where(pred1_v2 > 0.5, 1, 0)
    process1_output_jhgan = np.where(pred1_jhgan > 0.5, 1, 0)
    voicephishing_detection_results = (process1_output_v2[0][0] + process1_output_jhgan[0][0]) // 2

    response = {
        'probability': process1_probability
    }

    if voicephishing_detection_results == 1:
        process2_target_v2 = process1_target_v2
        process2_target_jhgan = process1_target_jhgan

        pred2_v2 = process2_model_v2.predict(process2_target_v2)
        pred2_jhgan = process2_model_jhgan.predict(process2_target_jhgan)

        pred2 = (pred2_v2[0][0] + pred2_jhgan[0][0]) / 2

        if pred2 > 0.5:
            process2_probability = pred2 * 100
        else:
            process2_probability = (1 - pred2) * 100

        process2_output = np.where(pred2 > 0.5, 1, 0)
        voicephishing_class_results = "기관 사칭형 보이스피싱" if process2_output == 1 else "대출 사기형 보이스피싱"

        response['voicephishing_class_results'] = voicephishing_class_results

    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)