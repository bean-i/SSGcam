from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import pandas as pd
from sentence_transformers import SentenceTransformer

app = Flask(__name__)

model = SentenceTransformer('sentence-transformers/all-MiniLM-L12-v2')
process1_model_path = '/Users/cindy/SSGcam/AI/Flask/models/fishing_detection_model(L12).keras'
process2_model_path = '/Users/cindy/SSGcam/AI/Flask/models/fishing_classificaiton_model(L12).keras'

process1_model = tf.keras.models.load_model(process1_model_path)
process2_model = tf.keras.models.load_model(process2_model_path)

@app.route('/predict/voicephising', methods=['POST'])
def predict():
    data = request.get_json()

    if 'text' not in data:
        return jsonify({'error': 'text is required'}), 400

    text_list = data['text']
    if not isinstance(text_list, list):
        return jsonify({'error': 'text should be a list of strings'}), 400

    A = model.encode(text_list)

    feature_list = [i for i in range(A.shape[1])]
    x_train = pd.DataFrame(index=range(1), columns=feature_list)

    for i in range(x_train.shape[1]):
        x_train.iloc[0, i] = A[0][i]

    x_train = x_train.values
    x_train_tensor = tf.convert_to_tensor(x_train, dtype=tf.float32)
    x_train_reshaped = tf.reshape(x_train_tensor, (x_train_tensor.shape[0], x_train_tensor.shape[1], 1))

    process1_target = x_train_reshaped

    pred1 = process1_model.predict(process1_target)
    process1_probability = "{:.0f}%".format(pred1[0][0] * 100)
    process1_output = np.where(pred1 > 0.5, 1, 0)
    voicephishing_detection_results = process1_output[0][0]

    response = {
        'probability': process1_probability
    }

    if voicephishing_detection_results == 1:
        process2_target = x_train_reshaped
        pred2 = process2_model.predict(process2_target)
        pred2 = pred2[0][0]

        if pred2 > 0.5:
            process2_probability = pred2 * 100
        else:
            process2_probability = (1 - pred2) * 100

        process2_output = np.where(pred2 > 0.5, 1, 0)
        voicephishing_class_results = "기관 사칭형 보이스피싱" if process2_output == 1 else "대출 사기형 보이스피싱"

        response['voicephishing_class_results'] = voicephishing_class_results

    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)