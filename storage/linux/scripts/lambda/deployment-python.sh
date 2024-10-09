#!/bin/bash
# Reference https://stackoverflow.com/questions/40741282/cannot-use-requests-module-on-aws-lambda
mkdir lambda-function
cd lambda-function

echo "import os" > lambda_function.py
echo "import requests" >> lambda_function.py
echo -e "\ndef lambda_handler(event, context):" >> lambda_function.py
echo -e "\tresponse = requests.get(os.environ['URL'])" >> lambda_function.py
echo -e "\tprint(response.status_code)\n\tprint(response.text)" >> lambda_function.py
echo -e "\treturn {\n\t\t'statusCode': 200,\n\t\t'body': json.dumps(response.json())\n\t}" >> lambda_function.py

pip3 install --target ./package requests
cd package
zip -r ../deployment-package.zip .
cd ..
zip -g deployment-package.zip lambda_function.py