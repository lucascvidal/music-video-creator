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
