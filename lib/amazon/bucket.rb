require 'aws/s3'

module Amazon
  # !!!!!! NOTE !!!!!! -- your slug may be slightly different - also must use AWS S3 console to enable web property for bucket
  AWS_SLUG = ".s3-website-us-east-1.amazonaws.com/"

  class Bucket
    
    attr_reader :bucket
  
    def initialize bucket_name
      @bucket_name = bucket_name
      @secrets = YAML.load_file('config/secrets/rubber-secret.yml')
      @aws = (@secrets['cloud_providers'])['aws']
      @secrets_id = @aws['access_key']
      @secrets_key = @aws['secret_access_key']
  
      AWS::S3::Base.establish_connection!(
          :access_key_id     => @secrets_id,
          :secret_access_key => @secrets_key
        )
    
      @bucket = AWS::S3::Bucket.find(bucket_name)
    end
    
    def get_objects
      objects = @bucket.objects
      pp objects
      objects
    end
    
    def get_files
      raw_objects = @bucket.objects
      
      # raw objects from AWS look like this:
      # [#<AWS::S3::S3Object:0x70187303059220 '/jeffpimages/IMG_0024.jpg'>,
      #  #<AWS::S3::S3Object:0x70187303059200 '/jeffpimages/error.html'>,
      #  #<AWS::S3::S3Object:0x70187303059180 '/jeffpimages/index.html'>,
      #  #<AWS::S3::S3Object:0x70187303059160 '/jeffpimages/test.jpg'>]
      
      # map the array above into an array of just the file names
      file_names = raw_objects && raw_objects.map {|obj| obj.key}
        
    end
    
    def get_file name
      bucket[name] && bucket[name].value
    end
    
    def get_url_for_file_name name
      
      # the url is of the form:  http://(bucket-name)AWS_SLUG(file-name)
      url = "http://#{@bucket_name}#{AWS_SLUG}#{name}"
    end
      
  
  end

end