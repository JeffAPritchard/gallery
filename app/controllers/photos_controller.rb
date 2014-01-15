require_relative "../../lib/amazon/bucket.rb"
require_relative "../../lib/amazon/imagebucket.rb"



class PhotosController < ApplicationController
  layout "photos"
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    
    # for testing and debugging -- normally commented out
    # session[:using_jscript] = false
    
    session[:page_small] = params[:page_small] if params[:page_small]
    session[:page_medium] = params[:page_medium] if params[:page_medium]
    session[:page_large] = params[:page_large] if params[:page_large]
    session[:active_tab] = params[:active_tab] if params[:active_tab]
    setup_photo_globals()
        
  end
  
  
  def using_jscript 
    session[:using_jscript] = true
    session[:last_width] = params[:width].to_i

    render :nothing => true
  end
  
  
  def remember_tab
    tab = params[:tab]
    session[:active_tab] = tab
    logger.info session[:active_tab]
    
    render :nothing => true
  end
  
  def new_page
    input = params.to_s || ""
    logger.info "params looks like this: #{input}"
    
    # params look like this:
    # Parameters: {"href"=>"tab=small&page=1"}
    
    href = params[:href]
    results = href.match /tab=(\w+)&page=(\d+)/
    tab = results[1]
    page = results[2].to_i
    
    session[:page_small] = page if page && tab == "small"
    session[:page_medium] = page if page && tab == "medium"
    session[:page_large] = page if page && tab == "large"
    session[:active_tab] = tab if tab
    setup_photo_globals()
    
    case tab
    when 'about'
      @id = '#about_pane_div'
      @renderable = 'about_pane.html.haml'
    when 'small'
      @id = '#small_pane_div'
      @renderable = 'small_pane.html.haml'
    when 'medium'
      @id = '#medium_pane_div'
      @renderable = 'medium_pane.html.haml'
    when 'large'
      @id = '#large_pane_div'
      @renderable = 'large_pane.html.haml'
    else
      @id = '#about_pane_div'
      @renderable = 'about_pane.html.haml'
    end
    
    respond_to do |format|
      # render new_page.js.erb
      format.js 
      
      format.html {redirect_to photos_url}
    end
      
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
  
  def setup_photo_globals 
    # logger.info "setting up globals for photo"
    # logger.info "THE params IS #{params.inspect}"

    session[:how_many] ||= '100000'
    session[:order_by] ||= 'newest'
    session[:active_tab] ||= 'about'
    
    limit_value = session[:how_many].to_i
    
    order_string = case session[:order_by]
      when "newest" then 'created_at DESC'
      when "oldest" then 'created_at ASC'
        # eventually add in cases for rating
      else 'created_at DESC'
    end
    
    # pick out some photos to show the user
    @all_selected_photos = Photo.order(order_string).limit(limit_value)
    session[:photo_selection_count] = @all_selected_photos.count
    
    # we vary the number of small icons based on the width -- goal is to get about 4 rows of icons
    # logger.info "the last width is: #{session[:last_width] || "empty"}"
    if session[:last_width] && session[:last_width].to_i > 0
      small_per_page = ((session[:last_width].to_f / 150.0) * 4.0).to_i
      small_per_page = 4 if small_per_page < 4
    else
      small_per_page = 36
    end
    @photos_small = @all_selected_photos.paginate(:page => session[:page_small]).per_page(small_per_page)
    
    #  similarly, we want to limit the number of medium thumbs per page on small screens
    if session[:last_width] && session[:last_width].to_i > 0
      medium_per_page = ((session[:last_width].to_f / 500.0) * 4.0).to_i
      medium_per_page = 4 if medium_per_page < 4
    else
      medium_per_page = 8
    end
    @photos_medium = @all_selected_photos.paginate(:page => session[:page_medium]).per_page(medium_per_page)
    
    # pick out photo for the "single image" tab to show (should be from same set as @photos, but not paginated)
    @photos_large = @all_selected_photos.paginate(:page => session[:page_large]).per_page(1)
    
        
  end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:gui_name, :file_name, :tags)
    end
end
