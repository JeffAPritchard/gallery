class HomeController < ApplicationController
  def index
    
    @categories = Category.all
  end
  
  def bio_blurb
  end
  
  def website_blurb
  end
  
  
end
