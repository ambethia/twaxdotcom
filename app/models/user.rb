class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  has_many :faxes
  has_many :outgoing_tweets

  after_create :generate_barcode

  after_save :identify_analytics

  def set_default_role
    if User.count == 0
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end

  def generate_barcode
    User.create_phaxio_barcode(self.id)
  end

  class << self
    def create_phaxio_barcode(id)
      user = User.find(id)
      res = Phaxio.send_post('/createPhaxCode', metadata: id.to_s)
      user.update_attributes(phaxio_barcode_url: res['data']['url'])
    end

    handle_asynchronously :create_phaxio_barcode
  end

  def self.update_or_create_with_omniauth(auth)
    user = find_or_initialize_by( :provider => auth['provider'], :uid => auth['uid'].to_s)
    if auth['info']
       user.name = auth['info']['name']
       user.nicknake = auth['info']['nickname']
    end

    if auth['credentials']
      user.token  = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end

    user.oauth_data = auth

    user.save!
    user
  end

  def avatar_url
    oauth_data && oauth_data['info']['image']
  end

  def identify_analytics
    if [name_changed?, nickname_changed?].any?
      Analytics.identify(
          user_id: user.id.to_s,
          traits: {
            name: user.name,
            nickname: user.nickname,
            created_at: user.created_at
      })
    end
  end

# client = Twitter::Streaming::Client.new do |config|
#   config.consumer_key        = "YOUR_CONSUMER_KEY"
#   config.consumer_secret     = "YOUR_CONSUMER_SECRET"
#   config.access_token        = "YOUR_ACCESS_TOKEN"
#   config.access_token_secret = "YOUR_ACCESS_SECRET"
# end

end
