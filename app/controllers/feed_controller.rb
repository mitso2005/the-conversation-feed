class FeedController < ApplicationController
  RSS_URL = 'https://theconversation.com/au/articles.atom'

  def index
    response = HTTParty.get(RSS_URL)
    feed = Feedjira.parse(response.body)
    @articles = feed.entries.map do |entry|
      {
        title: entry.title,
        url: entry.url,
        thumbnail: entry.image || nil
      }
    end
  end
end