require 'spec_helper'

# googled my fingers off to find this stuff -- lots of misinformation out there on how to test devise with capybara/feature spec
# https://github.com/plataformatec/devise/wiki/How-To%3a-Test-with-Capybara
include Warden::Test::Helpers
Warden.test_mode!

feature "activity display" do

  let!(:cat1) {FactoryGirl.create(:category, {name: "Writing", blurb: "About my writing"})}
  let!(:cat2) {FactoryGirl.create(:category, {name: "Software", blurb: "my github stuff"})}
  let!(:cat3) {FactoryGirl.create(:category, {name: "Projects", blurb: "Mad Scientist at work"})}
  
  let!(:act1) {FactoryGirl.create(:activity, {name: "One Thing I wrote", :category_id => cat1.id, :url => "first"})}
  let!(:act2) {FactoryGirl.create(:activity, {name: "Something else I wrote", :category_id => cat1.id, :url => "second"})}
  let!(:act3) {FactoryGirl.create(:activity, {name: "first batch of code", :category_id => cat2.id, :url => "third"})}

  let(:admin_user) {FactoryGirl.create(:user)}
  let(:admin_role) {FactoryGirl.create(:role, {:name => "admin"})}

  before do
    admin_user.roles << admin_role
  end
  
  after do
    Warden.test_reset!
  end
  
  

  scenario "displays our list of activities for a particular category" do
    visit display_path("Writing")
    expect(current_path).to eq(display_path("Writing"))
    
    expect(page).to have_link(act1.name.titleize)
    find_link(act1.name.titleize)[:href].should eq("http://#{act1.url}")
    
    expect(page).to have_link(act2.name.titleize)
    find_link(act2.name.titleize)[:href].should eq("http://#{act2.url}")
    
    expect(page.all('.activity_list_element').size).to eq(2)
  end
  
  scenario "does NOT display activities of another category" do
    visit display_path("Writing")
    expect(current_path).to eq(display_path("Writing"))
    
    expect(page).to_not have_link(act3.name.titleize)
  end
  
  scenario "displays appropriate emptiness with empty category" do
    visit display_path("Projects")
    expect(current_path).to eq(display_path("Projects"))
    
    expect(page).not_to have_link(act1.name)
    
    expect(page).to have_content("There is nothing in this category yet...")
    
    expect(page).to have_link("Jeff Pritchard")
    
    expect(page.all('.activity_list_element').size).to eq(0)
  end
  
  scenario "does not show new activity link to plebians" do
    visit display_path("Writing")
    expect(page).to_not have_link("Add New Activity")
  end
  

  scenario "shows add cat link for admins" do
       
    # go to "root"
    login_as(admin_user, :scope => :user, :run_callbacks => false)
    visit display_path("Writing")


    # only show our add category links for administrators
    expect(page).to have_link("Add New Activity")
    
  end
  
  
  
end