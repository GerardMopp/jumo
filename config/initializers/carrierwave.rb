CarrierWave.configure do |config|
   if Rails.env.production?
    config.fog_credentials = {
        :provider              => 'AWS',
        :aws_access_key_id     => ENV['S3_KEY'],
        :aws_secret_access_key => ENV['S3_SECRET'],
        :region                => 'us-west-2',
        :path_style => true
    }
    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_public     = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end

