require 'spec_helper'

feature "activity display" do

  before do
    @cat1 = FactoryGirl.create(:category, {name: "Writing", blurb: "About my writing"})
    @cat2 = FactoryGirl.create(:category, {name: "Software", blurb: "stuff I wrote"})
    @cat3 = FactoryGirl.create(:category, {name: "Projects", blurb: "Mad Scientist at work"})
    
    @act1 = FactoryGirl.create(:activity, {name: "Doing the do", :category_id => @cat1.id})
  end

  scenario "displays our list of activities for a particular category" do
    visit display_path("Writing")
    expect(current_path).to eq(display_path("Writing"))
    
  end
  
end