#!/bin/bash
# Shell Script to take chunked audio into transcripts
# break the combined single files into thirty minute parts
# function from process_file from source to thirty folder
# remove previous thirty contents

# source helper functions
source ./process_file.sh

# Using Hourly Blocks

# Clear out working parts/
# Remove contents of parts
rm -rf parts/
mkdir parts

# Fixed to processing from working_source directory
for f in ./working_source/*.wav
do
  echo "Working on $f part (default hourly)"
  echo "Clear parts/ folder which holds 30 second blocks"
  rm -rf parts/
  mkdir parts

  echo "Remove silence and audio bursts"
  remove_silence $f

  echo "Process each audio listening block to 30 second Google processing block"
# create 30 second parts from 30 minute parts
  process_wav_minutes_parts $f

  echo "Spawn worker threads to send to Google to process"
  echo "Increase threads in fast.py for faster parallalization"
  python3 fast.py
  echo "Default listening block translated"
  echo "File created"
# when this is done it creates transcript.txt file
  today=`date '+%Y%m%d%H%M%S'`
  mv -v transcript.txt 'transcript-'$today'.txt'
done

