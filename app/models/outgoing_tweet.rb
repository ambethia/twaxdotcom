class OutgoingTweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :fax

  def deliver
    user.twitter_client.update([message.truncate(117), fax.permalink].join(' '))
    update_attribute(:tweeted_at, Time.now)
    track
  end

  def track
    Analytics.track(user_id: user.id, event: 'Sent Twax')
  end
  handle_asynchronously :track
end
