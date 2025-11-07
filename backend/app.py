from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route('/count', methods=['POST'])
def count_chars():
    data = request.get_json()
    name = data.get('name', '')
    return jsonify({'count': len(name)})

@app.route('/', methods=['GET'])
def home():
    return "Character Count Backend Running!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
