module Miri
  class AudioRecorder1
    
    def record
      # Record the audio
      `python stt_google.py`
      # Convert the recorded audio from wav to flac
      `mplayer -ao alsa:device=hw=0.0 -speed 3 /home/pi/miri/bin/output18.wav -vc null -vo null -ao pcm:fast:waveheader:file=/home/pi/miri/bin/output181.wav`
      `ffmpeg -loglevel 0 -v 0 -i /home/pi/miri/bin/output181.wav -ab 192k -y /home/pi/miri/sounds/output/output.flac 2> /dev/null`
 
      return "/home/pi/miri/sounds/output/output.flac"
    end
  end
end
