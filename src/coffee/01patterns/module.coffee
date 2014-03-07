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