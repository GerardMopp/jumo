if Rails.env.development?
 ENV["REDISTOGO_URL"] =  'redis://localhost:6379' if Rails.env.development?
end

Sidekiq.configure_server do |config|
  config.redis = {url: ENV["REDISTOGO_URL"], size: 1}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["REDISTOGO_URL"], size: 1}
end

