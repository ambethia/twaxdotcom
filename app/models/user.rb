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
       user.nickname = auth['info']['nickname']
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
        user_id:      self.id,
        traits: {
          name:       self.name,
          nickname:   self.nickname,
          created_at: self.created_at
        }
      )
    end
  end

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.omniauth_provider_key
      config.consumer_secret     = Rails.application.secrets.omniauth_provider_secret
      config.access_token        = token
      config.access_token_secret = secret
    end
  end
end
