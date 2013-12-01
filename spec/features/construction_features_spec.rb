require 'spec_helper'

feature "construction page" do

  scenario "displays our construction image by homer" do
    visit '/'

    expect(page).to have_selector(".con_image")
  end
  
  

end