require 'httparty'
require 'json'

class EventFinder
  include HTTParty

  base_uri 'https://app.ticketmaster.com/discovery/v2'

  def initialize(api_key)
    @api_key = api_key
  end

    def find_events(location)
        response = self.class.get("/events.json", query: { apikey: @api_key, city: location })

        if response.code == 200

            events = JSON.parse(response.body)['_embedded']['events']
            events.map do |event|
                {
                    name: event['name'],
                    venue: event['_embedded']['venues'][0]['name'],
                    date: event['dates']['start']['localDate'],
                    time: event['dates']['start']['localTime']
                }
            end
        end
    end
end

api_key = 'uPC5ZkivkUeujxfwTYa0xzW5dcOFeRrN'
event_finder = EventFinder.new(api_key)

location = 'Memphis' 
events = event_finder.find_events(location)
puts "Upcoming events in #{location}:"
events.each do |event|
    puts "Name: #{event[:name]}, Venue: #{event[:venue]}, Date: #{event[:date]}, Time: #{event[:time]}"
end
