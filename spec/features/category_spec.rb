require 'spec_helper'

# googled my fingers off to find this stuff -- lots of misinformation out there on how to test devise with capybara/feature spec
# https://github.com/plataformatec/devise/wiki/How-To%3a-Test-with-Capybara
include Warden::Test::Helpers
Warden.test_mode!

feature "category display" do


  let(:admin_user) {FactoryGirl.create(:user)}
  let(:admin_role) {FactoryGirl.create(:role, {:name => "admin"})}

  before do
    admin_user.roles << admin_role
  end
  
  after do
    Warden.test_reset!
  end
  
  scenario "only allow entry of admin screens for admins" do
    # don't log in as an admin
    # login_as(admin_user, :scope => :user, :run_callbacks => false)
    
    visit categories_path()
    expect(current_path).to_not eq(categories_path)


    # do log in as an admin
    login_as(admin_user, :scope => :user, :run_callbacks => false)
    
    visit categories_path()
    expect(current_path).to eq(categories_path)
  end
  
  
  scenario "does not show new category link to plebians" do
    visit index_path
    expect(page).to_not have_link("Add New Category")
  end
  

  scenario "shows add cat link for admins" do
       
    # go to "root"
    login_as(admin_user, :scope => :user, :run_callbacks => false)
    visit index_path

    # only show our add category links for administrators
    expect(page).to have_link("Add New Category")
    
  end
  
  
  
  
  
end