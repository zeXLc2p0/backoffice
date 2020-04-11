#!/usr/bin/env python3
import os
import json
import requests
from typing import Any, Dict


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
    }

    response = requests.post(api_url, data=data, headers=headers)
    response.raise_for_status()

    return response.json()
