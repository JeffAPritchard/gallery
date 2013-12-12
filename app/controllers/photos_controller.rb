class PhotosController < ApplicationController
  layout "photos"
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    # call our factory to sync up with our Amazon S3 photo storage if needed
    Photo::photo_factory
    
    session[:how_many] ||= '100000'
    session[:order_by] ||= 'newest'
    session[:which_photo] ||= 0
    
    limit_value = session[:how_many].to_i
    
    order_string = case session[:order_by]
      when "newest" then 'created_at DESC'
      when "oldest" then 'created_at ASC'
        # eventually add in cases for rating
      else 'created_at DESC'
    end
    
    # pick out some photos to show the user
    @all_selected_photos = Photo.order(order_string).limit(limit_value)
    @photos = @all_selected_photos.paginate(:page => params[:page], :per_page => 12).to_a
    
    # pick out photo for the "single image" tab to show (should be from same set as @photos, but not paginated)
    # it is based on an index stored in a session variable for this user so we keep track of where they are for next and previous
    # defensive programming alert -- need to make sure the current index is valid for the current set of selected photos
    session[:which_photo] = 0 if session[:which_photo] >= @all_selected_photos.count
    @single_photo = @all_selected_photos[session[:which_photo]]
    
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:gui_name, :file_name, :tags)
    end
end
