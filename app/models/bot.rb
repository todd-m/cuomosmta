class Bot < ActiveRecord::Base

  def self.find_user(number, words)
    # find tweets
    TWITTER_CLIENT.search(words, lang: 'en').take(number).each do |tweet|

      # record twitter user so we don't spam them
      user = User.where(name: tweet.user.screen_name, tweet_id: tweet.id.to_s, 
        user_id: tweet.user.id).first_or_create

      # send a tweet by calling the respond method;
      # the new tweet is a reply to the saved tweet_id
      if self.should_respond_to?(user)
        TWITTER_CLIENT.update(Bot.respond(tweet.user.screen_name), in_reply_to_status_id: tweet.id)
      else
        puts "Not responding to user #{user}."
      end
    end
  end

  # Determine whether to respond to a tweet based on who the user is
  # In future, might want to break out blacklisting/whitelisting into
  # a filter on our users fetch...
  def self.should_respond_to?(user)
    # is user whitelisted?
    true if user.name == 'bluenoteslur'
    # TODO have we responded before? only want to respond once
    false

    #TODO otherwise, let's reply just this once!
  end

  def self.search_words(words)
    TWITTER_CLIENT.search(words, lang: 'en').first.text
  end

  def self.respond(name)
    "@#{name} #{Response.last.message}"
  end
end
