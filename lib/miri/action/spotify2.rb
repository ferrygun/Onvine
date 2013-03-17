require_relative 'base_action' 	

module Miri
  module Action
    class YourName < BaseAction
  
      def process(artist_text)
        @artist_text = artist_text
        play_track_for_artist
      end

      def keywords
        [
          'who are you',
          'what is your name',
          'what\'s your name' 
        ]
      end

      private

      def play_track_for_artist
	Miri::TextToSpeech.say("My name is Ivy. How may I assist you ?")
      end
    	
    end
  end
end
