#!/bin/bash

# Clean out old parts if needed via rm -rf parts/*
# working directories
mkdir working_source transcript parts day hours thirty

# first put large audio in source (tested with two different sources)
# then break up in hours and thirty and minutes and 30 seconds
# if more than 30 seconds break down more, size matters
# if any error occurs, think about how much of the transcripts you'll lose
# of course, timestamps will be off
# then run fast.py

# pip install -r requirements.txt
# brew install sox ffmpeg

function convert_mp4_wav () {
	echo ".mp4 input and .wav out"
	ffmpeg -i $1 -vn -acodec pcm_s16le -ar 44100 -ac 2 $2
}

# argument is path to audio and output path mp4
function create_youtube_movie () {
# argument is audio mp3 and the output is mp4
  echo "input mp3 and output mp4 for youtube with black video"
	ffmpeg -f lavfi -i color=c=black:s=1280x720 -i $1 -c:a copy -c:v libx264 -crf 20 -pix_fmt yuv420p -shortest $2
}

# take argument and break into 30 second parts for slow.py or fast.py
function process_wav_minutes_parts () {
	ffmpeg -i $1 -f segment -segment_time 30 -c copy parts/out%09d.wav
}

# take argument and break into shy-minute parts for fast.py
function process_wav_sub_minute_parts () {
	ffmpeg -i $1 -f segment -segment_time 59 -c copy parts/out%09d.wav
}

# takes argument and assumes working directory is in source
# argument is broken into hours directory
function process_wav_hours_parts () {
	ffmpeg -i source/$1 -f segment -segment_time 3600 -c copy hours/out%09d.wav
}

# argument breaks source file into thirty minute chunks
function process_wav_thirty_parts () {
	ffmpeg -i source/$1 -f segment -segment_time 1800 -c copy thirty/out%09d.wav
}

# argument breaks source file into a day chunk
function process_wav_day_parts () {
	ffmpeg -i source/$1 -f segment -segment_time 18000 -c copy day/out%09d.wav
}

# Silence how-to https://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/
function remove_silence () {
	tempfile=`date '+%Y%m%d%H%M%S'`
# Removes short periods of silence, for podcasts
	sox $1 $tempfile.wav silence -l 1 0.1 1% -1 2.0 1%
	mv -v $1 $tempfile'_original_'$1
	mv -v $tempfile.wav $1
}

# Other silence configurations to edit/replace above sox command
# Removes all silence - not good for speech
#	sox $1 $tempfile.wav silence 1 0.1 1% -1 0.1 1%
# Shorting long period of silence and ignoring noise burst
#	sox $1 $tempfile.wav silence -l 1 0.3 1% -1 2.0 1%
