from flask import Flask, jsonify, make_response, request, send_file, Response
from flask_cors import CORS
from datetime import date
import csv
import pandas as pd

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "http://localhost:*"}})

# disables cors
@app.after_request
def add_custom_header(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

""" basic ass route """
@app.route('/')
def get_data():
    data = {"message": "This is a response from Flask with a custom header"}
    response = make_response(jsonify(data))
    return response

""" how to get body """
@app.route('/post', methods=['POST'])
def create_resource():
    data = request.get_json()

    response_data = {"message": "Resource created successfully", "data": data}
    return jsonify(response_data), 200  # 201 Created status code

""" get unchanged static csv file """
@app.route('/getCsv', methods=['GET'])
def get_cvs_file():
    response = send_file("apiCalls/pollen_test.csv", as_attachment=True, mimetype='text/csv')
    response.headers["Content-Disposition"] = f"attachment; filename=pollen_test.csv"
    return response

""" query csv file """
@app.route('/getCurrentPrediction', methods=['POST'])
def get_current_prediction():
    currentDate = date.today().strftime("%Y_%m_%d")

    df = pd.read_csv('apiCalls/pollen_test.csv')
    sorted = df[(df['date'] == '2022-02-14')]

    print(sorted)

    csv_data = sorted.to_csv()

    response = Response(csv_data, mimetype='text/csv')
    response.headers["Content-Disposition"] = "attachment; filename=sorted_data.csv"

    return response




if __name__ == '__main__':
    app.run(host="localhost", port=3000)