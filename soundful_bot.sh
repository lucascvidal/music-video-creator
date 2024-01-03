#!/bin/bash

echo "This script will guide you through the process of setting up and running the Soundful bot. It will create tracks at Soundful, download them, generate an image to be used with the tracks to create a video, create the thumbnail for this video and then upload it to YouTube. Let's get started."

if [ -f .env ]; then
    source .env
fi

create_temp_env() {
    local temp_env_file=$(mktemp)
    for var in "$@"; do
        echo "export $var=${!var}" >> "$temp_env_file"
    done
    echo "$temp_env_file"
}

read -p "Enter the Soundful authorization token (AUTH_TOKEN): " AUTH_TOKEN
read -p "Enter the desired BPM value: " BPM
read -p "Enter the Soundful template ID (TEMPLATE_ID): " TEMPLATE_ID

read -p "Press Enter to create audio tracks..."
( source "$(create_temp_env AUTH_TOKEN BPM TEMPLATE_ID SOUNDFUL_RENDER_TRACK_URL SOUNDFUL_CREATE_TRACK_URL SOUNDFUL_PREVIEW_TRACK_URL)" && ruby create_tracks.rb -v )

read -p "Do you want to provide a new Soundful USER_ID? (y/n): " PROVIDE_USER_ID

if [ "$PROVIDE_USER_ID" == "y" ]; then
    read -p "Enter the user ID (USER_ID): " USER_ID
else
    USER_ID=${USER_ID:-$USER_ID_FROM_ENV}
fi

echo "Waiting for 5 minutes before downloading tracks..."
sleep 300

read -p "Press Enter to download audio tracks..."
( source "$(create_temp_env USER_ID)" && ruby download_tracks.rb -v )

read -p "Enter the video theme: " VIDEO_THEME
read -p "Enter the first line of the thumbnail: " THUMBNAIL_FIRST_LINE
read -p "Enter the second line of the thumbnail: " THUMBNAIL_SECOND_LINE

read -p "Do you want to provide a new OPENAI_API_KEY? (y/n): " PROVIDE_OPENAI_API_KEY

if [ "$PROVIDE_OPENAI_API_KEY" == "y" ]; then
    read -p "Enter the OpenAI API key (OPENAI_API_KEY): " OPENAI_API_KEY
else
    OPENAI_API_KEY=${OPENAI_API_KEY:-$OPENAI_API_KEY_FROM_ENV}
fi

read -p "Press Enter to create thumbnail..."
( source "$(create_temp_env OPENAI_API_KEY VIDEO_THEME THUMBNAIL_FIRST_LINE THUMBNAIL_SECOND_LINE OPENAI_IMAGES_ENDPOINT OPENAI_CHAT_COMPLETION_URL)" && ruby create_thumbnail.rb -v )

read -p "Press Enter to create video..."
./create_video.sh

read -p "Press Enter to upload video to YouTube..."
( source "$(create_temp_env VIDEO_THEME OPENAI_API_KEY OPENAI_CHAT_COMPLETION_URL)" && python upload_video.py )
