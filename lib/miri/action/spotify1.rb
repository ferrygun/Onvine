require_relative 'base_action' 	

module Miri
  module Action
    class Spotify1 < BaseAction
  
      # Set to zero to play entire track
      PREVIEW_TRACK_SECONDS=10
      
      def process(artist_text)
        @artist_text = artist_text
        play_track_for_artist
      end

      def keywords
        [
          'once again' 
        ]
      end

      private

      def play_track_for_artist
	omxplayer_pid = `ps -C mpg123 -o pid=`

        Logger.debug("omxplayer_pid: #{omxplayer_pid}")

        #if omxplayer pid is exist
        if omxplayer_pid.strip != ""
                `kill -9 #{omxplayer_pid}`
        end

        bio = `cat /home/pi/miri/data/history.txt`
	command = "mpg123  #{bio} &"
        t1=Thread.new{ system command}


      end
    end
  end
end
