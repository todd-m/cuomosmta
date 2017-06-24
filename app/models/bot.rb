class Bot < ActiveRecord::Base

  def self.find_user(number, words)
    # find tweets
    TWITTER_CLIENT.search(words, lang: 'en').take(number).each do |tweet|

      if self.should_respond_to?(tweet)
        # send a tweet by calling the respond method;
        # the new tweet is a reply to the saved tweet_id
        puts "Responding to #{tweet.user.screen_name}. Cuomo owns the subway!"
        TWITTER_CLIENT.update(Bot.respond(tweet.user.screen_name), in_reply_to_status_id: tweet.id)
      else
        puts "Already responded to #{tweet.user.screen_name}, so letting this one go by."
      end
    end
  end

  # Determine whether to respond to a tweet based on who the user is
  # In future, might want to break out blacklisting/whitelisting into
  # a filter on our users fetch...
  def self.should_respond_to?(tweet)
    # record twitter user so we don't spam them
    user = User.where(user_id: tweet.user.id).first_or_initialize

    # is user whitelisted?
    return true if user.name == 'bluenoteslur'

    # have we responded before? only want to respond once
    return false unless user.id == nil

    # otherwise, let's save the user so we don't spam them...
    user.user_id = tweet.user.id
    user.name = tweet.user.screen_name
    user.tweet_id = tweet.id
    user.save!

    #...and tell the caller to fire off a pithy reply, just this once!
    true
  end

  def self.search_words(words)
    TWITTER_CLIENT.search(words, lang: 'en').first.text
  end

  def self.respond(name)
    "@#{name} #{Time.now}" #{Response.last.message}"
  end
end
