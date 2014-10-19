class CreateOutgoingTweets < ActiveRecord::Migration
  def change
    create_table :outgoing_tweets do |t|
      t.references :user, index: true
      t.references :fax, index: true
      t.string :message
      t.datetime :tweeted_at

      t.timestamps null: false
    end
  end
end
