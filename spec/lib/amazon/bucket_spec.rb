require_relative "../../../lib/amazon/bucket.rb"
require 'aws/s3'

describe Amazon::Bucket do
  
  let(:bucket) {Amazon::Bucket.new('jeffp-test')}
  
  describe "normal functionality" do
    
    it "finds my bucket" do
      expect(bucket).not_to be_nil
    end
    
    it "finds my objects" do
      obj = bucket.get_objects
      expect(obj).not_to be_nil
    end
    
    it "finds my files" do
      files = bucket.get_files
      expect(files).not_to be_empty
      # files.each{|file| pp file }
    end
    
    # NOTE: Assumes a test file called "test.txt" in the test bucket with content of "foo"
    it "finds my test file" do
      test = bucket.get_file("test.txt")
      expect(test).to eq("foo")
    end
    
    # Note: Assumes a test image file in a "jeffp-images" bucket (adjust bucket name accordingly)
    it "makes a good url for my test image" do
      image_bucket = Amazon::Bucket.new('jeffp-images')
      files = image_bucket && image_bucket.get_files
      
      if files
        test_file_url = image_bucket.get_url_for_file_name files.first
        pp test_file_url
        expect(test_file_url).not_to be_empty
      end
      
      #  TO-DO
      # use Selenium to actually bring up the url and verify that we can get there
    end
    
    
  end
  
  
end