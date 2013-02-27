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

    property :id,                   Serial
    property :organization_name,    String
    property :computer_name,        String
    property :timestamp,            DateTime

    def self.purge_outdated
        # Remove checkins older than 3 days
        cutoff = Time.now - 3 * (24*60*60)
        Checkin.all(:timestamp.lt => cutoff).destroy
    end
end

DataMapper.finalize
DataMapper.auto_upgrade!


# ROUTES

get '/' do
    retval = "<h1>Checkins</h1>\n"
    retval += "<ul>\n"
    Checkin.all(:order => [ :timestamp.desc ]).map { |checkin|
        retval += "<li>#{checkin.computer_name} at #{checkin.timestamp.strftime('%Y-%m-%d at %H:%M:%S')}</li>\n"
    }
    retval += "</ul>\n"
    return retval
end

get '/purge' do
    Checkin.purge_outdated
    redirect '/'
end

post '/checkin' do
    computer_name = params["computer_name"]
    timestamp = Time.new

    checkin = Checkin.create(
        :computer_name => computer_name,
        :timestamp => timestamp
    )

    Checkin.purge_outdated

    "Checkin for #{computer_name} at #{timestamp} created!"
end
