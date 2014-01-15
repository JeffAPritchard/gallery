# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->

  if limitToThisView('photo')
    # for debug purposes only -- normally commented out
    console.log("DOCUMENT READY PROCESSING for photo UNDERWAY")
    
    setUpPhotoUnobtrusiveJavascriptUXOptimizations()

    # for debug purposes only -- normally commented out
    console.log("DOCUMENT READY PROCESSING for photo COMPLETE")
    
    
    
    
    
setUpPhotoUnobtrusiveJavascriptUXOptimizations = () ->

  console.log("beginning setUpPhotoUnobtrusiveJavascriptUXOptimizations ")
  
  # tell rails app we are using javascript
  width = $(window).width()
  $.ajax("/photos/using_jscript/#{width}")
  $(window).data( {"mywidth":width} )

  $(window).resize ->
    new_width = $(window).width()
    old_width = $(window).data( "mywidth" )
    difference = Math.abs(old_width - new_width) 
    if(difference > 150)
      $(window).data( {"mywidth":new_width} )
      $.ajax("/photos/using_jscript/#{new_width }")
      location.reload()
  
  updateTabs()
  updateThumbnails()
  
  console.log("completing setUpPhotoUnobtrusiveJavascriptUXOptimizations ")





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


updateTabs = () ->
  # activate the javascript handling of the tabs
  $("#about-tab").attr href: "#about"
  $("#small-tab").attr href: "#small"
  $("#medium-tab").attr href: "#medium"
  $("#large-tab").attr href: "#large"
  
  # inform the rails app that we are switching to a different tab and then activate it
  $("#about-tab").click ->
    $.ajax("/photos/remember_tab/about")
    set_active_tab('#my-tab-content', 'about')
  $("#small-tab").click ->
    $.ajax("/photos/remember_tab/small")
    set_active_tab('#my-tab-content', 'small')
  $("#medium-tab").click ->
    $.ajax("/photos/remember_tab/medium")
    set_active_tab('#my-tab-content', 'medium')
  $("#large-tab").click ->
    $.ajax("/photos/remember_tab/large")
    set_active_tab('#my-tab-content', 'large')
  

updateThumbnails = () ->     
  console.log("beginning updateThumbnails ")

  # improve the UX of thumbnails by having them fade in once all are loaded
  $("#thumbnails_div").krioImageLoader()
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
      $.ajax("/photos/new_page/tab=#{tab}&page=#{page}", success: -> updateThumbnails())
      
  console.log("completing updateThumbnails ")
  

# since we need to ajax our tab change over to the rails app, we choose to do this ourselves rather than using jquery tab widget
set_active_tab = (tab_container, tab) ->
  # remove the active class from all of the panes
  $('div' + tab_container + ' .tab-pane').removeClass('active')  
  # add it back in for the proper pane (which is the div that is the parent of our div with this name)
  $('div#' + tab).parent().addClass('active')