#!/bin/bash

# Process .WAV files in directory source/ and sub-divide
# transcribe and combine

# Source helper functions
source ./install.sh

# Create project folder
project=`date '+%Y%m%d%H%M%S'`
mkdir $project
echo "Create folder "$project

# Clear out working parts/
# Remove contents of parts
rm -rf parts/
mkdir parts

# Convert any mp4 files in source/
echo "Convert any mp4 into wav"

# Move into source/ directory
cd source
for m in *.mp4
do
  echo "Converting "$m
  ffmpeg -i $m -vn -acodec pcm_s16le -ar 44100 -ac 2 $m.wav
  remove_silence $m.wav
  rm *original*
done

# Return to main path
cd ..

# Fixed to processing from working_source directory
for f in ./source/*.wav
do
  echo "Working on" $f "part"
  echo "Clear parts/ folder which holds 59 second blocks"
  rm -rf parts/
  mkdir parts

# Remove silence in .wav creation
#  echo "Remove silence and audio bursts"
#  remove_silence $f

  echo "Process each audio listening block to 59 second Google processing blocks"
# create 59 second parts
  process_wav_sub_minute_parts $f

  echo "Spawn worker threads to send to Google to process"
  python3 fast.py

# When fast.py is done it creates transcript.txt file
  today=`date '+%Y%m%d%H%M%S'`
  mv -v transcript.txt 'transcript-'$today'.txt'
done

mkdir $project

# Clean up
echo "Move original files,processed wavs,  and transcripts to project folder"
mv -v source/*.mp4 $project
mkdir $project/wavs
mv -v source/*.wav $project/wavs

mv -v transcript-*.txt ./$project
cd $project
cat *.txt >'all_'$project'_transcripts.txt
cd ..

# echo "Clean up .wav files in source/"


echo "Done"


