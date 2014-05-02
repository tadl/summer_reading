OmniAuth.config.full_host = "http://railsbox-1-40317.use1.nitrousbox.com"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["google_api_key"], ENV["google_api_secret"], :prompt => 'select_account', :scope => "userinfo.email,userinfo.profile"
end