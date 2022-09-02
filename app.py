import os
import json
import logging

from flask import Flask
import flask

from modelpkg.construct import Model


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("Endpoint app")

# Directory for model artifacts: uses 'DIR_MODEL_LOCAL', when
# when set, i.e. when application runs locally. Otherwise
# the Sagemaker default (=/opt/ml/model).
DIR_MODEL = os.getenv('DIR_MODEL_LOCAL') or '/opt/ml/model'

# Load model
model = Model()
model.load(DIR_MODEL)

# Flask app for serving predictions
app = Flask(__name__)


@app.route('/ping', methods=['GET'])
def ping():
    # Check if the classifier was loaded correctly
    health = model is not None
    status = 200 if health else 404
    return flask.Response(response='\n', status=status, mimetype='application/json')


@app.route('/invocations', methods=['POST'])
def transformation():
    input = flask.request.get_json()
    # A lot of logging going on - for debugging purposes
    logger.info(f'Request: {input}')
    predictions = model.predict(**input)
    logger.info(f'Predictions: {predictions}')
    # Transform predictions to JSON
    response = {'output': predictions}
    logger.info(f'Response: {response}')
    response = json.dumps(response)
    logger.info(f'Response (JSON): {response}')
    return flask.Response(response=response, status=200, mimetype='application/json')


if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0')

    # INVOKE APP
    # import requests
    # requests.get('http://localhost:8080/ping')
    # requests.post('http://localhost:8080/invocations', json={'age':31}).json()
