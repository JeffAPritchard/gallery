require 'spec_helper'

describe HomeController do
   

   describe "it brings up the main home page" do
     
     it "returns http success" do
       cat1 = FactoryGirl.create(:category, {name: "Writing", blurb: "About my writing"})
       cat2 = FactoryGirl.create(:category, {name: "Software", blurb: "stuff I wrote"})
       cat3 = FactoryGirl.create(:category, {name: "Projects", blurb: "Mad Scientist at work"})
       
       get :index
       response.should be_success
       
       assigns(:categories).size.should eq(3)
     end
    
   end


   describe "GET bio blurb screen" do
     
     it "returns http success" do
       get 'bio_blurb'
       response.should be_success
     end
    
   end

   describe "GET website blurb screen" do
     
     it "returns http success" do
       get 'website_blurb'
       response.should be_success
     end
    
   end



end
