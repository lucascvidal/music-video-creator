import os
import json
import requests
import googleapiclient
from dotenv import load_dotenv
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

load_dotenv()

def generate_video_metadata(genre, param, max_tokens):
    url = os.environ.get("OPENAI_CHAT_COMPLETION_URL")
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {os.environ.get('OPENAI_API_KEY')}"
    }

    messages = [
        {"role": "system", "content": "You are a helpful assistant for generating video content."},
        {"role": "user", "content": f"Generate {param} for a YouTube music video related to {genre}. Please, generate it in Brazilian Portuguese, and please send your response without any additional terms explaining what it is. The response message will be copied to the video metadata without parsing."}
    ]

    data = {
        "model": "gpt-3.5-turbo",
        "messages": messages,
        "max_tokens": max_tokens
    }

    response = requests.post(url, headers=headers, json=data)
    response.raise_for_status()

    result = response.json()
    generated_content = result["choices"][0]["message"]["content"]
    return generated_content

genre = os.environ.get("VIDEO_THEME")
video_title = generate_video_metadata(genre, "title", 200)
video_description = generate_video_metadata(genre, "description", 1000)
video_tags = generate_video_metadata(genre, "tags", 1000)

print("Video title:", video_title)
print("Video description:", video_description)
print("Video tags:", video_tags)

credentials_file_path = "./credentials.json"

flow = InstalledAppFlow.from_client_secrets_file(
    credentials_file_path, scopes=["https://www.googleapis.com/auth/youtube.upload", "https://www.googleapis.com/auth/youtube.force-ssl"]
)

credentials = flow.run_local_server(port=0)

youtube = build("youtube", "v3", credentials=credentials)

video_filepath = "tmp/video_output.mp4"

request = youtube.videos().insert(
    part="snippet,status",
    body={
        "snippet": {
            "title": video_title,
            "description": video_description,
            "tags": video_tags.split(","),
            "categoryId": "24"
        },
        "status": {
            "privacyStatus": "public"
        }
    },
    media_body=googleapiclient.http.MediaFileUpload(video_filepath, chunksize=-1, resumable=True)
)

response = None
while response is None:
    status, response = request.next_chunk()
    if status:
        print("Uploading...")

print("Video uploaded successfully!")

thumbnail_filepath = "tmp/thumbnail.png"

request = youtube.thumbnails().set(
    videoId=response["id"],
    media_body=googleapiclient.http.MediaFileUpload(thumbnail_filepath, chunksize=-1, resumable=True)
)

response = None
while response is None:
    status, response = request.next_chunk()
    if status:
        print("Uploading thumbnail...")

print("Thumbnail uploaded successfully!")
