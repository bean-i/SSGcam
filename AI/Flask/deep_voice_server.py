from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import librosa
import pandas as pd
import os
import logging
from werkzeug.utils import secure_filename

app = Flask(__name__)

model_path = '/Users/cindy/SSGcam/AI/Flask/models/deep voice detection model.keras'
model = tf.keras.models.load_model(model_path)

def pad2d(a, i):
    if a.shape[1] > i:
        return a[:, :i]
    else:
        return np.hstack((a, np.zeros((a.shape[0], i - a.shape[1]))))

def preprocess_audio(file):
    sample_rate = 8000

    x = librosa.load(file, sr=sample_rate)[0]
    S = librosa.feature.melspectrogram(y=x, sr=sample_rate, n_mels=200)
    log_S = librosa.power_to_db(S, ref=np.max)
    mfcc = librosa.feature.mfcc(S=log_S, n_mfcc=30)
    n_mfcc = librosa.feature.delta(mfcc, order=2)
    
    max_length = 39
    n_mfcc_padded = pad2d(n_mfcc, max_length)

    return n_mfcc_padded.T

logging.basicConfig(level=logging.DEBUG)

@app.route('/predict/deepvoice', methods=['POST'])
def predict():
    if 'file' not in request.files:
        logging.debug("파일이 제출되지 않았습니다.")
        return jsonify({"error": "파일이 제출되지 않았습니다."}), 400
    file = request.files['file']
    if file.filename == '':
        logging.debug("파일이름이 없습니다.")
        return jsonify({"error": "파일이름이 없습니다."}), 400
    if file:
        try:
            filename = secure_filename(file.filename)
            file_path = os.path.join('/tmp', filename)
            file.save(file_path)
            logging.debug(f"파일이 저장되었습니다: {file_path}")
            
            preprocessed_data = preprocess_audio(file_path)
            logging.debug(f"전처리된 데이터의 형태: {preprocessed_data.shape}")
            pred = model.predict(preprocessed_data) 
            
            process_probability = pred[0][0] if pred[0][0] > 0.5 else (1-pred[0][0])
            process_probability *= 100
            formatted_probability = f"{process_probability:.2f}%"
            deepvoice_detection_result = "딥보이스" if pred[0][0] > 0.5 else "일반보이스"
            result = {"probability": formatted_probability, "classification": deepvoice_detection_result}
            
            os.remove(file_path)  

            return jsonify(result)

        except Exception as e:
            logging.error(f"오류 발생: {e}")
            return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(port=5000, debug=True)