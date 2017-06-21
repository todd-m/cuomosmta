class Bot < ActiveRecord::Base

  def self.search_words(words)
    TWITTER_CLIENT.search(words, lang: 'en').first.text
  end
end
