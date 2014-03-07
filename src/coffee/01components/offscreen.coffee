###
Based on https://github.com/gijsroge/offscreen.js
###
(($) ->
  $.fn.offscreen = (options) ->
    defaults =
      rightClass: 'right-edge'
      leftClass: 'left-edge'
      bottomClass: 'bottom-edge'
      smartResize: false # depende da presença do utilitário debouncer

    # extend the default options with the ones passed by the user
    options = $.extend defaults, options

    $this = $(this)

    offscreenInitiate = ->
      windowWidth = $(window).width()
      windowHeight = $(window).height()
      $this.each ->
        self = $(this)
        left = self.offset().left
        top = self.offset().top
        width = self.outerWidth()
        height = self.outerHeight()

        if height + top > windowHeight
          self.addClass defaults.bottomClass

        if windowWidth < (left + width)
          self.addClass defaults.rightClass
        else if windowWidth > (left + width * 1.5)
          self.removeClass defaults.rightClass

        if left < 0
          self.addClass defaults.leftClass
        else if left * 2 > width
          self.removeClass defaults.leftClass

    offscreenInitiate()

    if defaults.smartResize

      $(window).on 'resize', debounce((e) ->
        offscreenInitiate()
      , 150, false)



)(jQuery)
