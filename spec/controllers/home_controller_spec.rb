require 'spec_helper'

describe HomeController do
   
   before :each do
      get 'index'
   end

  describe "GET home 'index'" do
     
    it "returns http success" do
      response.should be_success
    end
    
  end

end
