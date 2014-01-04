require 'spec_helper'
require_relative "../../lib/amazon/bucket.rb"
require_relative "../../lib/amazon/imagebucket.rb"


describe PhotosController do

  # This should return the minimal set of attributes required to create a valid
  # Photo. As you add validations to Photo, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "gui_name" => "MyString" , "file_name" => "MyString.jpg"} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PhotosController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  

  describe "GET index" do

    it "uses our photo factory to sync with the S3 storage" do
      get :index, {}, valid_session
      image_bucket = Amazon::Bucket.new(ImageBucket::IMAGE_BUCKET)
      files = image_bucket.get_files_in_folder("big")
      expect(Photo.all.count).to eq(files.count)
    end

    
    it "assigns all photos as @photos" do
      photo = Photo.create! valid_attributes
      get :index, {}, valid_session
      assigns(:all_selected_photos).should_not be_nil
      assigns(:all_selected_photos).should_not be_empty
    end

    it "uses pagination to limit the small thumbnail per-page photos to 36" do
      get :index, {}, valid_session
      expect(assigns(:photos_small).to_a.count).to eq(36)
    end
    
    it "uses pagination to limit the medium thumbnail per-page photos to 8" do
      get :index, {}, valid_session
      expect(assigns(:photos_medium).to_a.count).to eq(8)
    end
    
    it "uses pagination to limit the large thumbnail per-page photos to 1" do
      get :index, {}, valid_session
      expect(assigns(:photos_large).to_a.count).to eq(1)
    end
    
    it "uses our how-many session vars to limit the total number of pics" do
      get :index, {}, {:how_many => '25'}     
      expect(assigns(:all_selected_photos).count).to eq(25)
    end 
    

  end

  describe "GET show" do
    it "assigns the requested photo as @photo" do
      photo = Photo.create! valid_attributes
      get :show, {:id => photo.to_param}, valid_session
      assigns(:photo).should eq(photo)
    end
  end

  describe "GET new" do
    it "assigns a new photo as @photo" do
      get :new, {}, valid_session
      assigns(:photo).should be_a_new(Photo)
    end
  end

  describe "GET edit" do
    it "assigns the requested photo as @photo" do
      photo = Photo.create! valid_attributes
      get :edit, {:id => photo.to_param}, valid_session
      assigns(:photo).should eq(photo)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Photo" do
        expect {
          post :create, {:photo => valid_attributes}, valid_session
        }.to change(Photo, :count).by(1)
      end

      it "assigns a newly created photo as @photo" do
        post :create, {:photo => valid_attributes}, valid_session
        assigns(:photo).should be_a(Photo)
        assigns(:photo).should be_persisted
      end

      it "redirects to the created photo" do
        post :create, {:photo => valid_attributes}, valid_session
        response.should redirect_to(Photo.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved photo as @photo" do
        # Trigger the behavior that occurs when invalid params are submitted
        Photo.any_instance.stub(:save).and_return(false)
        post :create, {:photo => { "gui_name" => "invalid value" }}, valid_session
        assigns(:photo).should be_a_new(Photo)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Photo.any_instance.stub(:save).and_return(false)
        post :create, {:photo => { "gui_name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested photo" do
        photo = Photo.create! valid_attributes
        # Assuming there are no other photos in the database, this
        # specifies that the Photo created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Photo.any_instance.should_receive(:update).with({ "gui_name" => "MyString" })
        put :update, {:id => photo.to_param, :photo => { "gui_name" => "MyString" }}, valid_session
      end

      it "assigns the requested photo as @photo" do
        photo = Photo.create! valid_attributes
        put :update, {:id => photo.to_param, :photo => valid_attributes}, valid_session
        assigns(:photo).should eq(photo)
      end

      it "redirects to the photo" do
        photo = Photo.create! valid_attributes
        put :update, {:id => photo.to_param, :photo => valid_attributes}, valid_session
        response.should redirect_to(photo)
      end
    end

    describe "with invalid params" do
      it "assigns the photo as @photo" do
        photo = Photo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Photo.any_instance.stub(:save).and_return(false)
        put :update, {:id => photo.to_param, :photo => { "gui_name" => "invalid value" }}, valid_session
        assigns(:photo).should eq(photo)
      end

      it "re-renders the 'edit' template" do
        photo = Photo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Photo.any_instance.stub(:save).and_return(false)
        put :update, {:id => photo.to_param, :photo => { "gui_name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested photo" do
      photo = Photo.create! valid_attributes
      expect {
        delete :destroy, {:id => photo.to_param}, valid_session
      }.to change(Photo, :count).by(-1)
    end

    it "redirects to the photos list" do
      photo = Photo.create! valid_attributes
      delete :destroy, {:id => photo.to_param}, valid_session
      response.should redirect_to(photos_url)
    end
  end

end
