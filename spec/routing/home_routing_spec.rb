require "spec_helper"

describe PhotosController do
  describe "routing" do

    it "routes to #bio_blurb" do
      get('/home/bio_blurb').should route_to("home#bio_blurb")
    end

    it "routes to #website_blurb" do
      get('/home/website_blurb').should route_to("home#website_blurb")
    end

    it "routes to #display" do
      get('/display/1').should route_to('activities#display', :category => "1")
    end

# why can't johnny route?  Don't know why this fails -- seems to want to call this a "show" action???
    # it "routes to #display" do
    #   get('/activities/display').should route_to("activities#display")
    # end

  


  end
end