require 'erubi'
require './command'
require './rimand'

set :erb, :escape_html => true

if development?
  require 'sinatra/reloader'
  also_reload './command.rb'
end

helpers do
  def dashboard_title
    "Open OnDemand"
  end

  def dashboard_url
    "/pun/sys/dashboard/"
  end

  def title
    "Passenger App Processes"
  end
end

# Define a route at the root '/' of the app.
get '/doit' do
  @command = Command.new
  @processes, @error = @command.exec

  # Render the view
  erb :appv
end
post '/doit' do
  @name = params[:username]
  # @command = Command.new
  # @processes, @error = @command.exec
  
  # Render the view
  erb :appv
end

get '/' do
  @command = Rimand.new
  @jobs, @error = @command.exec_jobstats

  # Render the view
  erb :index
end

