#!/usr/bin/env python
from ctypes import *
import pyaudio
import wave
import audioop
from collections import deque
import os
import urllib2
import urllib
import time

# From alsa-lib Git 3fd4ab9be0db7c7430ebd258f2717a976381715d
# $ grep -rn snd_lib_error_handler_t
# include/error.h:59:typedef void (*snd_lib_error_handler_t)(const char *file, int line, const char *function, int err, const char *fmt, ...) /* __attribute__ ((format (printf, 5, 6))) */;
# Define our error handler type
ERROR_HANDLER_FUNC = CFUNCTYPE(None, c_char_p, c_int, c_char_p, c_int, c_char_p)
def py_error_handler(filename, line, function, err, fmt):
  print 'messages are yummy'
c_error_handler = ERROR_HANDLER_FUNC(py_error_handler)

asound = cdll.LoadLibrary('libasound.so')
# Set error handler
asound.snd_lib_error_set_handler(c_error_handler)
# Initialize PyAudio
p = pyaudio.PyAudio()
p.terminate()

print '-'*40
# Reset to default error handler
asound.snd_lib_error_set_handler(None)
# Re-initialize


#config
chunk = 512
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
THRESHOLD = 180 #The threshold intensity that defines silence signal (lower than).
SILENCE_LIMIT = 2


p = pyaudio.PyAudio()
stream = p.open(format = FORMAT,
                    channels = CHANNELS,
                    rate = RATE,
                    input = True,
                    frames_per_buffer = chunk)

print "* listening. CTRL+C to finish."
all_m = []
data = ''
SILENCE_LIMIT = 2
rel = RATE/chunk
slid_win = deque(maxlen=SILENCE_LIMIT*rel)
started = False

while (True):
 data = stream.read(chunk)
 slid_win.append (abs(audioop.avg(data, 2)))
 if(True in [ x>THRESHOLD for x in slid_win]):
  if(not started):
   print "starting record"
  started = True
  all_m.append(data)
 elif (started==True):
  print "finished"
  filename = save_speech(all_m,p)
  #reset all
  started = False
  slid_win = deque(maxlen=SILENCE_LIMIT*rel)
  all_m= []
  print "listening ..."


print "* done recording"

stream.close()
p.terminate()


def save_speech(data, p):
 filename = 'output_'+str(int(time.time()))
 # write data to WAVE file
 data = ''.join(data)
 wf = wave.open(filename+'.wav', 'wb')
 wf.setnchannels(1)
 wf.setsampwidth(p.get_sample_size(pyaudio.paInt16))
 wf.setframerate(16000)
 wf.writeframes(data)
 wf.close()
 return filename
