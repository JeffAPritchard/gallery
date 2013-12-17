# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  # tell rails app we are using javascript
  $.ajax("/photos/using_jscript")
  
  # activate the javascript handling of the tabs
  $("#small-tab").attr href: "#small"
  $("#medium-tab").attr href: "#medium"
  $("#large-tab").attr href: "#large"
  
  # inform the rails app that we are switching to a different tab
  $("#small-tab").click ->
    $.ajax("/photos/remember_tab/small-tab")
  $("#medium-tab").click ->
    $.ajax("/photos/remember_tab/medium-tab")
  $("#small-tab").click ->
    $.ajax("/photos/remember_tab/large-tab")

    