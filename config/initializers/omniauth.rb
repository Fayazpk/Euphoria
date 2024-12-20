# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
    ENV['GOOGLE_CLIENT_ID'], 
    ENV['GOOGLE_CLIENT_SECRET'], 
    {
      scope: 'email,profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50,
      access_type: 'offline',
      skip_jwt: true
    }
end

# Add OmniAuth failure handling
OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
