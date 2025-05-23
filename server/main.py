from fastapi import FastAPI
from pydantic import BaseModel
from quiz_generator import generate_questions
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Question(BaseModel):
    topic:str
    questions:int
    difficulty:str
    param:str


@app.post('/getQuiz')
async def get_overall_quiz(request:Question):
    response = await generate_questions(request.topic,request.difficulty,request.param,request.questions)
    return response