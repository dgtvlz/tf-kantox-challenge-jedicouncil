import json
import boto3
import os

dynamodb = boto3.client('dynamodb', region_name=os.environ['REGION'])
kms_client = boto3.client('kms', region_name=os.environ['REGION'])

def lambda_handler(event, context):
    try:
        manifest = json.loads(event['body'])
        
        for jedi_id, jedi_data in manifest.items():
            # Ensure jediId is a string
            jedi_id_string = str(jedi_id)
            
            encrypted_jedi_id = encrypt_jedi_id(jedi_id_string)
            print('encryptedJediId:', encrypted_jedi_id)
            
            # Store or update Jedi information in DynamoDB
            save_jedi_info(encrypted_jedi_id, jedi_data)

            # Log Jedi information
            print(f"Received and processed Jedi {jedi_data['name']} from planet {jedi_data['planet']} with power level {jedi_data['power_level']}")
        
        # Return success response
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Manifest received and processed successfully'})
        }
    except Exception as e:
        # Return error response
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

def save_jedi_info(encrypted_jedi_id, jedi_data):
    params = {
        'TableName': os.environ['DYNAMODB_TABLE_NAME'],
        'Item': {
            'jedi_id': {'B': encrypted_jedi_id},
            'name': {'S': jedi_data['name']},
            'planet': {'S': jedi_data['planet']},
            'power_level': {'N': str(jedi_data['power_level'])}
        }
    }
    
    # Put item into DynamoDB table
    dynamodb.put_item(**params)

def encrypt_jedi_id(jedi_id):
    print("Jedi ID to encrypt:", jedi_id)
    response = kms_client.encrypt(
        KeyId=os.environ['CMK_KEY_ID'],
        Plaintext=jedi_id.encode()
    )
    encrypted_jedi_id = response['CiphertextBlob']
    return encrypted_jedi_id
