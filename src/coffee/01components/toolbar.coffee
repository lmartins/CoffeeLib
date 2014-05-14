'use strict'

# TOOLBAR UTILITY -------------------------------------------------------------

class Toolbar
  constructor: (elem) ->
    @elem = document.querySelector elem

    # Creates the HTML element if the passed selector doesnt return any results
    if not @elem
      @elem = document.createElement 'UL'
      elementClasses = elem.split '.'
      for cssClass in elementClasses
        unless cssClass is ""
          @elem.classList.add cssClass

    @_createToolbarItems( @elem.querySelectorAll '.Toolbar-item' )

  _createToolbarItem: (el) ->
    item =
      toggleActiveState: ->
        @activated = not @activated

    Object.defineProperties item,
      el:
        value: el

      enabled:
        get: ->
          not @el.classList.contains 'disabled'
        set: (value) ->
          if value
            @el.classList.remove 'disabled'
          else
            @el.classList.add 'disabled'

      activated:
        get: ->
          @el.classList.contains 'active'
        set: (value) ->
          if value
            @el.classList.add 'active'
          else
            @el.classList.remove 'active'

    return item

  _createToolbarItems: (itemElements) ->
    @items = []
    for item in itemElements
      newItem = @_createToolbarItem item
      @items.push newItem

    return @items


  # Add a new menu option
  add: (options) ->
    li = document.createElement 'LI'
    li.classList.add 'Toolbar-item'
    @elem.appendChild li
    item = @_createToolbarItem li
    @items.push item
    return this

  # Remove an option from the menu
  remove: (index) ->
    len = @items.length

    if index > len or index < 0
      throw new Error 'Index is out of range'

    item = @items[index]
    @items.splice index, 1
    @elem.removeChild(item.el)

    item = null

  appendTo: (parentElement) ->
    parentElement.appendChild @elem


# SAMPLE USAGE
mainMenu = new Toolbar '.Toolbar.mainMenu'
console.log mainMenu
secMenu = new Toolbar '.Toolbar.secMenu'

thirdMenu = new Toolbar '.Toolbar.thirdMenu'
page = document.querySelector '.Page'
thirdMenu.appendTo page
thirdMenu.add().add().add().add()
