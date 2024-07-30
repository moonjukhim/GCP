from random import randint, uniform
import time
import logging
import requests
from flask import Flask, url_for
import setup_opentelemetry
import gcp_logging

from opentelemetry.instrumentation.requests import RequestsInstrumentor
from opentelemetry.instrumentation.flask import FlaskInstrumentor

# [START opentelemetry_instrumentation_main]
logger = logging.getLogger(__name__)

app = Flask(__name__)
FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()
# [END opentelemetry_instrumentation_main]

# [START opentelemetry_instrumentation_handle_multi]
@app.route('/multi')
def multi():
    """Handle an http request by making 3-7 http requests to the /single endpoint."""
    subRequests = randint(3, 7)
    logger.info("handle /multi request", extra={'subRequests': subRequests})
    for _ in range(subRequests):
        requests.get(url_for('single', _external=True))
    return 'ok'
# [END opentelemetry_instrumentation_handle_multi]

# [START opentelemetry_instrumentation_handle_single]
@app.route('/single')
def single():
    """Handle an http request by sleeping for 100-200 ms, and write the number of seconds slept as the response."""
    duration = uniform(0.1, 0.2)
    time.sleep(duration)
    return f'slept {duration} seconds'
# [END opentelemetry_instrumentation_handle_single]