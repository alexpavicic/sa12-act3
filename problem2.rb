require 'httparty'
require 'json'

class CurrencyConverter
    
    include HTTParty
    base_uri 'https://v6.exchangerate-api.com/v6'

    def initialize(api_key)
        @api_key = api_key
    end

    def converter(amount, from_currency, to_currency)
        response = self.class.get("/#{@api_key}/latest/#{from_currency}")
        if response.code == 200
            json_response = JSON.parse(response.body)
            exchange_rate = json_response['conversion_rates'][to_currency]
            converted_amount = amount * exchange_rate
            "#{amount} #{from_currency} is equal to #{converted_amount.round(2)} #{to_currency}"
        end
    end
end

api_key = 'f5929453afefedd98576071d'
currency_converter = CurrencyConverter.new(api_key)

amount = 1
from_currency = 'USD'
to_currency = 'EUR'

puts currency_converter.converter(amount, from_currency, to_currency)