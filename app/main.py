from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.middleware.cors import CORSMiddleware
import boto3
import uuid

app = FastAPI()

# Permet CORS si tens frontend separat
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Plantilles HTML
templates = Jinja2Templates(directory="app/templates")

# Connexió a DynamoDB Local
dynamodb = boto3.resource(
    'dynamodb',
    region_name='us-west-2',
    endpoint_url='http://dynamodb-local:8000',
    aws_access_key_id='fakeMyKeyId',
    aws_secret_access_key='fakeSecretAccessKey'
)

# Taula DynamoDB
table = dynamodb.Table('Tasks')

@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.get("/tasks")
async def get_tasks():
    response = table.scan()
    return response.get('Items', [])

@app.post("/tasks")
async def create_task(data: dict):
    task_id = str(uuid.uuid4())
    item = {
        "taskId": task_id,
        "title": data["title"],
        "completed": False
    }
    table.put_item(Item=item)
    return item

@app.patch("/tasks/{task_id}")
async def complete_task(task_id: str):
    table.update_item(
        Key={"taskId": task_id},
        UpdateExpression="SET completed = :val",
        ExpressionAttributeValues={":val": True}
    )
    return {"message": "Task updated"}

@app.delete("/tasks/{task_id}")
async def delete_task(task_id: str):
    table.delete_item(Key={"taskId": task_id})
    return {"message": "Task deleted"}

