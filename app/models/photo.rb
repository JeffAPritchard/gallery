
class Photo < ActiveRecord::Base
  # require_relative "../../lib/amazon/bucket.rb"
  # require_relative "../../lib/amazon/imagebucket.rb"
  # include Amazon
  
  require "amazon/bucket"
  require "amazon/imagebucket"
  
  validates :file_name, :presence => true, :length => {:minimum => 5}
  
  # this is kinda slow, so we cache it and only get it once when the app wakes up
  @@ImageBucket ||= Amazon::Bucket.new(ImageBucket::IMAGE_BUCKET)
  
  
  # photo_factory is a class method that looks at our Amazon S3 storage and builds a photo record for each file there
  # any files that are already represented by a photo record are of course skipped
  # it makes the brash assumption that if the number of files on S3 is equal to number of records there is nothing to do
  #(that assumption could break with careless deletion and addition of equal number of files between calls -- unlikely)
  def self.photo_factory
    logger.info "WE ARE CHECKING THE FACTORY PROCESS TO SEE IF WE NEED TO MAKE PHOTO OBJECTS"

    if @@ImageBucket.nil?
      # this is kinda slow, so we cache it and only get it once when the app wakes up
      @@ImageBucket ||= Amazon::Bucket.new(ImageBucket::IMAGE_BUCKET)
    end
    
    unless @@ImageBucket.nil?
      files =  @@ImageBucket.get_files_in_folder("big")
      if files.count > Photo.all.count
        logger.info "WE FOUND #{files.count} FILES AND #{Photo.all.count} PHOTO OBJECTS"
        
        files.each do |one_file|
          located_photo = Photo.where(:file_name => one_file).first
          unless located_photo
            logger.info "making a photo for file #{one_file}"
            temp = Photo.create(:file_name => one_file)
          end
        end
        
        # re-get the objects so we can update our count
         @@ImageBucket = Amazon::Bucket.new(ImageBucket::IMAGE_BUCKET)
        
      end
            
    else
      logger.info "Something very bad happened in the photo factory...couldn't find our image bucket"
    end
  end
  
  # Our Amazon S3 storage is set up with an equivalent set of both big and small photos to show to the user
  # The main bucket has two subfolders called big and small
  # When we go to get either a big or small version of a photo, we use the instance methods below to grab the appropriate real url
  def get_big_url
    full_name = "big/#{self.file_name}"
    url = Amazon::Bucket::get_url_from_bucket_name_and_file_name ImageBucket::IMAGE_BUCKET, full_name
  end
  
  def get_small_url
    full_name = "small/#{self.file_name}"
    url = Amazon::Bucket::get_url_from_bucket_name_and_file_name ImageBucket::IMAGE_BUCKET, full_name
  end
  
  def get_display_name
    # we supply the file_name without the ".jpg" as a backup for when there is no gui name
    name = file_name.gsub(/\..*$/, "")
    name = self.gui_name unless self.gui_name.nil? || self.gui_name.empty?
    return name
  end
  
  
end
