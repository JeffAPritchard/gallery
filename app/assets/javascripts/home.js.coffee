# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  if limitToThisView('home')    
    setupHomeScreenModifications()



setupHomeScreenModifications = () ->
  test = $("<div></div>").attr(id: 'test-capybara')
  test.prependTo($('#content'))
  replaceAboutLinksWithTabs()
  
  
  
  



replaceAboutLinksWithTabs = () ->
  # we only want to show all this stuff if there is lots of room (tall window)
  height= $(window).height()
  return if height < 1000
  # call client to have it send the replacement html
  $.ajax("/home/replace_about_section/1", success: -> setupTabClickHandlers())
  


setupTabClickHandlers = () ->
  $("#about-guy-tab").click ->
    set_active_tab('#tabs', 'about-guy-tab')
    set_active_tab_pane('#the-tabs', 'about_guy_pane_div')
  $("#about-skillz-tab").click ->
    set_active_tab('#tabs', 'about-skillz-tab')
    set_active_tab_pane('#the-tabs', 'about_skillz_pane_div')
  $("#about-website-tab").click ->
    set_active_tab('#tabs', 'about-website-tab')
    set_active_tab_pane('#the-tabs', 'about_website_pane_div')
  
  
  
set_active_tab = (tab_container, tab) ->
  # remove the active class from all of the tabs
  $('ul' + tab_container + ' li').removeClass('active')  
  # add it back in for the proper pane (which is the div that is the parent of our div with this name)
  $('a#' + tab).parent().addClass('active')
  
  
set_active_tab_pane = (pane_container, tab) ->
  # remove the active class from all of the panes
  $('div' + pane_container + ' .tab-pane').removeClass('active')  
  # add it back in for the proper pane (which is the div that is the parent of our div with this name)
  $('div#' + tab).addClass('active')
  



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
