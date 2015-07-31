OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1592913730989299', '1c1febe5e95dfc079ce1f8d748081808', {:scope => 'email'}
  provider :twitter, Settings.twitter.consumer_key, Settings.twitter.consumer_secret
end


