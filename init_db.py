import boto3

# Connexió a DynamoDB Local
dynamodb = boto3.client(
    'dynamodb',
    endpoint_url='http://localhost:8001',  # Port extern del servei DynamoDB Local
    region_name='us-west-2',
    aws_access_key_id='fakeMyKeyId',
    aws_secret_access_key='fakeSecretAccessKey'
)

# Creació de la taula Tasks
try:
    dynamodb.create_table(
        TableName='Tasks',
        KeySchema=[{'AttributeName': 'taskId', 'KeyType': 'HASH'}],
        AttributeDefinitions=[{'AttributeName': 'taskId', 'AttributeType': 'S'}],
        ProvisionedThroughput={'ReadCapacityUnits': 5, 'WriteCapacityUnits': 5}
    )
    print("Taula creada.")
except dynamodb.exceptions.ResourceInUseException:
    print("La taula ja existeix.")

