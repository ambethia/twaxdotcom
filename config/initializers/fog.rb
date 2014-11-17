CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Rails.application.secrets.aws_access_key_id,
    :aws_secret_access_key  => Rails.application.secrets.aws_secret_access_key,
    :region                 => 'us-east-1',
  }
  config.fog_directory  = 'twax'
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"}
end

Excon.defaults[:ssl_verify_peer] = false
