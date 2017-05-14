if Rails.env.development?
 ENV["REDISCLOUD_URL"] =  'redis://localhost:6379' if Rails.env.development?
end

Sidekiq.configure_server do |config|
  config.redis = {url: ENV["REDISCLOUD_URL"]}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["REDISCLOUD_URL"]}
end

