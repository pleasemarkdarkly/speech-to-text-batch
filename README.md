slow.py to test 
fast.py to run against larger jobs source in parts/
batch.sh uses working_source as audio source
process_files.sh gives you the choice of working with day chunks, hour chunks, minute chunks, and helper functions like clenaning up audio
cleaning silence audio blocks appears where translates returns null and breaks the whole translate block
requirements.txt for pip install -r 
increase threads in fast.py to increase workers 
10 hours of court transcripts processed in under 20 minutes with 8 threads