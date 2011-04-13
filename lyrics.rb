require 'nokogiri'
require 'open-uri'
require 'cgi'

class LyricDownloader
  DOWNLOADERS = {
    /www\.sing365\.com/ => lambda { |html|
      html.gsub(/.*<img src=http:\/\/www\.sing365\.com\/images\/phone2\.gif border=0><br><br><\/div>(.*?)^<div align="center"><br><br>.*/m, '\1')
    },
    /www\.azlyrics\.com/ => lambda { |html|
      html.gsub(/.*^<!-- start of lyrics -->(.*?)^<!-- end of lyrics -->.*/m, '\1')
    },
    /www\.lyricsfreak\.com/ => lambda { |html|
      Nokogiri(html).search('div#content_h').inner_html
    },
    /www\.lyrics007\.com/ => lambda { |html|
      html.gsub("\r", "\n").gsub(/.*^\s<\/script><br><br><br>(.*)^<br><br><script type="text\/javascript">.*/m, '\1')
    }
  }

  def initialize(artist_title_etc)
    @artist_title_etc = artist_title_etc
  end

  def download
    google_links.each do |url|
      if lyrics = get_lyrics(url)
        return lyrics
      end
    end
  end

  private

  def google_url
    "http://www.google.com/search?q=#{ search_query }"
  end
  
  def search_query
    CGI.escape(@artist_title_etc + " lyrics")
  end

  def google_links
    doc = Nokogiri(open(google_url).read)
    doc.search('a.l').map { |link| link.attr(:href) }
  end

  def downloader_for(url)
    DOWNLOADERS.find { |re, downloader| break downloader if url.match(re) }
  end

  def get_lyrics(url)
    if downloader = downloader_for(url)
      downloader.call(open(url).read).strip.split(/<br>/i).map(&:strip)
    end
  end
end

if __FILE__ == $0
  if ARGV.empty?
    title = `osascript -e 'tell application "iTunes" to if player state is playing then artist of current track & " " & name of current track'`
  else
    title = ARGV.join(" ")
  end

  if title && !title.empty?
    if lyrics = LyricDownloader.new(title).download
      puts lyrics
    else
      puts "No lyrics found"
    end
  else
    puts "Usage: #$0 pink floyd comfortably numb"
  end
end
