CarrierWave.configure do |config|
   if Rails.env.production?
    config.fog_credentials = {
        :provider              => 'AWS',
        :aws_access_key_id     => ENV['S3_BUCKET'],
        :aws_secret_access_key => ENV['S3_KEY'],
        :region                => 'us-west-1',
        :path_style => true
    }
    config.fog_directory  = ENV['S3_SECRET']
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end

