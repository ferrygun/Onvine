require_relative 'base_action' 	

module Miri
  module Action
    class Spotify < BaseAction
  
      def process(artist_text)
        @artist_text = artist_text
        play_track_for_artist
      end

      def keywords
        [
          'stop music' 
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

      end
    end
  end
end
