#!/bin/bash
virtualenv --python=/usr/bin/python python
pip install -r requirements.txt -t python/lib/python3.10/site-packages

zip -r9 python.zip python