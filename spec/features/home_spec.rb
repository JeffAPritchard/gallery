require 'spec_helper'

feature "home page" do

  scenario "displays our simple home page" do

    # comment this stuff out when not using construction page as root route
        # get there from the construction page
        visit '/'
        click_link "home"
    # end of construction page stuff

    # we should be at the home page now
    # see if we have our headers at the top
    expect(page).to have_selector("#main_header")
    expect(page).to have_selector("#sub_header")
    
    # look for our main links along the side
    expect(page).to have_link('Photography')
    find_link('Photography')[:href].should eq('https://picasaweb.google.com/CanonNaturePhotoGuy')
    
    expect(page).to have_link('Writing')
    find_link('Writing')[:href].should eq('/Writing')
    
    expect(page).to have_link('Software')
    find_link('Software')[:href].should eq('/Software')
    
    expect(page).to have_link('Projects')
    find_link('Projects')[:href].should eq('/Projects')
    
    
    
    #  look for our about links near the bottom
    expect(page).to have_link('About The Guy')
    find_link('About The Guy')[:href].should eq('/bio_blurb')
    
    expect(page).to have_link('About The Website')
    find_link('About The Website')[:href].should eq('/website_blurb')
    
  end
  

end