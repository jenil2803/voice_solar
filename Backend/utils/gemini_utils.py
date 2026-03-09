import os
import json5
import json
import requests
from google import genai
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env file
def extract_nested_json_block(text):
    start = text.find('{')
    if start == -1:
        return None  # No JSON object found

    brace_count = 0
    in_string = False
    escape = False

    for i in range(start, len(text)):
        char = text[i]

        # Handle string quoting logic
        if char == '"' and not escape:
            in_string = not in_string
        elif char == '\\' and not escape:
            escape = True
            continue

        if not in_string:
            if char == '{':
                brace_count += 1
            elif char == '}':
                brace_count -= 1

            if brace_count == 0:
                return text[start:i + 1]

        escape = False

    return None  # Unbalanced braces

def extract_json(text):
    try:
        # Attempt to parse the text as JSON directly
        return json5.loads(text)
    except ValueError:
        # If it fails, attempt to extract JSON from text using regex
        json_str = extract_nested_json_block(text)
        if json_str:
            try:
                return json5.loads(json_str)
            except Exception as e:
                with open(os.path.join("jsons", "place_holder_template.json"), "r") as placeholder_file:
                    return json.load(placeholder_file)
        else:
            raise ValueError("No JSON found in the input.")



client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

def generate_content(prompt):
    try:
        response = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=prompt,
        )
        return extract_json(response.text)
    except Exception as e:
        print(f"Error generating content: {e}")
        response = generate_content_openrouter(prompt)
        return response


def generate_content_openrouter(prompt, model="openai/gpt-oss-120b:free"):
    """
    Generate content using OpenRouter API.
    Make sure OPENROUTER_API_KEY is defined in your .env file.
    """
    api_key = os.getenv("OPEN_ROUTER_API_KEY")
    if not api_key:
        raise ValueError("OPEN_ROUTER_API_KEY is not set in the environment variables.")

    headers = {
        "Authorization": f"Bearer {api_key}",
        "HTTP-Referer": "http://127.0.0.1:8000",
        "X-Title": "Voice Solar Agent",
        "Content-Type": "application/json"
    }

    data = {
        "model": model,
        "messages": [
            {"role": "user", "content": prompt}
        ]
    }

    response = requests.post(
        "https://openrouter.ai/api/v1/chat/completions",
        headers=headers,
        json=data
    )
    
    if response.status_code != 200:
        raise Exception(f"OpenRouter API error (status {response.status_code}): {response.text}")
        
    result = response.json()
    
    if "choices" not in result or len(result["choices"]) == 0:
        raise ValueError("Invalid response from OpenRouter: missing 'choices'")
        
    content = result["choices"][0]["message"]["content"]
    
    return extract_json(content)


if __name__ == "__main__":  
    # To test OpenRouter execution, switch the function below to generate_content_openrouter
    response = generate_content("Explain how AI works in a few words")

    print(response)