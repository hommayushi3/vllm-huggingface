from openai import OpenAI
import os
from dotenv import load_dotenv


if __name__ == "__main__":
    load_dotenv() 
    ENDPOINT_URL = os.getenv("HF_ENDPOINT_URL") + "/v1/" # if endpoint object is not available check the UI 
    API_KEY = os.getenv("HF_TOKEN")
    STREAM = False

    # initialize the client but point it to TGI
    client = OpenAI(base_url=ENDPOINT_URL, api_key=API_KEY)
    
    chat_completion = client.chat.completions.create(
        model="/repository", # needs to be /repository since there are the model artifacts stored
        messages=[
            {"role": "user", "content": [
                {
                    "type": "image_url",
                    "image_url": {
                        "url": "https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png"
                    }
                },
                {
                    "type": "text",
                    "text": "What is in the above image?"
                }
            ]},
        ],
        max_tokens=500,
        temperature=0.0,
        stream=STREAM
    )

    if STREAM:
        for message in chat_completion:
            if message.choices[0].delta.content:
                print(message.choices[0].delta.content, end="")
    else:
        print(chat_completion.choices[0].message.content)
