require 'spec_helper'

describe ConstructionController do
   before :each do
      get 'index'
   end

  describe "GET construction 'index'" do
     save_and_open_page
    it "returns http success" do
      response.should be_success
    end
  end

end
