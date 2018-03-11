require 'sinatra'

set :database_url, ENV['DATABASE_URL'] || "sqlite3://#{File.join(Dir.pwd, "iamalive.db")}"

require_relative './iamalive'
run Sinatra::Application
