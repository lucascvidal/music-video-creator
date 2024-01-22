# Music Video Creator

This repository is archived because I no longer find it useful. Let me provide some context. I initially created a YouTube Dark Channel with the goal of monetizing the audience through Google AdSense. However, I grew weary of manually producing videos, prompting me, as a developer, to contemplate automating the video creation process. What began as a simple script for automating track creation in Soundful evolved into a comprehensive bot. This bot manages the entire process, from track creation and concatenation to video generation, including title, description, and tags. Additionally, it handles the upload of the final video to YouTube.

Unfortunately, YouTube began flagging my videos as Spam and Computer Generated Content. Consequently, the most recent videos created and uploaded using the scripts in this repository are set to Private, restricting access to only myself. This results in no audience and, consequently, no AdSense opportunity. Therefore, I no longer see any practical use for this repository, aside from showcasing it in my portfolio due to its interesting scripts and integrations. If you're interested in using these scripts, please be aware that over time they may break, and I likely won't be updating them with fixes.

## Prerequisites

Ensure you have Ruby and Python installed, specifically Ruby 3.2.2 and Python 3.9.2 in the current project development. Install the required packages:
```shell
sudo apt update && sudo apt install -y ffmpeg imagemagick libmagickwand-dev libmagickcore-dev
```

Install Ruby gems:
```shell
bundle install
```

Install Python libraries:
```shell
pip install -r requirements.txt
```

Create necessary directories:
```shell
mkdir tmp/
cd tmp/
mkdir audio/
mkdir image/
mkdir fonts/
```

Download Oswald Bold and Lato Heavy fonts from Google Fonts and place them in the fonts/ directory.

Create a .env file with the required variables (refer to the .env.example file). You need Soundful subscription credentials and OpenAI API Key.

Set up Google API credentials by creating a project on Google Cloud Platform, configuring OAuth for desktop apps, and downloading the credentials.json file to the project's root directory.

## Usage

- Prepare the Environment:
Ensure your .env file is configured with the necessary variables for Soundful, YouTube, and OpenAI.
- Run the Main Script:
Execute the main script to guide you through the entire process:
```shell
./soundful_bot.sh
```
- Follow Prompts:
The script will guide you step-by-step, providing prompts for user-specific details like user ID, video theme, thumbnail text, and OpenAI API key.
- Pause Between Tasks:
Keep in mind that there will be a pause of approximately 5 minutes between the creation and download of audio tracks, allowing sufficient time for the Soundful platform.
- Completion:
Upon completion, your video will be uploaded to YouTube, and the entire process will be seamlessly managed by the script.

# What I learned

- Working with ImageMagick.
- Managing the Desktop App OAuth flow.
- Utilizing the YouTube Data API V3.
- Overcoming challenges in working with the restricted Soundful SPA API.
- First-time experience with FFMPEG.
- Integrating with Chat-GPT and DALL-E API.
