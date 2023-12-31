#!/bin/zsh

search_audio_dir=tmp/audio
search_image_dir=tmp/image
input_files=()

for audio_entry in "$search_audio_dir"/*
do
  input_audio_files+=("-i" "$audio_entry")
done

ffmpeg "${input_audio_files[@]}" -filter_complex "[0:a][1:a][2:a][3:a][4:a][5:a][6:a][7:a][8:a][9:a]concat=n=10:v=0:a=1" tmp/audio_output.mp3

ffmpeg -loop 1 -i "$search_image_dir"/input.png -i tmp/audio_output.mp3 -c:v libx264 -c:a aac -strict experimental -b:a 192k -shortest -vf "scale=1920:1080" tmp/video_output.mp4

rm -f "$search_audio_dir"/*
rm -f "$search_image_dir"/*
rm tmp/track_info.json

echo "Video created and input files removed."
