from mistralai import Mistral
import os
from dotenv import load_dotenv
import json
import re

load_dotenv()

API_KEY = os.getenv('MISTRALAI_API_KEY')

client = Mistral(api_key=API_KEY)

async def generate_questions(topic:str,difficulty:str,param:str,questions:int):
    system_prompt = """you are a quiz generator. generate mcq questions on the topic that the user mention along with no. of questions and extra details that the user provide
    Return the response as a JSON array where each item has the following structure:

{
  "question": "Question text here",
  "options": {
    "a": "Option A",
    "b": "Option B",
    "c": "Option C",
    "d": "Option D"
  },
  "correct_answer": "a",  // letter of the correct option
  "explanation": "A concise explanation of the correct answer."
}

The final output should be a list of such dictionaries like:

[
  {...}, {...}, {...}
]
    """

    user_prompt = f"""generate {questions} multiple choice questions on the topic {topic} with a difficulty level of {difficulty} and the questions set should consist of {param} type questions ."""

    chat_response = client.chat.complete(
    model = "mistral-large-latest",
    messages = [
        {
            "role":"system",
            "content":system_prompt
        },
        {
            "role": "user",
            "content": user_prompt,
        },
    ]
    )

    res_string =  chat_response.choices[0].message.content
    print(res_string)
    res_list = json.loads(extract_json(res_string))
    return res_list

def extract_json(response: str) -> str:
    
    match = re.search(r'\[.*\]', response, re.DOTALL)  # Match anything between the first and last curly braces
    if match:
        json_str = match.group(0)  # Extract the matched JSON string
        return json_str.strip()  # Remove leading/trailing spaces
    else:
        raise ValueError("No valid JSON found in the response.")