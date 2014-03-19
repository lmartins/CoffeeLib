###
PUB/SUB PATTERN
###

# jQuery PubSub
# http://javascriptplayground.com/blog/2012/04/a-jquery-pub-sub-implementation/

pubsub = {}

$('form').on 'submit', ->
  return false


sendMessage = ->
  message = $('input').val()
  $('body').trigger 'messageReceived',
    message: message
  return false
