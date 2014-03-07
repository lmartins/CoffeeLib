# Based on
# http://rmurphey.com/blog/2009/10/15/using-objects-to-organize-your-code/

mw = ((mw) ->
  myFeature =
    config:
      container: $('#myFeature')
      # definir o selector que contém o texto para cada elemento na navegação
      itemNavSelector: 'h3'
      itemNavProcessor: ($selection) ->
        return 'Preview of ' + $selection.eq(0).text()

    init: (config) ->

      # provide custom configuration via init
      if config and typeof config is 'object'
        $.extend myFeature.config, config

      # create and/or cache some DOM elements
      # we'll want to use throughout the code
      myFeature.$container = myFeature.config.container
      myFeature.$sections = myFeature.$container
        # selecciona apenas as li imediatamente abaixo da ul.sections
        .find 'ul.sections > li'

      myFeature.$container.addClass 'MultiIndex'

      # elemento que recebe a navegação
      myFeature.$section_nav = $('<ul/>')
        .attr 'id', 'section_nav'
        .prependTo myFeature.$container

      # elemento que recebe as subseccoes
      myFeature.$item_nav = $('<ul/>')
        .attr 'id', 'item_nav'
        .insertAfter myFeature.$section_nav

      # elemento que vai receber o conteúdo
      myFeature.$content = $('<p/>')
        .attr 'id', 'content'
        .insertAfter myFeature.$item_nav

      # build the section-level nav and
      # click the first item
      myFeature.buildSectionNav( myFeature.$sections )
      myFeature.$section_nav.find('li:first').click()

      # hide the plain html from sight
      myFeature.$container.find('ul.sections').hide()

      # make a note that the initialization is complete
      # we dont striclty need this for this iteration, but
      # it can come in handy
      myFeature.initialized = true


    buildSectionNav: ( $sections ) ->

      $sections.each ->
        # get the current section
        $section = $(this)

        # create a list item for the section navigation
        $('<li/>')
          # use the text of the first h2
          # in the section as text for
          # the section navigation
          .text $section.find('h2:first').text()

          # add the list item to the setion navigation
          .appendTo myFeature.$section_nav

          # use data() to store a reference to the original section
          # on the newly create list item
          .data 'section', $section

          # bind the click behaviour to the newly created list item
          # so that it will show the section
          .click myFeature.showSection


    buildItemNav: ($items) ->
      $items.each ->

        # get the item
        $item = $(this)

        # usa o selector e o processor da config
        # para obter o texto de cada item nav
        myText = myFeature.config.itemNavProcessor(
          $item.find myFeature.config.itemNavSelector
        )

        # create a list item element for the item navigation
        $('<li>')
          # use the text of the first h3 in the item as the text for the item navigation
          .text myText

          # add the list item to the item navigation
          .appendTo myFeature.$item_nav

          # use data to store a reference to the original item on the newly created list item
          .data 'item', $item

          # bind the click behaviour
          .click myFeature.showContentItem


    showSection: ->
      $li = $(this)

      # clear out the left nav and content area
      myFeature.$item_nav.empty()
      myFeature.$content.empty()

      # get the jQuery section object from the original html
      # which we stored using data() during the buildSectionNav
      $section = $li.data 'section'

      # mark the clicked list item as current
      # and remove the current marker from its siblings
      $li.addClass 'current'
        .siblings()
        .removeClass 'current'

      # find all the items related to the section
      $items = $section.find 'ul li'

      # build the item nav for the section
      myFeature.buildItemNav $items

      # click on the first list item in the section's item nav
      myFeature.$item_nav.find 'li:first'
        .click()

    showContentItem: ->
      $li = $(this)

      # mark the clicked list item as current
      # and remove the current marker from its siblings
      $li.addClass 'current'
        .siblings()
        .removeClass 'current'

      # get the jQuery item object from the original HTML
      # which we stored using data during buildContentNav
      $item = $li.data 'item'

      # use the item's html to populate the content area
      myFeature.$content.html $item.html()

  return myFeature

)(mw or {})

$(document).ready mw.init
