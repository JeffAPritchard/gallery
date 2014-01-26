class HomeController < ApplicationController

  def index
    
    @categories = Category.all
  end
  
  def bio_blurb
  end
  
  def website_blurb
  end
  
  
  
  def replace_about_section
    @id = '#about-section'
    @renderable = 'about_tabs.html.haml'
    
    respond_to do |format|
      # render new_page.js.erb
      format.js 
      
      # shouldn't ever get here
      format.html {redirect_to photos_url}
    end
    
  end
  
  
end
