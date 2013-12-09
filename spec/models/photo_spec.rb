require 'spec_helper'
require_relative "../../lib/amazon/bucket.rb"

describe Photo do

  describe "url_to_url_slug" do
    
    it "turns a regular S3 url into a slugged url without the big/small folder" do
      typical_url = "http://jeffp-images.s3-website-us-east-1.amazonaws.com/big/foo.jpg"    
      slug = Photo::url_to_url_slug(typical_url)    
      # pp slug    
      expect(slug).not_to match("big")
      expect(slug).not_to match("small")
      expect(slug).to match("@")
    end

  end

  describe "url_slug_to_big_url" do
    
    it "turns a url slug into a real and usable url" do
      typical_slug_url = "http://jeffp-images.s3-website-us-east-1.amazonaws.com/@/foo.jpg"    
      url = Photo::url_slug_to_big_url(typical_slug_url)    
      # pp url    
      expect(url).not_to match("@")
      expect(url).to match("big")
    end

  end

  describe "url_slug_to_small_url" do
    
    it "turns a url slug into a real and usable url" do
      typical_slug_url = "http://jeffp-images.s3-website-us-east-1.amazonaws.com/@/foo.jpg"    
      url = Photo::url_slug_to_small_url(typical_slug_url)    
      # pp url    
      expect(url).not_to match("@")
      expect(url).to match("small")
    end

  end


  describe "photo_factory" do
    let(:bucket1) {Amazon::Bucket.new('jeffp-images')}
    
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
