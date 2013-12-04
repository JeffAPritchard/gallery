require 'spec_helper'

feature "construction page" do

  scenario "displays our construction image by homer" do
    visit '/'

    expect(page).to have_selector(".con_image")
    expect(page).to have_selector(".hidden_home_link")
  end
  
end