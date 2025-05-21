from fastapi import FastAPI
from pydantic import BaseModel
from quiz_generator import generate_questions

class Question(BaseModel):
    topic:str
    questions:int
    difficulty:str
    param:str

app = FastAPI()

@app.post('/getQuiz')
async def get_overall_quiz(request:Question):
    response = await generate_questions(request.topic,request.difficulty,request.param,request.questions)
    return response