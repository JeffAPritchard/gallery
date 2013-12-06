require 'spec_helper'

describe HomeController do
   

   describe "it brings up the main home page" do
     
     it "returns http success" do
       get :index
       response.should be_success
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
