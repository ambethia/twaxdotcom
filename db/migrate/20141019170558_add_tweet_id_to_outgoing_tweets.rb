class AddTweetIdToOutgoingTweets < ActiveRecord::Migration
  def change
    add_column :outgoing_tweets, :tweet_id, :integer
  end
end
