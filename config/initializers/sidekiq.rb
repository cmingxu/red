Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://demo.hengdingsheng.com:7777' }
  config.average_scheduled_poll_interval = 3
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://demo.hengdingsheng.com:7777' }
end

Sidekiq::Extensions.enable_delay!
