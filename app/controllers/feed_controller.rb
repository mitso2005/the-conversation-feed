require 'httparty'
require 'feedjira'
require 'nokogiri'
require 'cgi'

class FeedController < ApplicationController
  RSS_URL = 'https://theconversation.com/au/articles.atom'

  def index
    response = HTTParty.get(RSS_URL)
    feed = Feedjira.parse(response.body)
    @articles = feed.entries.map do |entry|
      # Decode HTML entities before parsing
      html_content = CGI.unescapeHTML(entry.content || "")
      doc = Nokogiri::HTML(html_content)

      # Prefer <img> inside the first <figure>
      figure_img = doc.at_css('figure img')
      img_tag = figure_img || doc.at_css('img')
      thumbnail = img_tag ? img_tag['src'] : nil

      {
        title: entry.title,
        url: entry.url,
        thumbnail: thumbnail
      }
    end
  end
end