###
PUB/SUB PATTERN
###

# jQuery PubSub
# http://javascriptplayground.com/blog/2012/04/a-jquery-pub-sub-implementation/

pubsub =
  init: ->
    this.bindEvents()

  sendMessage: ->
    message = $('input').val()
    $('body').trigger 'messageReceived',
      message: message
    return false

  displayMessage: (data) ->
    $('body').trigger 'messageDisplayed'
    li = $("<li />")
      .text(data.message)
      .css("display", "none")
    $("ul").append(li)
    $("ul>li").last().fadeIn()

  flashMessage: ->
    $('.flash').text('youve got a new message').fadeIn 500, ->
      self = this
      setTimeout (->
        $(self).fadeOut 500
      ), 2000

  bindEvents: ->
    $('form').on 'submit', ->
      pubsub.sendMessage()
      return false

    $('body').on 'messageReceived', (event, data) ->
      pubsub.displayMessage(data)

    $('body').on 'messageDisplayed', (event, data) ->
      pubsub.flashMessage()


$ ->
  pubsub.init()
