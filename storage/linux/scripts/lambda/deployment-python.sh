#!/bin/bash

mkdir lambda-function
cd lambda-function

echo "import requests" > lambda_function.py
echo "def lambda_handler(event, context):" >> lambda_function.py
echo "\tresponse = requests.get(\"https://www.test.com/\")" >> lambda_function.py
echo "\tprint(response.text)" >> lambda_function.py
echo "\treturn response.text" >> lambda_function.py

pip install --target ./package requests
cd package
zip -r ../deployment-package.zip .
cd ..
zip -g deployment-package.zip lambda_function.py