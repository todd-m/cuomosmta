class Bot < ActiveRecord::Base

  def self.find_user(number, words)
    # find tweets
    TWITTER_CLIENT.search(words, lang: 'en').take(number).each do |tweet|

      # record twitter user so we don't spam them
      User.create(name: tweet.user.screen_name, tweet_id: tweet.id.to_s)

      # send a tweet by calling the respond method;
      # the new tweet is a reply to the saved tweet_id
      TWITTER_CLIENT.update(Bot.respond(tweet.user.screen_name), in_reply_to_status_id: tweet.id)
    end
  end

  def self.search_words(words)
    TWITTER_CLIENT.search(words, lang: 'en').first.text
  end

  def self.respond(name)
    "@#{name} #{Response.last.message}"
  end
end
