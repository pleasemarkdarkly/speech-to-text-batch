slow.py to test 
fast.py to run against larger jobs source in parts/
batch.sh uses working_source as audio source
process_files.sh gives you the choice of working with day chunks, hour chunks, minute chunks, and helper functions like cleaning up audio
cleaning silence audio blocks appears where translates returns null and breaks the whole translate block
requirements.txt for pip install -r 
increase threads in fast.py to increase workers 
10 hours of court transcripts processed in under 20 minutes with 8 threads
10 hours is about 1,121 API calls at .006 or $6.70 
