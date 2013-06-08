config = YAML.load(ERB.new(File.read('config/evernote.yml')).result)[Rails.env]
#site = config['sandbox'] ? 'https://sandbox.evernote.com' : 'https://www.evernote.com'
site = 'https://www.evernote.com'

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :evernote, mauriziocalo, config['consumer_secret'], :client_options => {:site => site}
  provider :evernote, mauriziocalo, "406c3d9577c1de59", :client_options => {:site => site}
end

OmniAuth.config.on_failure = LoginController.action(:oauth_failure)
