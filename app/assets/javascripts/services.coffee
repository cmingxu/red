# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load turbolinks:load', ->
  $('.app_state').map ()->
    $(this).load $(this).data 'app-state-path'

  $('.service_refresh_app_state_icon').click ()->
    service_id = $(this).data('service_id')
    $("." + service_id).find('.app_state').map (appStateDom)->
      appStateDom.load appStateDom.data 'app-state-path'


