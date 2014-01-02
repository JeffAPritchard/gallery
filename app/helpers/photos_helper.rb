module PhotosHelper
  
  # figure out the path to the index with the tab and large_page values filled in to get us to 
  # the large version of this image
  # it should look something like this:  "/photos?active_tab=large&page_large=2"
  def get_large_page_uri(photo, all_photos)
    # first we need to figure out where this image lives in the list of pictures selected by the filters
    index_in_all_array = all_photos.to_a.index(photo)
    
    # array index is zero based but our pages are one based
    index_in_all_array += 1
    
    # build the uri string
    uri = "/photos?active_tab=large&page_large=#{index_in_all_array.to_s}"
  end
  
  def get_x_of_y(photo, all_photos)
    # first we need to figure out where this image lives in the list of pictures selected by the filters
    index_in_all_array = all_photos.to_a.index(photo)
        
    # array index is zero based but our pages are one based
    index_in_all_array += 1
  
    # build the x of y string
    output = "<b>&nbsp;&nbsp;&nbsp;#{index_in_all_array.to_s} of #{all_photos.count.to_s} &nbsp;&nbsp;&nbsp;</b>"
  end
  
  def get_displayable_file_name(photo)
    file_name = photo.get_display_name
    truncate(file_name, :length => 20)
  end
  
  def get_full_separator_string(photo, all_photos)
    file_name = get_displayable_file_name(photo)
    separator_str = " #{get_x_of_y( photo, all_photos)}(&nbsp;#{file_name}&nbsp;)&nbsp;&nbsp;"
  end
  
  
end
