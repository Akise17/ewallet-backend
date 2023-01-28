module Whatsapp
  class Message
    include HTTParty
    require 'uri'
    require 'net/http'

    TOKEN = ENV['WHATSAPP_TOKEN']
    base_uri ENV['WHATSAPP_API_URL']

    def self.send(number, message)
      data = { token: TOKEN,
               number: number.to_s,
               message: }
      create(data)
    end

    def self.create(body)
      post('/sendmessage',
           headers: {
             "Content-Type": 'application/json'
           },
           body: body.to_json)
    end
  end
end
