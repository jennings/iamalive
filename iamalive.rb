# Copyright 2013 Stephen Jennings
# Licensed under the Apache License, Version 2.0.

require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'dm-postgres-adapter'


# MODELS

DataMapper.setup(:default, ENV['DATABASE_URL'])

class Checkin
    include DataMapper::Resource

    property :id,               Serial
    property :computer_name,    String
    property :timestamp,        DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!


# ROUTES

get '/' do
    retval = "<ul>\n"
    Checkin.all.map { |checkin|
        retval += "<li>#{checkin.computer_name} at #{checkin.timestamp}</li>\n"
    }
    retval += "</ul>\n"
    return retval
end

post '/checkin' do
    computer_name = params["computer_name"]
    timestamp = Time.new

    checkin = Checkin.create(
        :computer_name => computer_name,
        :timestamp => timestamp
    )

    "Checkin for #{computer_name} at #{timestamp} created!"
end
