require 'spec_helper'

feature "home page" do
  
  before do
    @cat0 = FactoryGirl.create(:category, {name: "Potography", blurb: "my pictures"})
    @cat1 = FactoryGirl.create(:category, {name: "Writing", blurb: "About my writing"})
    @cat2 = FactoryGirl.create(:category, {name: "Software", blurb: "stuff I wrote"})
    @cat3 = FactoryGirl.create(:category, {name: "Projects", blurb: "Mad Scientist at work"})
  end

  scenario "displays our simple home page" do

    # comment this stuff out when not using construction page as root route
        # get there from the construction page
        visit '/'
        click_link "home"
    # end of construction page stuff

    # we should be at the home page now
    # see if we have our headers at the top
    expect(page).to have_selector(".title_main")
    
    # look for our main links along the side    
    expect(page).to have_link(@cat0.name)
    find_link(@cat0.name)[:href].should eq("/display/#{@cat0.name}")
    
    expect(page).to have_link(@cat1.name)
    find_link(@cat1.name)[:href].should eq("/display/#{@cat1.name}")
    
    expect(page).to have_link(@cat2.name)
    find_link(@cat2.name)[:href].should eq("/display/#{@cat2.name}")
    
    expect(page).to have_link(@cat3.name)
    find_link(@cat3.name)[:href].should eq("/display/#{@cat3.name}")
    
    
    
    
    #  look for our about links near the bottom
    expect(page).to have_link('About The Guy')
    find_link('About The Guy')[:href].should eq('/bio_blurb')
    
    expect(page).to have_link('About The Website')
    find_link('About The Website')[:href].should eq('/website_blurb')
    
  end
  

end