require 'spec_helper'

feature "photos display" do

  
  before do
    Photo::photo_factory
  end

  scenario "normal start of photo gallery" do
    
    visit photos_path
    
  end


end