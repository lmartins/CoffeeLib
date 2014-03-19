mdf = {}
mdf.Tabs = (el, options) ->
  if el
    this.init el, options

Tabs:: = ->
  name: "mdf_tabs"
  init: (el, options) ->
    # save the element for faster queries
    this.element = $(el)

    # save options if there are any
    this.options = options

    # bind if the element is destroyed
    this.element.bind 'destroyed', $.proxy this.teardown, this

    # save this instance in jQuery data
    $.data el, this.name, this

    # add the name and tabs to this class
    this.element.addClass this.name + 'tabs'

    # activate the first tabe
    this.activate this.element.children 'li:first'

    # hide other tabs
    tab = this.tab
    this.element.children('li:gt(0)').each ->
      tab($(this)).hide()


mdf.HistoryTabs = (el, options) ->
  if el
    this.init el, options

mdf.HistoryTabs:: = new mdf.Tabs()
$.extend mdf.HistoryTabs::,
  name: 'mdf_history_tabs'
