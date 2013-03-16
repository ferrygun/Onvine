require_relative 'base_action'
require 'net/http'
require 'json'

module Miri
  module Action
    class PlayYoutube < BaseAction

      BIO_URI='http://gdata.youtube.com/feeds/api/videos'


     def process(artist_text)
        @artist_text = artist_text
        Logger.debug("In Youtube process with #{@artist_text}")
        bio = perform_query

        #save info for playing again
        `echo '#{bio}' > /home/pi/miri/data/history.txt`

        command = "/home/pi/miri/bin/omxplayyt.sh #{bio}"

        Logger.debug("Bio retrieved: #{bio}")
        omxplayer_pid = `ps -C omxplayer.bin -o pid=`

        Logger.debug("omxplayer_pid: #{omxplayer_pid}")

        #if omxplayer pid is exist
        if omxplayer_pid.strip != ""
                `kill -9 #{omxplayer_pid}`
        end
        t1=Thread.new{ system command}
        #`/home/pi/miri/bin/omxplayyt.sh #{bio}`

      end



      def keywords
        [
          'play'
        ]
      end

      private

      def perform_query
        bio = ""

        uri = URI("#{BIO_URI}?q=#{URI.escape(@artist_text)}&alt=jsonc&max-results=1&start-index=1&ordering=most_viewed&v=2")
        response = Net::HTTP.get_response(uri)



       begin
          bio = JSON.parse(response.body)["data"]["items"][0]["player"]["default"]
       rescue Exception => e
          Logger.error("An error occurred retrieving a bio using Youtube for artist #{@artist_name}")
       end

      end

    end
  end
end

