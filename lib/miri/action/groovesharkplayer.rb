require_relative 'base_action'
require 'net/http'
require 'json'
require 'rubygems'
require 'grooveshark'

module Miri
  module Action
    class Grooveshark < BaseAction



     def process(artist_text)
        @artist_text = artist_text
        Logger.debug("In Grooveshark process with #{@artist_text}")
        url = perform_query

        command = "mpg123 #{url} < /dev/null &"
        if command == ""
       	 Miri::TextToSpeech.say("I'm sorry, I couldn't find that song.")  
	end

        Logger.debug("URL retrieved: #{url}")
        player_pid = `ps -C mpg123 -o pid=`

        Logger.debug("player_pid: #{player_pid}")

        #if omxplayer pid is exist
        if player_pid.strip != ""
                `kill -9 #{player_pid}`
        end

        t1=Thread.new{ system command}

      end



      def keywords
        [
          'play'
        ]
      end

      private

      def perform_query
	url = `/home/pi/miri/bin/grooveshark  "#{@artist_text}"`
      end


    end
  end
end

