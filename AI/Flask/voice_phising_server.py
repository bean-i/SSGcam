from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import os
import tensorflow as tf
from sentence_transformers import SentenceTransformer
import numpy as np
import pandas as pd

app = Flask(__name__)

UPLOAD_FOLDER = '/path/to/the/uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

model_sentence = SentenceTransformer('sentence-transformers/all-MiniLM-L12-v2')
process1_model_path = '/Users/cindy/SSGcam/AI/Flask/models/fishing_detection_model(L12).keras'
process2_model_path = '/Users/cindy/SSGcam/AI/Flask/models/fishing_classificaiton_model(L12).keras'
process1_model = tf.keras.models.load_model(process1_model_path)
process2_model = tf.keras.models.load_model(process2_model_path)

def prepare_input(target):
    A = model_sentence.encode(target)
    x_train = pd.DataFrame(A).T
    x_train_tensor = tf.convert_to_tensor(x_train, dtype=tf.float32)
    x_train_reshaped = tf.reshape(x_train_tensor, (x_train_tensor.shape[0], x_train_tensor.shape[1], 1))
    return x_train_reshaped

@app.route('/predict/phising', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': '파일이 요청에 포함되지 않았습니다.'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': '파일 이름이 없습니다.'}), 400
    
    if file:
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read().splitlines()
        
        input_data = prepare_input(content)
        
        pred1 = process1_model.predict(input_data)
        process1_output = np.where(pred1 > 0.5, 1, 0)[0][0]
        
        result = {'보이스피싱 감지 결과': bool(process1_output)}
        
        if process1_output == 1:
            pred2 = process2_model.predict(input_data)
            process2_output = np.where(pred2 > 0.5, 1, 0)[0][0]
            result['보이스피싱 유형'] = '기관 사칭' if process2_output == 1 else '대출 사기'
        
        return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)