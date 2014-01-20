# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  if limitToThisView('photo')    
    setUpPhotoUnobtrusiveJavascriptUXOptimizations()

    


#  set up all of our javascript modifications to the photo gallery after initial load
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
  handleBrowserBackButtonAfterPrevNext()


# when we use ajax to change which photo we're showing, we also update the url to reflect the new page
# if user subsequently uses the back button (instead of our previous), they would see the url change but not the image
# instead of redrawing the page, the browser just sends us a popstate message -- we need to handle that appropriately
# note: this will only happen for the large tab, since we only mess with the url via ajax for large tab link clicks
handleBrowserBackButtonAfterPrevNext = () ->
  window.onpopstate = (event) ->
    if event.state != null
      $.ajax("/photos/remember_tab/large")
      set_active_tab('#my-tab-content', 'large')
      # eeeek! javascript documentation claims string.replace does not effect input string -- but I was getting redirects!
      # thepage = document.location.replace(/.*?\/large\//,"")
      # after making a copy of document.location and calling replace on that, the problem went away!
      href = new String(document.location)
      thepage = href.replace(/.*?\/large\//,"")
      $.ajax("/photos/new_page/tab=large&page=#{thepage }", success: -> updateImageAttributes())
  

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
  

# apply the fade-in jQuery plugin smoothness (and callback to do it again after each click)
updateImageAttributes = () ->     
  # improve the UX of images by having them fade in once all are loaded  
  $("#thumbnails_div").krioImageLoader()
  $("#medium_images_div").krioImageLoader()
  $("#large_image_div").krioImageLoader()
  
  # replace the previous and next links with precisely placed buttons
  # make sure this happens before we mess with the click handlers and before we move the buttons around!
  setupFancyPrevNextButtons()
  
  # do some fancy footwork to take the links churned out by "will_paginate" and organize them better
  reorganizePaginationLinks()
  
  # set up the javascript links to do ajaxy updating when next/previous or specific page links are clicked
  # this is a little funky due to changing meaning of "this" in event callback - mildly hacky workaround
  # ToDo - come back and look at this again and find a cleaner approach
  $('div.pagination a').addClass("page_link")
  $('.page_link').each (index) ->
    link = ($('.page_link'))[index]    
    href = link.href
    # maddeningly '$(this)' has a different meaning when we are called in the success callback!
    # href = $(this).attr('href')
    # we have two kinds of URL's
    #   1) .../photos/large/page#
    #   2) .../photos/slug-with-active_tab-and-page
    if href.search(/\/large\//) >= 0
      console.log("WE ARE MESSING WITH A LARGE LINK")
      tab = "large"
      # unfortunately, with this slug we have a photo object id rather than a page number in our href
      # have to get the page number in a different way
      page = getPageFromXofYslug($(link).closest('.pagination').find('#center').text(), $(link).closest('a').hasClass('.next_page'))
    else
      tab = (href.match(/active_tab=\w+/g)[0]).replace("active_tab=", "")
      page = href.replace(/.*?\?/,"").match(/\d+/g)[0]
    $(link).click (event) ->
      event.preventDefault()
      $.ajax("/photos/new_page/tab=#{tab}&page=#{page}", success: -> updateImageAttributes())
      

# figure out which large image page we're showing
# ToDo - this is kind of brittle -- would be cleaner to put data element in link to get page number from
getPageFromXofYslug = (text, next) ->
  # first snaggle the current page number from our XofY text
  page = text.match(/\d+/)[0]
  # note: don't need to bounds check what's next because the next/prev buttons are disabled when not appropriate
  page = if next then page + 1 else page - 1


# since we need to ajax our tab change over to the rails app, we choose to do the actual pane-hiding/showing
# ourselves rather than using jquery tab widget -- it is very simple to do it "manually"
set_active_tab = (tab_container, tab) ->
  # remove the active class from all of the panes
  $('div' + tab_container + ' .tab-pane').removeClass('active')  
  # add it back in for the proper pane (which is the div that is the parent of our div with this name)
  $('div#' + tab).parent().addClass('active')


setupFancyPrevNextButtons = () ->
  parent = $('div.pagination')
  prev_link = parent.find('a.previous_page')
  prev_image_url = "http://jeffp-images.s3.amazonaws.com/previous.gif"
  img_link_text = "<img src='#{prev_image_url }' class='previous_button' />"
  prev_link.html(img_link_text)
  
  next_link = parent.find('a.next_page')
  next_image_url = "http://jeffp-images.s3.amazonaws.com/next.gif"
  img_link_text = "<img src='#{next_image_url }' class='next_button' />"
  next_link.html(img_link_text)

  # also have to supply grayed out images for the disabled prev and next text when at beginning or end
  prev_txt = parent.find('span.previous_page')
  prev_image_url = "http://jeffp-images.s3.amazonaws.com/previous-gray.gif"
  img_link_text = "<img src='#{prev_image_url }' class='previous_button' />"
  prev_txt.html(img_link_text)
  
  next_txt = parent.find('span.next_page')
  next_image_url = "http://jeffp-images.s3.amazonaws.com/next-gray.gif"
  img_link_text = "<img src='#{next_image_url }' class='next_button' />"
  next_txt.html(img_link_text)



# we want to set this row of links up as three columns so we can control location of prev/next links despite 
# different page sizes and responsive grid layout -- it starts out all in one centered column
# turn it into something more like this -> 1cols:previous  10cols:links   1cols: next
# then we use different column widths for the middle section for different size devices to keep it organized
# nicely on smaller devices
reorganizePaginationLinks = () ->
  # note: we have three panes on our page, and each one has its own pagination section -- we need to handle each one separately!
  parents = $('div.pagination')

  for parent in parents
    # in some ajax calls we replace only one pane of html -- avoid re-doing the following for other panes!
    if not($(parent).hasClass('row'))
      # we need for our pagination div to have row class in order to set up a new set of columns within it
      $(parent).addClass('row')

      # create a "middle" div and put all of the anchors in there except prev and next
      middle_stuff = $(parent).contents()
      middle = $("<div></div>").addClass('col-md-10').addClass('col-sm-8').addClass('col-xs-5').attr('id','middle').addClass('center-block')
      middle.appendTo($(parent))
      center = $("<div></div>").attr('id','center').addClass('center-text')
      center.appendTo(middle)
      # move the stuff between prev and next into the middle div
      middle_stuff.appendTo(center)
  
      # make a left-hand div, put it at beginning of parent and put the prev element in there
      left = $("<div></div>").addClass('col-md-1')
      left.prependTo($(parent))
      prev_link = $(parent).find('.previous_page')
      prev_link.appendTo($(left))
  
      # same idea for the other end
      right = $("<div></div>").addClass('col-md-1')
      right.appendTo($(parent))
      next_link = $(parent).find('.next_page')
      next_link.appendTo($(right))

  
  
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
        $.ajax("/photos/using_jscript/#{width}X#{height}", success: -> location.reload())
        
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


  