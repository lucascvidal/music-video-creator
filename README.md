# Soundful Bot

This project started as just a script to automate track creation in Soundful. It then evolved to automating track concatenation and video creation. Now it generates title, description and tags for uploading it to YouTube. It ended up also uploading the video to YouTube.

## Prerequisites

You need Ruby and Python. I'm using Ruby 3.2.2 and Python 3.9.2 as I'm developing this project. Furthermore, you need a few packages:
```shell
sudo apt update && sudo apt install -y ffmpeg imagemagick libmagickwand-dev libmagickcore-dev
```

So, install gems:
```shell
bundle install
```

Install python libs:
```shell
pip install -r requirements.txt
```

Create a tmp directory:
```shell
mkdir tmp/
```

Create audio, image and fonts directories:
```shell
cd tmp/
mkdir audio/
mkdir image/
mkdir fonts/
```

Download Oswald Bold font and Lato Heavy font to fonts/ directory. You can find them at Google Fonts.

Create a .env file with all the variables present at the .env.example file. You will need a Soundful subscription and OpenAI credits for this to work.

For Soundful related variables, check the authorizationToken header using Dev Tools and get the User ID from the CDN URL when downloading a track from My Library. Soundful does not have a public API, so that's why we need to work around the restrictions.

OpenAI is much simpler, just get an API Key from the OpenAI platform website.

The last thing you need to set up is Google API credentials. Create a project on Google Cloud Platform, configure OAuth for desktop apps, set the scopes for youtube.upload and youtube.force-ssl, download the credentials.json file to the project's root directory and you should be good to go.

## Usage

1. Prepare the .env file with the template ID, BPM, and auth token for Soundful;
1. Generate tracks:
```shell
ruby create_tracks.rb -v
```
1. Download tracks:
```shell
ruby download_tracks.rb
```
1. Generate a 1920 px x 1080 px image for the thumbnail, place it inside the tmp/image dir named as input.png (I'm using SeaArt as the source for that, but I haven't found a way to automate this task yet);
1. Create video:
```shell
./create_video.sh
```
1. Generate thumbnail by setting the THUMBNAIL_FIRST_LINE and THUMBNAIL_SECOND_LINE environment vars inside .env and running:
```shell
ruby create_thumbnail.rb
```
1. Upload the video to YouTube:
```shell
python upload_video.py
```

# What I learned

- Working with ImageMagick;
- Working with the Desktop App OAuth flow;
- Using the YouTube Data API V3;
- Breaking the Soundful SPA API;
- Using FFMPEG for the first time;
- Integrating with Chat-GPT API.

# Things worth investigating

- Automating the input.png image generation;
- Encapsulating all of the scripts inside one big shell script to improve UX.
