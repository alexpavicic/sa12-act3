require 'httparty'
require 'json'
include HTTParty

class WeatherDataAggregator
    base_uri 'http://api.openweathermap.org/data/2.5'

    def initialize(api_key)
        @api_key = api_key
    end
    
    def fetch_weather(city)
        response = self.class.get("/weather?q=#{city}&APPID=#{@api_key}&units=metric")
        if response.code == 200
            json_response = JSON.parse(response.body)
            temperature = json_response['main']['temp']
            humidity = json_response['main']['humidity']
            conditions = json_response['weather'][0]['description']
            { temperature: temperature, humidity: humidity, conditions: conditions }
        end
    end

    def calculate_average_temperature(city, hours)
        hourly_temperatures = []
    
        
        response = self.class.get("/forecast?q=#{city}&APPID=#{@api_key}&units=metric")
        
        if response.code == 200
            json_response = JSON.parse(response.body)
            
            json_response['list'].first(hours).each do |forecast|
                temperature = forecast['main']['temp']
                hourly_temperatures << temperature
            end
            
            total_temperature = hourly_temperatures.inject(0.0) { |sum, temp| sum + temp }
            average_temperature = total_temperature / hours
            average_temperature.round(2)
        end
    end  
end

api_key = '26b52c4ab7b6e3660455114bfdddc8ae'
weather_aggregator = WeatherDataAggregator.new(api_key)

city = 'Dubrovnik, HR'
current_weather = weather_aggregator.fetch_weather(city)
    
puts "Current temperature in #{city}: #{current_weather[:temperature]}°C"
puts "Current humidity in #{city}: #{current_weather[:humidity]}%"
puts "Current weather conditions in #{city}: #{current_weather[:conditions]}"

hours = 24
average_temperature = weather_aggregator.calculate_average_temperature(city, hours)

puts "Average temperature in #{city} over last #{hours} hours: #{average_temperature}°C"