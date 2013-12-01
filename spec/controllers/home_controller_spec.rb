require 'spec_helper'

describe HomeController do
   
   before :each do
      get 'index'
   end

  describe "GET construction 'index'" do
    it "returns http success" do
      response.should be_success
    end
  end

end
