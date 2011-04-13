require 'sinatra'
require './lyrics'

get '/' do
  @lyrics = LyricDownloader.new(params[:q]).download if params[:q]
  haml :index
end

get '/style.css' do
  scss :style
end
