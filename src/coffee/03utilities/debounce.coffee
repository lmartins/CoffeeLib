
# based on http://unscriptable.com/2009/03/20/debouncing-javascript-methods/

debounce = (func, threshold, execAsap) ->
  timeout = undefined
  # returns the new debounced function which executes the original function only once
  # until the detection period expires
  debounced = ->
    delayed = ->
      # unless we're executing at the end of the execution time
      func.apply obj, args unless execAsap
      # clear the timeout handle
      timeout = null

    obj = this # reference to original context object
    args = arguments # arguments at execution time

    # stop any current detection perior
    if timeout
      clearTimeout timeout
    # otherwise, if we're not already waiting and we're executing
    # at the beginning of the detection perior
    else func.apply obj, args  if execAsap

    # reset the detection period
    timeout = setTimeout(delayed, threshold or 100)
