require 'sinatra'
require './lyrics_downloader'

get '/' do
  @lyrics = LyricsDownloader.new(params[:q]).download if params[:q]
  haml :index
end

get '/style.css' do
  scss :style
end
