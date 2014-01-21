class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  # call our factory to sync up with our Amazon S3 photo storage if needed
  # we do this here as it only needs to happen once when we open up the app to deal with any new images added to S3 storage
  Photo::photo_factory
  
  def check_admin_role
    unless user_signed_in? && current_user.has_role?(:admin)
      flash[:error] = "You must be logged in as an admin to access this area"
      redirect_to :root
    end
  end
  
  

end
