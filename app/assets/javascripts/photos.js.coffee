# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  # tell rails app we are using javascript
  $.ajax("/photos/using_jscript")
    
  # activate the javascript handling of the tabs
  $("#about-tab").attr href: "#about"
  $("#small-tab").attr href: "#small"
  $("#medium-tab").attr href: "#medium"
  $("#large-tab").attr href: "#large"
  
  # inform the rails app that we are switching to a different tab
  $("#about-tab").click ->
    $.ajax("/photos/remember_tab/about")
  $("#small-tab").click ->
    $.ajax("/photos/remember_tab/small")
  $("#medium-tab").click ->
    $.ajax("/photos/remember_tab/medium")
  $("#large-tab").click ->
    $.ajax("/photos/remember_tab/large")

    