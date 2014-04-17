
class TableSlider

  constructor: (@elem) ->
    @init()

  init: ->

    elContent = @elem
    elContainer = elContent.parentNode
    elContainerWidth = elContainer.clientWidth
    elContentWidth = elContent.clientWidth

    origHTML = elContainer.innerHTML
    newHTML = "<div class='TableSlider-wrapSlider'>#{origHTML}</div>"
    elContainer.innerHTML = newHTML
    elScroller = elContainer.querySelector '.TableSlider-wrapSlider'

    # Checks if content overflows it's container
    if elContentWidth > elContainerWidth
      elContainer.classList.add 'overflowRight'

    elScroller.addEventListener 'scroll', (e) ->
      currentPos = @scrollLeft
      if currentPos > 20
        elContainer.classList.add 'overflowLeft'
      else
        elContainer.classList.remove 'overflowLeft'

      if elContentWidth - currentPos - 20 < elContainerWidth
        elContainer.classList.remove 'overflowRight'
      else
        elContainer.classList.add 'overflowRight'

    return




# USAGE
# Makes an array from the query selector
# and applies the new constructor on each element
tableSliders = document.querySelectorAll '.slideTable'
Array::forEach.call tableSliders, (el, i) ->
  slider = new TableSlider el
