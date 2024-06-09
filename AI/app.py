from flask import Flask
from voice_phishing_server import voice_bp
from deep_voice_server import deep_bp

app = Flask(__name__)
app.url_map.strict_slashes = False

app.register_blueprint(voice_bp, url_prefix='/predict/voicephishing')
app.register_blueprint(deep_bp, url_prefix='/predict/deepvoice')

if __name__ == '__main__':
    app.run(debug=True, port=5000)
