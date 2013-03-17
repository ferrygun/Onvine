require_relative 'base_action' 	
require 'net/http'
require 'json'
require 'nokogiri'
require "duck_duck_go"

module Miri
  module Action
    class WolframAlpha < BaseAction

      QUERY_URI="http://api.wolframalpha.com/v2/query"

      def process(artist_text)
        @search_text = artist_text
        result = perform_query
        Miri::TextToSpeech.say(result)

        if result != ""
		 result = `/home/pi/miri/bin/duckduckgorb  "#{@search_text}"`
        	Miri::TextToSpeech.say(result)
	else
	 	Miri::TextToSpeech.say("I am sorry, I couldn't find the answer")
        end
      end

      def keywords
        [ '' ]
      end

      private

      def perform_query
        result = ""

        uri = URI("#{QUERY_URI}?input=#{URI.escape(@search_text)}&appid=APGRUW-QRK733YHL5")
        response = Net::HTTP.get_response(uri)

        begin
          xml_doc  = Nokogiri::XML(response.body)
          result = xml_doc.xpath("//queryresult/pod[1]/subpod/plaintext/text()").text +  xml_doc.xpath("//queryresult/pod[2]/subpod/plaintext/text()").text
          Logger.debug("Result is: #{result}")
        rescue Exception => e
          Logger.error("An error occurred querying WolframAlpha.")
          Logger.error("#{e.message}")
        end

        return result
      end
    end
  end
end
