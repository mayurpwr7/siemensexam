import json
import os
import requests
import boto3

def lambda_handler(event, context):
    # Retrieve environment variables
    api_url = os.environ['API_ENDPOINT']
    api_key = os.environ['API_AUTH_KEY']

    # Get subnet ID from the event (provided by Terraform)
    subnet_id = event['subnet_id']
    name = event['name']
    email = event['email']

    # Prepare the payload
    payload = {
        "subnet_id": subnet_id,
        "name": name,
        "email": email
    }

    # Send the POST request
    headers = {
        'X-Siemens-Auth': api_key,
        'Content-Type': 'application/json'
    }

    response = requests.post(api_url, json=payload, headers=headers)

    # Log the response
    print(f"Response: {response.status_code}, {response.text}")

    return {
        'statusCode': 200,
        'body': json.dumps('Lambda function executed successfully')
    }
