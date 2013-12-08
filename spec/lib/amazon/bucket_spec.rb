require_relative "../../../lib/amazon/bucket.rb"
require 'aws/s3'

describe Amazon::Bucket do
  
  let(:bucket) {Amazon::Bucket.new('jeffpimages')}
  
  
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
    
    it "finds my test image" do
      test = bucket.get_file("test.txt")
      expect(test).to eq("foo")
    end
    
  end
  
  
end