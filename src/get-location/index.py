import os
import json
import boto3

dynamodb = boto3.client('dynamodb', region_name=os.environ['REGION'])

def lambda_handler(event, context):
    jedi_id = event['queryStringParameters']['jedi_id']
    try:
        # Ensure jediId is a string
        jedi_id_string = str(jedi_id)
            
        # Retrieve Jedi information from DynamoDB
        jedi_info = get_jedi_info(jedi_id_string)
        
        # Return Jedi information as response
        if jedi_info:
            return {
                'statusCode': 200,
                'body': json.dumps(jedi_info)
            }
        else:
           return {
                'statusCode': 404,
                'body': json.dumps({ 'error': 'Jedi not found' })
            } 
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({ 'error': str(e) })
        }

# Function to retrieve Jedi information from DynamoDB
def get_jedi_info(jedi_id):
    response = dynamodb.get_item(
        TableName=os.environ['DYNAMODB_TABLE_NAME'],
        Key={'jedi_id': {'S': jedi_id}}
    )
    
    # Check if item exists
    if 'Item' in response:
        item = response['Item']
        # Unmarshall the DynamoDB item into a Python dictionary
        jedi_info = {}
        for key, value in item.items():
            if 'S' in value:
                jedi_info[key] = value['S']
            elif 'N' in value:
                jedi_info[key] = int(value['N'])
        return jedi_info
    else:
        return None
