# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  if limitToThisView('photo')    
    setUpPhotoUnobtrusiveJavascriptUXOptimizations()

    
    
setUpPhotoUnobtrusiveJavascriptUXOptimizations = () ->  
  # tell rails app we are using javascript and give it height and width
  width = $(window).width()
  height= $(window).height()
  $.ajax("/photos/using_jscript/#{width}X#{height}")
  $(window).data( {"mywidth":width} )
  $(window).data( {"myheight":height} )

  setupWindowResizeHandler()
  updateTabs()
  updateImageAttributes()
  




# Tab-related (about/small/medium/large) javascript setup
updateTabs = () ->
  # activate the javascript handling of the tabs
  $("#about-tab").attr href: "#about"
  $("#small-tab").attr href: "#small"
  $("#medium-tab").attr href: "#medium"
  $("#large-tab").attr href: "#large"
  
  # inform the rails app that we are switching to a different tab and then activate it
  $("#about-tab").click ->
    $.ajax("/photos/remember_tab/about", success: -> updateLocationAfterTab('about'))
  $("#small-tab").click ->
    $.ajax("/photos/remember_tab/small", success: -> updateLocationAfterTab('small'))
  $("#medium-tab").click ->
    $.ajax("/photos/remember_tab/medium", success: -> updateLocationAfterTab('medium'))
  $("#large-tab").click ->
    $.ajax("/photos/remember_tab/large")
    set_active_tab('#my-tab-content', 'large')
  
  
# clean up the URL to something simple for most of the photo gallery pages
# (for large images, we leave the long-form URL so it can be copy/pasted from URL box )
updateLocationAfterTab = (tab) ->
  set_active_tab('#my-tab-content', tab)
  window.location = "/photos" if window.location.pathname != "/photos"
  

# apply the fade-in jQuery plugin smoothness
updateImageAttributes = () ->     
  # improve the UX of images by having them fade in once all are loaded  
  $("#thumbnails_div").krioImageLoader()
  $("#medium_images_div").krioImageLoader()
  $("#large_image_div").krioImageLoader()
  
  # set up the javascript links to do ajaxy updating when next/previous or specific page links are clicked
  # this is a little funky due to changing meaning of "this" in event callback - mildly hacky workaround
  # ToDo - come back and look at this again and find a cleaner approach
  $('div.pagination a').addClass("page_link")
  $('.page_link').each (index) ->
    link = ($('.page_link'))[index]    
    href = link.href
    # maddeningly '$(this)' has a different meaning when we are called in the success callback!
    # href = $(this).attr('href')
    tab = (href.match(/active_tab=\w+/g)[0]).replace("active_tab=", "")
    page = href.replace(/.*?\?/,"").match(/\d+/g)[0]
    $(link).click (event) ->
      event.preventDefault()
      $.ajax("/photos/new_page/tab=#{tab}&page=#{page}", success: -> updateImageAttributes())
      

# since we need to ajax our tab change over to the rails app, we choose to do the actual pane-hiding/showing
# ourselves rather than using jquery tab widget -- it is very simple to do it "manually"
set_active_tab = (tab_container, tab) ->
  # remove the active class from all of the panes
  $('div' + tab_container + ' .tab-pane').removeClass('active')  
  # add it back in for the proper pane (which is the div that is the parent of our div with this name)
  $('div#' + tab).parent().addClass('active')
  
setupWindowResizeHandler = () ->
  window.resizeEvt;
  $(window).resize ->
    clearTimeout(window.resizeEvt)
    window.resizeEvt = setTimeout ->
      # code to do after window is resized
      width = $(window).width()
      height= $(window).height()
      
      # figure out how much the user changed the size
      old_width = $(window).data( "mywidth" )
      difference_w = Math.abs(old_width - width) 
    
      old_height = $(window).data( "myheight" )
      difference_h = Math.abs(old_height - height) 
    
      # now that we're using setTimeout, requiring a large move is no longer
      # really necessary to throttle recalculation of thumbs...but still
      # skip it if the change was negligible
      if(difference_w > 10 || difference_h > 10)
        $(window).data( {"mywidth":width} )
        $(window).data( {"myheight":height} )
        $.ajax("/photos/using_jscript/#{width}X#{height}")
        location.reload()
    , 250
   
  

# use this (together with a proper id tag on each screen's container div) to limit the action of javascript code to a particular controller/view
# need to dry this up and put it somewhere global
limitToThisView = (view_name) ->
  result = false
  container_found = $('div.container')
  if container_found != null 
    if container_found.length > 1
      container_found = container_found[0]
    result = container_found.hasClass(view_name)

  return result


  