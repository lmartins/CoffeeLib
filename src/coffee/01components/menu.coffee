getSiblings = require "./utilities/siblings"

class Menu

  constructor: (@elem) ->
    @menu = @elem
    @menuItems = @menu.children
    @menuInit()

  menuInit: ->
    for item, index in @menuItems
      item.classList.add "item"
      item.classList.add "item#{index+1}"
      item.addEventListener 'click', @toggleActiveItem

      # adiciona elemento para receber metadados
      metaEl = document.createElement 'span'
      metaEl.classList.add 'meta'
      item.appendChild metaEl

    @menuUpdate()
    return

  # fat arrow puts the function's this value in the context of the class
  toggleActiveItem: (e) =>
    elem = e.currentTarget
    others = getSiblings elem
    elem.classList.add 'is-active'
    for item in others
      item.classList.remove 'is-active'

    @menuUpdate()
    return

  menuUpdate: ->
    for item, index in @menuItems
      metaEl = item.querySelector '.meta'
      if item.classList.contains 'is-active'
        metaEl.innerHTML = " - #{index+1} - Active"
      else
        metaEl.innerHTML = " - #{index+1}"



# USAGE:
# menu1 = document.querySelector '.menu1'
# menu2 = document.querySelector '.menu2'
#
# mainNav = new Menu menu1
# secNav = new Menu menu2
