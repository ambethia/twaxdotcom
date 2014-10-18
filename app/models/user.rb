class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  has_many :faxes

  def set_default_role
    if User.count == 0
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end

  def self.update_or_create_with_omniauth(auth)
    user = find_or_initialize_by( :provider => auth['provider'], :uid => auth['uid'].to_s)
    if auth['info']
       user.name = auth['info']['name']
    end

    if auth['credentials']
      user.token  = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end

    user.save!
    user
  end


# client = Twitter::Streaming::Client.new do |config|
#   config.consumer_key        = "YOUR_CONSUMER_KEY"
#   config.consumer_secret     = "YOUR_CONSUMER_SECRET"
#   config.access_token        = "YOUR_ACCESS_TOKEN"
#   config.access_token_secret = "YOUR_ACCESS_SECRET"
# end

end
