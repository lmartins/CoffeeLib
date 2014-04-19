
class TableSlider

  constructor: (@elem) ->
    @init()
    # @updateContents()

  init: ->
    @elContent = @elem
    @elContainer = @elContent.parentNode

    origHTML = @elContainer.innerHTML
    newHTML = "<div class='TableSlider-wrapSlider'>#{origHTML}</div>"
    @elContainer.innerHTML = newHTML
    @elScroller = @elContainer.querySelector '.TableSlider-wrapSlider'

    # TODO: debounce
    @elScroller.addEventListener 'scroll', @updateContents
    @elScroller.addEventListener 'update', @updateContents

    return

  updateContents: ->
    # This context is the element being scrolled
    currentPos = this.scrollLeft
    elParent = this.parentNode
    elContainerWidth = this.clientWidth
    elContentWidth = this.querySelector('table').clientWidth

    # Checks if content overflows it's container
    if elContentWidth > elContainerWidth
      elParent.classList.add 'overflowRight'

    # Checks if content is scrolled to the right
    if currentPos > 20
      elParent.classList.add 'overflowLeft'
    else
      elParent.classList.remove 'overflowLeft'

    # Checks if the content is scrolled almost to the right limit
    if elContentWidth - currentPos - 20 < elContainerWidth
      elParent.classList.remove 'overflowRight'
    else
      elParent.classList.add 'overflowRight'





# USAGE
# Makes an array from the query selector
# and applies the new constructor on each element
tableSliders = document.querySelectorAll '.slideTable'
Array::forEach.call tableSliders, (el, i) ->
  slider = new TableSlider el


event = new CustomEvent 'update'
myEl = document.querySelectorAll '.TableSlider-wrapSlider'
for el in myEl
  el.dispatchEvent event

# event2 = new CustomEvent 'init'
# myEl.dispatchEvent event2
