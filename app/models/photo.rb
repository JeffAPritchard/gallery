class Photo < ActiveRecord::Base
  
  
  
  
  # Our Amazon S3 storage is set up with an equivalent set of both big and small photos to show to the user
  # The main bucket has two subfolders called big and small
  # The url_slug we build when we initialize a new "photo" record replaces that "big" or "small" with an @
  # When we go to get either a big or small version of a photo, we use the class methods below to grab the appropriate real url
  def self.url_to_url_slug full_url
    # remove either big or small from the url for generic slug storage
    url = full_url.gsub("/big", "/@")
    url = url.gsub("/small", "/@")
  end
  
  def self.url_slug_to_big_url slug_url
    # replace @ in slug with "big" folder name
    url = slug_url.gsub("/@", "/big")
  end
  
  def self.url_slug_to_small_url slug_url
    # replace @ in slug with "small" folder name
    url = slug_url.gsub("/@", "/small")
  end
  
end
