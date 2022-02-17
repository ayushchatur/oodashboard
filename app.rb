require 'erubi'
require './command'
require './rimand'

set :erb, :escape_html => true


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

  # Render the view
  erb :appv
end
post '/doit' do
  @src = params[:src]
  @dest = params[:dest]
  @pickup = params[:pickup]
  @gscdata = params[:gscdata]
  @archive = params[:archive]
  @folder = params[:folders]
  @command = Command.new
  @jobid, @error = @command.exec(@src,@dest,@actions,@folder)
  
  # Render the view
  erb :index
end

get '/' do
  @jobid 
  @rimand = Rimand.new
  @jobs, @error = @rimand.exec_jobstats

  # Render the view
  erb :index
end

