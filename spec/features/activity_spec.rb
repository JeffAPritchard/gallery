require 'spec_helper'

feature "activity display" do

  before do
    @cat1 = FactoryGirl.create(:category, {name: "Writing", blurb: "About my writing"})
    @cat2 = FactoryGirl.create(:category, {name: "Software", blurb: "my github stuff"})
    @cat3 = FactoryGirl.create(:category, {name: "Projects", blurb: "Mad Scientist at work"})
    
    @act1 = FactoryGirl.create(:activity, {name: "One Thing I wrote", :category_id => @cat1.id, :url => "first"})
    @act2 = FactoryGirl.create(:activity, {name: "Something else I wrote", :category_id => @cat1.id, :url => "second"})
    @act3 = FactoryGirl.create(:activity, {name: "first batch of code", :category_id => @cat2.id, :url => "third"})
  end
  
  

  scenario "displays our list of activities for a particular category" do
    visit display_path("Writing")
    expect(current_path).to eq(display_path("Writing"))
    
    expect(page).to have_link(@act1.name)
    find_link(@act1.name)[:href].should eq("http://#{@act1.url}")
    
    expect(page.all('.activity_list_element').size).to eq(2)
  end
  
  scenario "displays appropriate emptiness with empty category" do
    visit display_path("Projects")
    expect(current_path).to eq(display_path("Projects"))
    
    expect(page).not_to have_link(@act1.name)
    
    expect(page).to have_content("There is nothing in this category yet...")
    
    expect(page).to have_link("Home")
    
    expect(page.all('.activity_list_element').size).to eq(0)
  end
  
  
end