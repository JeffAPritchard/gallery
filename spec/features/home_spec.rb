require 'spec_helper'

# googled my fingers off to find this stuff -- lots of misinformation out there on how to test devise with capybara/feature spec
# https://github.com/plataformatec/devise/wiki/How-To%3a-Test-with-Capybara
include Warden::Test::Helpers
Warden.test_mode!

feature "home page" do
  
  before do
    @cat0 = FactoryGirl.create(:category, {name: "Photography", blurb: "my pictures"})
    @cat1 = FactoryGirl.create(:category, {name: "Writing", blurb: "About my writing"})
    @cat2 = FactoryGirl.create(:category, {name: "Software", blurb: "stuff I wrote"})
    @cat3 = FactoryGirl.create(:category, {name: "Projects", blurb: "Mad Scientist at work"})
    
    @admin_user = FactoryGirl.create(:user)
    @admin_role = FactoryGirl.create(:role, {:name => "admin"})
    @admin_user.roles << @admin_role
  end
  
  after do
    Warden.test_reset!
  end

  scenario "displays our simple home page" do
    # go to "root" of app
    visit '/'

    # comment this stuff out when not using construction page as root route
        click_link "home"
    # end of construction page stuff

    # we should be at the home page now
    # see if we have our headers at the top
    expect(page).to have_selector(".title_main")
    
    # look for our main links along the side    
    expect(page).to have_link(@cat0.name)
    find_link(@cat0.name)[:href].should eq("/photos")
    
    expect(page).to have_link(@cat1.name)
    find_link(@cat1.name)[:href].should eq("/display/#{@cat1.name}")
    
    expect(page).to have_link(@cat2.name)
    find_link(@cat2.name)[:href].should eq("/display/#{@cat2.name}")
    
    expect(page).to have_link(@cat3.name)
    find_link(@cat3.name)[:href].should eq("/display/#{@cat3.name}")
    
    
    # only show our add category links for administrators
    expect(page).to_not have_link("Add New Category")
    

    #  look for our about links near the bottom
    expect(page).to have_link('About The Guy')
    find_link('About The Guy')[:href].should eq('/bio_blurb')
    
    expect(page).to have_link('About The Website')
    find_link('About The Website')[:href].should eq('/website_blurb')
    
  end
  

  scenario "shows add cat link for admins" do
       
    # go to "root"
    visit '/'
    login_as(@admin_user, :scope => :user, :run_callbacks => false)

    # comment this stuff out when not using construction page as root route
      click_link "home"
    # end of construction page stuff


    # only show our add category links for administrators
    expect(page).to have_link("Add New Category")
    
  end
  

end