#!/bin/zsh

search_dir=tmp/audio
input_files=()

for entry in "$search_dir"/*
do
  input_files+=("-i" "$entry")
done

ffmpeg "${input_files[@]}" -filter_complex "[0:a][1:a][2:a][3:a][4:a][5:a][6:a][7:a][8:a][9:a]concat=n=10:v=0:a=1" tmp/audio_output.mp3

ffmpeg -loop 1 -i tmp/image/input.png -i tmp/audio_output.mp3 -c:v libx264 -c:a aac -strict experimental -b:a 192k -shortest -vf "scale=1920:1080" tmp/video_output.mp4
