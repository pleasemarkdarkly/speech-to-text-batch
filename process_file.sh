# Clean out old parts if needed via rm -rf parts/*

# first put large audio in source
# then break up in hours and thirty
# then break thirty or hour in 30 seconds
# then run fast

# use this when you have your larger file broken up
process_wav_minutes_parts () {
	ffmpeg -i $1 -f segment -segment_time 30 -c copy parts/out%09d.wav
}

# use this to break larger file into smaller chucks
process_wav_hours_parts () {
	ffmpeg -i source/$1 -f segment -segment_time 3600 -c copy hours/out%09d.wav
}

# use this to make larger files in to even smaller chucks
process_wav_thirty_parts () {
	ffmpeg -i source/$1 -f segment -segment_time 1800 -c copy thirty/out%09d.wav
}

# use this to create day blocks
process_wav_day_parts () {
	ffmpeg -i source/$1 -f segment -segment_time 18000 -c copy day/out%09d.wav
}

# Silence how-to https://digitalcardboard.com/blog/2009/08/25/the-sox-of-silence/
remove_silence () {
	tempfile=`date '+%Y%m%d%H%M%S'`
# Removes all silence - not good for speech
#	sox $1 $tempfile.wav silence 1 0.1 1% -1 0.1 1%
# Removes short periods of silence, for podcasts
	sox $1 $tempfile.wav silence -l 1 0.1 1% -1 2.0 1%
# Shorting long period of silence and ignoring noise burst
#	sox $1 $tempfile.wav silence -l 1 0.3 1% -1 2.0 1%
	mv $1 $tempfile'_original_'$1
	mv $tempfile.wav $1
}