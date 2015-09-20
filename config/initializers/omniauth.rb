Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GH_BASIC_CLIENT_ID'], ENV['GH_BASIC_SECRET_ID'], scope: "repo,write:repo_hook"
end
