#!/usr/bin/env python3
import os
import json
import requests
import logging
from sys import stderr
from typing import Any, Dict

LOG_LEVEL = os.environ.get("LOG_LEVEL", "debug").upper()

logging.basicConfig(
    level = logging.ERROR,
    format = "[%(asctime)s] %(levelname)-8s %(message)s",
    datefmt = "%Y-%m-%d %H:%M:%S%z",
    stream = stderr)

logging.captureWarnings(True)

log = logging.getLogger(__name__)
log.setLevel(LOG_LEVEL)

def post_to_redcap(content: str, parameters: Dict[str,str] = {}) -> Any:
    """
    POST request to the REDCap API to export or import REDCap *content*.
    Requires environment variables REDCAP_API_URL and REDCAP_API_TOKEN.
    """
    api_url = os.environ['REDCAP_API_URL']
    api_token = os.environ['REDCAP_API_TOKEN']

    headers = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
    }

    data = {
        **parameters,
        'content': content,
        'token': api_token,
        'format': 'json',
        'returnFormat': 'json',
    }

    response = requests.post(api_url, data=data, headers=headers)
    log.debug(json.dumps(response.json()))
    response.raise_for_status()

    return response.json()
