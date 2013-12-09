require 'spec_helper'

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



end
