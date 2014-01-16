require_relative "../../lib/amazon/bucket.rb"
require_relative "../../lib/amazon/imagebucket.rb"

include PhotosHelper

class PhotosController < ApplicationController
  layout "photos"
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index

    # default to first page if no info
    session[:page_small] ||= 1
    session[:page_medium] ||= 1
    session[:page_large] ||= 1
    
    determine_filtered_photos_selection()
    
    # !!! dependent on selected photos determined above
    session[:page_small] = params[:page_small].to_i if params[:page_small]
    session[:page_medium] = params[:page_medium].to_i if params[:page_medium]
    session[:page_large] = params[:page_large].to_i if params[:page_large]
    session[:active_tab] = params[:active_tab] if params[:active_tab]
    
    determine_pagination()
        
  end
  
  def large
    # This is an alternative landing page for "photos/index" -- go directly to a particular large image view from pasted URL

    # default to first page if no info
    session[:page_small] ||= 1
    session[:page_medium] ||= 1
    session[:page_large] ||= 1

    determine_filtered_photos_selection()

    id = params[:id].to_i
    # user has come here from outside to view a very specific image via "photos/large/:id" url
    # either pick it out of the selected images, or add it to the selected image collection
    if index = @all_selected_photos.index{|item| item.id == id}
      # the array of selections is zero based, but the pages for them start at 1 -- off by one error
      session[:page_large] = index + 1
    else
      photo = Photo.find(session[:large_and_in_charge])
      @all_selected_photos.append(photo)
      session[:photo_selection_count] += 1
      session[:page_large] = @all_selected_photos.count
    end
    session[:active_tab] = 'large'
    session[:large_and_in_charge] = nil

    determine_pagination()
    
    render '/photos/index'
  end
  
  
  def using_jscript 
    session[:using_jscript] = true
    session[:last_width] = params[:width].to_i

    render :nothing => true
  end
  
  
  def remember_tab
    # default to first page if no or bad info
    session[:page_small] = 1 unless session[:page_small] && session[:page_small] <= session[:max_small_page]
    session[:page_medium] = 1 unless session[:page_medium] && session[:page_medium] <= session[:max_medium_page]
    session[:page_large] = 1  unless session[:page_large] && session[:page_large] <= session[:max_large_page]

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
    
    session[:page_small] = page if page && tab == "small" && page <= session[:max_small_page]
    session[:page_medium] = page if page && tab == "medium" && page <= session[:max_medium_page]
    session[:page_large] = page if page && tab == "large" && page <= session[:max_large_page]


    session[:active_tab] = tab if tab
    determine_filtered_photos_selection()
    determine_pagination()
    
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
  
  def determine_filtered_photos_selection 
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
  end
  
  def determine_pagination  
    # we vary the number of small icons based on the width -- goal is to get about 4 rows of icons
    # logger.info "the last width is: #{session[:last_width] || "empty"}"
    if session[:last_width] && session[:last_width].to_i > 0
      small_per_page = ((session[:last_width].to_f / 150.0) * 4.0).to_i
      small_per_page = 4 if small_per_page < 4
    else
      small_per_page = 36
    end
    
    session[:max_small_page] = (@all_selected_photos.count / small_per_page) + 1
    
    #  similarly, we want to limit the number of medium thumbs per page on small screens
    if session[:last_width] && session[:last_width].to_i > 0
      medium_per_page = ((session[:last_width].to_f / 500.0) * 4.0).to_i
      medium_per_page = 4 if medium_per_page < 4
    else
      medium_per_page = 8
    end

    session[:max_medium_page] = (@all_selected_photos.count / medium_per_page) + 1
    
    # pick out photo for the "single image" tab to show (should be from same set as @photos, but not paginated)
    session[:max_large_page] = @all_selected_photos.count

    
    # defensive programming to avoid imaginary pages
    double_check_valid_page_numbers


    @photos_small = @all_selected_photos.paginate(:page => session[:page_small]).per_page(small_per_page)
    @photos_medium = @all_selected_photos.paginate(:page => session[:page_medium]).per_page(medium_per_page)
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
