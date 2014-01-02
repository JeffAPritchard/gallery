require 'spec_helper'
require_relative "../../lib/amazon/bucket.rb"
require_relative "../../lib/amazon/imagebucket.rb"


describe Photo do
  
  describe "Photo" do
    
    it "is valid with file_name" do
      photo = Photo.new(:file_name => "foobar.jpg")
      expect(photo).to be_valid
    end
  
    it "should not be valid without a file_name" do
      photo = Photo.create()
      expect(photo).to_not be_valid
    end
  end

  describe "get_big_url" do
    let(:bucket1) {Amazon::Bucket.new(ImageBucket::IMAGE_BUCKET)}
    
    it "turns a regular S3 url into a slugged url without the big/small folder" do
      # typical_url = "https://#{ImageBucket::IMAGE_BUCKET}.s3-website-us-east-1.amazonaws.com/big/foo.jpg"  
      files = bucket1.get_files_in_folder("big")
      test_image_file = files.first
      test_image_photo = FactoryGirl.build(:photo, :file_name => test_image_file)
      big_url =   test_image_photo.get_big_url
      # pp big_url    
      expect(big_url).to match("big")
      expect(big_url).to match(test_image_file)
      expect(big_url).to match(ImageBucket::IMAGE_BUCKET)
    end

  end
  

  describe "get_small_url" do
    let(:bucket1) {Amazon::Bucket.new(ImageBucket::IMAGE_BUCKET)}
    
    it "turns a regular S3 url into a slugged url without the big/small folder" do
      # typical_url = "https://#{ImageBucket::IMAGE_BUCKET}.s3-website-us-east-1.amazonaws.com/small/foo.jpg"  
      files = bucket1.get_files_in_folder("small")
      test_image_file = files.first
      test_image_photo = FactoryGirl.build(:photo, :file_name => test_image_file)
      small_url =   test_image_photo.get_small_url
      # pp small_url    
      expect(small_url).to match("small")
      expect(small_url).to match(test_image_file)
      expect(small_url).to match(ImageBucket::IMAGE_BUCKET)
    end

  end

  describe "get display name" do
    it "returns a valid name even with only a filename" do
      photo = Photo.new(:file_name => "foobar.jpg")
      expect(photo.get_display_name).to_not be_empty
    end
    
    it "returns file name without extension with only a filename" do
      photo = Photo.new(:file_name => "foobar.jpg")
      expect(photo.get_display_name).to eq("foobar")
    end
    
    it "returns returns the gui name if it exists" do
      photo = Photo.new(:file_name => "foobar.jpg", :gui_name => "myguiness")
      expect(photo.get_display_name).to eq("myguiness")
    end
    
  end


  describe "photo_factory" do
    let(:bucket1) {Amazon::Bucket.new(ImageBucket::IMAGE_BUCKET)}
    
    it "creates photo records for any orphaned images on Amazon S3 storage" do
      # first verify that we have some images and no photo records
      files = bucket1.get_files_in_folder("big")
      expect(files).not_to be_empty
      photo_count = Photo.all.count
      expect(photo_count).to eq(0)
      
      # now call the factory and verify that we have a photo record for each file
      Photo::photo_factory
      photo_count = Photo.all.count
      expect(photo_count).to eq(files.size)
      
      # now verify that it doesn't re-create it again if we call factory again
      Photo::photo_factory
      photo_count = Photo.all.count
      expect(photo_count).to eq(files.size)
      
    end
    
  end


end
