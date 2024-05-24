from flask import Flask, request, jsonify
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model

app = Flask(__name__)

# Keras 모델 로드
model_path = '/Users/cindy/SSGcam/BE/Flask/models/fishing_detection_model(L12).keras'
model = load_model(model_path)

@app.route('/')
def home():
    return "Hello, Flask with Keras!"

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    # 입력 데이터를 numpy 배열로 변환
    input_data = np.array(data['inputs'])
    # 예측 수행
    predictions = model.predict(input_data)
    # 예측 결과를 JSON으로 반환
    return jsonify(predictions.tolist())

if __name__ == '__main__':
    app.run(debug=True)