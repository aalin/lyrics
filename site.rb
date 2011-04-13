require 'sinatra'
require 'haml'
require 'sass'
require './lyrics_downloader'

get '/' do
  @lyrics = LyricsDownloader.new(params[:q]).download if params[:q]
  haml :index
end

get '/style.css' do
  scss :style
end

__END__

@@ index
!!! 5
%html
  %head
    %title Lyrics
    %link{ :rel => "stylesheet", :href => "style.css" }
  %body
    #content
      %h1 Lyrics
      %form{ :action => '/', :method => 'get' }
        %input{ :type => 'text', :name => 'q', :value => params[:q] }
      - if @lyrics
        %p.lyrics= @lyrics.join("<br>")

@@ style
html {
	background-color: #80002f;
	font-size: 12px;
	font-family: Helvetica;
}

#content {
	width: 600px;
	margin: 0px auto;
	background-color: #fff;
	border-radius: 5px;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	text-align: center;

	h1 {
		margin: 0px;
		padding: 20px;
		background-color: #f0f0f0;
		border-bottom: 1px solid #ccc;

		border-radius: 5px 5px 0px 0px;
		-webkit-border-radius: 5px 5px 0px 0px;
		-moz-border-radius: 5px 5px 0px 0px;
	}

	.lyrics {
		font-size: larger;
		padding: 20px;
		margin: 0px;
	}

	form {
		input {
			font-size: 20px;
			margin-top: 20px;
			width: 50%;
			border: 1px solid #ccc;
			text-align: center;
		}
	}
}
