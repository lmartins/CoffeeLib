###
THE PATTERN MODULE
###
'use strict'

NewsWidget =

  settings:
    numArticles: 5
    articlesList: $('#articlesList')
    moreButton: $('#moreBtn')

  init: ->
    console.log "News Widget initiated"
    @.bindUIActions()

  bindUIActions: ->
    self = this
    @settings.moreButton.on 'click', ->
      self.getMoreArtiles(self.settings.numArticles)

  getMoreArtiles: (numToGet) ->
    self = this
    console.log numToGet

NewsWidget.init()


# Another take on the Module Pattern
# http://rmurphey.com/blog/2009/10/15/using-objects-to-organize-your-code/
Module = (->

  _privateMethod = ->
    console.log "Some text from the private method, called from the public method"

  publicMethod = ->
    console.log "something from the public method"
    _privateMethod()

  # métodos públicos que são expostos através do módulo
  return publicAPI =
    publicMethod: publicMethod

)()

# ModuleTwo extends the functionality of Module
ModuleTwo = ( (Module) ->

  Module.extension = ->
    console.log "Text from the extension Module"

  return Module

)( Module or {} )
