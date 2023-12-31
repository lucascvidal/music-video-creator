# Soundful Bot

I was getting tired of doing repetitive tasks with the Soundful website UI. They do not have an open API, but they do run a Single Page App, which means everything, if well designed and developed, should be exposed through specific endpoints.

I took advantage of that and created a script to automate track previewing, creation and rendering. This should make my life easier as I create soundtracks for my dark YouTube channel project.

## Usage

For things to work, there are 2 things I couldn't automate: authentication and getting template data. So for the script to run well, I've written it to use environment variables, and everytime you are willing to run the script, you will have to update the AUTH_TOKEN, BPM and TEMPLATE_ID variables in the .env file. You can get this information toying around with the Dev Tools in Soundful website. Every request after the login page has the authorizationToken header with the token needed for the script.

Then, just run the script with or without the -v flag (verbose option):
```shell
ruby create_tracks.rb -v
```

## What I Learned

This was a quick project, but nonetheless I learned a few new things. For instance, this was my first CLI application using Ruby. I have developed CLI apps with C, C# and Python before, but with Ruby this was the first time.

# Video creation script

Thriving for efficiency made me create a shell script to concatenate 10 audio tracks created with the Ruby script and merge them with an image to create a video for the YouTube dark channel project. I was doing this manually, and it turns out it is much better to do so programatically.

So, if you download the 10 tracks created with the Ruby script from Soundful to the tmp/audio directory and put a 1920px x 1080px image named input.png inside tmp/image directory, running the script:
```shell
./create_video.sh
```

Should create a merged audio track named audio_output.mp3 and a video named video_output.mp4 inside the tmp directory. The video_output.mp4 is composed by the static image in a loop with the audio_output.mp3 soundtrack.

## What I Learned

I had never written shell script, so it was definitely interesting to dig a little deeper and see what is possible to do with it.

# Wishlist

Writing it here so I won't forget:
- Authentication for Soundful;
- Automating custom thumbnails generation using SeaArt and Canva;
- Upload to YouTube with title, description and tags generated by Chat-GPT.