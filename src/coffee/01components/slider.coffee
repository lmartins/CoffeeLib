# Based on https://github.com/jedrzejchalubek/Glide.js/blob/master/src/jquery.glide.js
(($, window, document, undefined_) ->

  name = 'glide'
  defaults =
    # false para desligar autoplay
    autoplay: 4000
    hoverpause: true
    circular: false
    animationDuration: 500
    animationTimingFunc: 'cubic-bezier(0.165, 0.840, 0.440, 1.000)'
    arrows: true
    arrowsWrapperClass: 'slider-arrows'
    arrowMainClass: 'slider-arrow'
    arrowRightClass: 'slider-arrow--right'
    arrowRightText: 'next'
    arrowLeftClass: 'slider-arrow--left'
    arrowLeftText: 'prev'

    # Navigation
    navigation: true
    navigationCenter: true
    navigationClass: 'slider-nav'
    navigationItemClass: 'slider-nav__item'
    navigationCurrentItemClass: 'slider-nav__item--current'
    keyboard: true
    touchDistance: 60

    # Callback antes do plugin init
    beforeInit: ->

    # Callback após do plugin init
    afterInit: ->

    # Callback antes da mudança de slide
    beforeTransition: ->

    # Callback após da mudança de slide
    afterTransition: ->


  # Slider Constructor -------------------------------------------
  Glide = (parent, options) ->
    self = this

    # extender as opções
    @options = $.extend({}, defaults, options)
    @currentSlide = 0
    # Se animações CSS não são suportadas variável muda para false e as transições
    # são feitas recorrendo à função animate
    if not @css.isSupported('transition') or not @css.isSupported('transform')
      @cssSupport = false
    else
      @cssSupport = true

    # If circular set offset, two cloned slides
    @offset = if @options.circular then 2 else 0

    # Callbacks antes do plugin iniciar
    @options.beforeInit.call(this)

    # sidebar
    @parent = parent
    @init()
    @play()

    # callback após iniciar
    @options.afterInit.call(this)


    # API
    # Retornar os métodos do slider

    # Obter o slide actual
    current: ->
      -(self.currentSlide) + 1

    # Reiniciar e recalcular as dimensões dos elementos
    reinit: ->
      self.init()

    # Iniciar autoplay
    play: ->
      self.play()

    # Parar Autoplay
    stop: ->
      self.pause()

    # Avançar um slide
    next: (callback) ->
      self.slide 1, false, callback

    # Recuar um slide
    prev: (callback) ->
      self.slide distance - 1, true, callback

    # Avançar para slide especifico
    jump: (distance, callback) ->
      self.slide distance-1, true, callback

    # Adiciona navegação a elemento específico
    nav: (target) ->
      # Se elemento já existe remove para evitar duplicação de elementos
      self.navigation.wrapper.remove() if self.navigation.wrapper

      # Enquanto target não é especificado usar o slider wrapper
      self.options.navigation = if target then target else self.options.navigation

      # build
      self.navigation()

    # Adiciona arrows ao target especificado
    arrows: (target) ->
      # prevenir duplicação de elementos
      self.arrows.wrapper.remove() if self.arrows.wrapper

      # Enquanto target não é especificado usar o slider wrapper
      self.options.arrows = if target then target else self.options.arrows

      self.arrows()

  # Construir o Slider -------------------------------------------
  Glide::build = ->
    @bindings()

    # se mais do que um slide
    if @slides.length > 1
      @circular() if @options.circular
      @arrows() if @options.arrows
      @navigation() if @options.navigation

    # attach events
    @events()

  # Constroi elementos para navegação circular
  # Clona primeiro e último slide
  # Calcula o width do wrapper considerando elementos adicionais
  # move o wrapper para o primeiro slide
  Glide::circular = ->

    # Clona primeiro e último e estabelece width para cada um deles
    @firstClone = @slides.filter(':first-child').clone().width(@slides.spread)
    @lastClone = @slides.filter(':last-child').clone().width(@slides.spread)

    # Adiciona os elementos clonados à respectiva posição no wrapper
    # Recalcula o width do wrapper
    # Clear translate and skip cloned last slide at the beginning
    @wrapper
      .append(@firstClone)
      .prepend(@lastClone)
      .width( @parent.width() * (@slides.length+2) )
      .trigger 'clearTransition'
      .trigger 'setTranslate', [-@slides.spread]


  # Build navigation DOM
  Glide::navigation = ->
    @navigation.items = {}
    @navigation.wrapper = $('<div />',
      'class': @options.navigationClass
    ).appendTo(
      if @options.navigation is true then @parent else @options.navigation
    )
    i=0
    while i < @slides.length
      @navigation.items[i] = $('<a />',
        'href': '#'
        'class': @options.navigationItemClass
        'data-distance': i
      ).appendTo(
        @navigation.wrapper
      )
      i++

    @navigation.items[0].addClass @options.navigationCurrentItemClass

    # Se opção centered é verdadeira
    if @options.navigationCenter
      @navigation.wrapper.css
        'left': '50%'
        'width': @navigation.wrapper.children().outerWidth(true) * @navigation.wrapper.children().length
        'margin-left': -(@navigation.wrapper.outerWidth(true) / 2)


  # Build Arrows DOM
  Glide::arrows = ->

    # Wrapper para as arrows
    @arrows.wrapper = $('<div />',
      'class': @options.arrowsWrapperClass
    ).appendTo(
      if @options.arrows is true then @parent else @options.arrows
    )
    # Right Arrow
    @arrows.right = $('<a />',
      'href': '#'
      'class': @options.arrowMainClass + ' ' + @options.arrowRightClass
      'data-distance': '1'
      'html': @options.arrowRightText
    ).appendTo(
      @arrows.wrapper
    )

    # Left Arrow
    @arrows.left = $('<a />',
      'href': '#'
      'class': @options.arrowMainClass + ' ' + @options.arrowLeftClass
      'data-distance': '-1'
      'html': @options.arrowLeftText
    ).appendTo(
      @arrows.wrapper
    )


  # Function bindings
  Glide::bindings = ->
    self = this
    o = @options
    prefix = @css.getPrefix()

    # Setup slider wrapper bindings for translate and transition control
    @wrapper.bind
      'setTransition': ->
        $(this).css(
          prefix + 'transition',
          prefix + 'transform' + o.animationDuration + 'ms ' + o.animationTimingFunc
        )

      # Para efeito de salto imediato
      'clearTransition': ->
        $(this).css prefix + 'transition', 'none'

      'setTranslate': (event, translate) ->
        # se css3 suportado usa translate3d
        if self.cssSupport
          $(this).css(
            prefix + 'transform',
            'translate3d(' + translate + 'px, 0px, 0px)'
          )
        else
          $(this).css 'margin-left', translate


  # Events controllers
  Glide::events = ->

    # Swipe
    if @options.touchDistance
      @parent.on
        'touchstart MSPointerDown': $.proxy( @events.touchstart, this )
        'touchmove MSPointerMove': $.proxy( @events.touchmove, this )
        'touchend MSPointerUp': $.proxy( @events.touchend, this )

    # Arrows
    if @arrows.wrapper
      $(@arrows.wrapper).children().on 'click touchstart',
        $.proxy( @events.arrows, this )

    # Navigation
    if @navigation.wrapper
      $(@navigation.wrapper).children().on 'click touchstart',
        $.proxy( @events.navigation, this )

    # Keyboard
    if @options.keyboard
      $(document).on 'keyup.glideKeyup',
        $.proxy( @events.keyboard, this )

    # Slider hover
    if @options.hoverpause
      @parent.on 'mouseover mouseout',
        $.proxy( @events.hover, this )

    # Slider resize
    $(window).on 'resize',
      $.proxy( @events.resize, this )

  # Navigation Events Controller
  Glide::events.navigation = (event) ->
    unless @wrapper.attr 'disabled'
      event.preventDefault()
      # slide distance specified in data-attribute
      @slide( $(event.currentTarget).data('distance'), true )


  # Arrows event controller
  Glide::events.arrows = (event) ->
    unless @wrapper.attr 'disabled'
      event.preventDefault()
      @slide( $(event.currentTarget).data('distance'), false )


  # Keyboard arrows event controller
  Glide::events.keyboard = (event) ->
    unless @wrapper.attr 'disabled'
      # next
      if event.keyCode is 39 then @slide(1)
      # prev
      if event.keyCode is 37 then @slide(-1)


  # Pause on hover, reestart on mouseout
  Glide::events.hover = (event) ->
    @pause()
    @play() if event.type is 'mouseout'


  # Quando browser é redimensionado reinicia o plugin
  # com as novas dimensões
  # Corrige crop do slider actual
  Glide::events.resize = (event) ->
    # reinit com novas dimensões
    @dimensions()
    # crop to current slide
    @slide(0)

  # disable events that controls slide changes
  Glide::disabledEvents = ->
    @wrapper.attr 'disabled', true

  # enable events tha controls slide changes
  Glide::enableEvents = ->
    @wrapper.attr 'disabled', false

  # Touch Start
  Glide::events.touchstart = (event) ->
    # cache event
    touch = event.originalEvent.touches[0] or event.originalEvent.changedTouches[0]
    # get touch start points
    @events.touchStartX = touch.pageX
    @events.touchStartY = touch.pageY
    @events.touchSin = null


  # Touch Move
  Glide::events.touchmove = (event) ->
    # cache event
    touch = event.originalEvent.touches[0] or event.originalEvent.changedTouches[0]

    # calculate start/end points
    subExSx = touch.pageX - @events.touchStartX
    subEySy = touch.pageY - @events.touchStartY
    # bitwise subExSx pow
    powEX = Math.abs subExSx << 2
    powEY = Math.abs subEySy << 2
    # calculate the length of the hypotenuse segment
    touchHypotenuse = Math.sqrt( powEX + powEY )
    # calculate the length of the cathetus segment
    touchCathetus = Math.sqrt ( powEY )

    # calculate the sine of the angle
    @events.touchSin = Math.asin ( touchCathetus / touchHypotenuse )

    event.preventDefault() if @events.touchSin * (180 / Math.PI) < 45


  # Touch End
  Glide::events.touchend = (event) ->
    touch = event.originalEvent.touches[0] or event.originalEvent.changedTouches[0]

    # Calculate touch distance
    touchDistance = touch.pageX - @events.touchStartX

    # while touch is positive and greater than distance set in options
    if ( touchDistance > @options.touchDistance ) and ( @events.touchSin * (180 / Math.PI) < 45 )
      # slide one back
      @slide(-1)
    else if (touchDistance < -@options.touchDistance ) and ( @events.touchSin * (180 / Math.PI) < 45 )
      # slide one forward
      @slide(1)


  # Slide change & animate login
  # @param  {int} distance
  # @param  {bool} jump
  # @param  {function} callback

  Glide::slide = (distance, jump, callback) ->
    # stop autoplay and clear timer
    @pause()

    # callbacks before slide change
    @options.beforeTransition.call(this)

    # setup variables
    self = this
    currentSlide = if jump then 0 else @currentSlide
    slidesLength = -(@slides.length-1)
    fromFirst = false
    fromLast = false

    # Check if current slide is first and direction is previous, then go to last slide
    # or current slide is last and direction is next, then go to the first slide
    # else change current slide normally

    if currentSlide is 0 and distance is -1
      fromFirst = true
      currentSlide = slidesLength
    else if currentSlide is slidesLength and distance is 1
      fromLast = true
      currentSlide = 0
    else
      currentSlide = currentSlide + (-distance)

    # Crop to current slide
    # mul slide width by current slide number
    offset = @slides.spread * currentSlide

    # While circular decrease offset with the width of single slide
    # When fromFirst and fromLast flags are set, unbind events thats controls changing
    # When fromLast flags is set, set offset to slide width mulled by slides count without cloned # slides
    # When fromFirst flags is set, set offset to zero

    if @options.circular
      offset = offset - @slides.spread
      @disabledEvents() if fromLast or fromFirst
      if fromLast then offset = @slides.spread * (slidesLength - 2 )
      if fromFirst then offset = 0

    # Slide change animation
    # while css3 supported use offset
    # if not use jquery animate
    if @cssSupport
      @wrapper
        .trigger( 'setTransition' )
        .trigger( 'setTranslate', [offset] )
    else
      @wrapper
        .stop()
        .animate
          'margin-left': offset
        , @options.animationDuration


    # while circular
    if @options.circular
      if fromFirst or fromLast
        @afterAnimation ->
          self.wrapper.trigger('clearTransition')
          self.enableEvents()

    # when fromLast flag is set
    # after animation makes immediate jump from cloned slide to proper one
    if fromLast
      @afterAnimation ->
        fromLast = false
        self.wrapper.trigger 'setTranslate', [-self.slides.spread]


    # when fromFirst flag is set
    # after animation makes immediate jump from cloned slide to proper one
    if fromFirst
      @afterAnimation ->
        fromFirst = false
        self.wrapper.trigger 'setTranslate', [self.slides.spread * (slidesLength-1)]


    # set to navigation item current class
    if @options.navigation and @navigation.wrapper
      $(@parent).children('.' + @options.navigationClass).children()
        .eq(-currentSlide)
        .addClass @options.navigationCurrentItemClass
        .siblings()
        .removeClass @options.navigationCurrentItemClass

    # Update current slide globally
    @currentSlide = currentSlide

    # callbacks after slide change
    @afterAnimation ->
      self.options.afterTransition.call(self)
      if ( callback isnt 'undefined' ) and ( typeof callback is 'function' ) then callback()

    # start autoplay
    @play()


  # Autoplay logic
  Glide::play = ->
    self = this

    # If autoplay slide one forward after a set time
    if @options.autoplay
      @auto = setInterval ->
        self.slide 1, false
      , @options.autoplay

  # Autoplay pause
  Glide::pause = ->
    @auto = clearInterval(@auto) if @options.autoplay

  # Call Callback after animation duration
  # Added 10ms to duration to be sure is fired after animation
  Glide::afterAnimation = (callback) ->
    setTimeout ->
      callback()
    , @options.animationDuration + 10


  # Dimensions
  # Get & set dimensions of slider elements
  Glide::dimensions = ->
    # get slides width
    @slides.spread = @parent.width()
    # set wrapper width
    @wrapper.width( @slides.spread * (@slides.length + @offset) )
    # set slide width
    @slides.add(@firstClone).add( @lastClone).width(@slides.spread)

  # Initialize
  # Set wrapper
  # Set slides
  # Set animation type
  Glide::init = ->

    # Set slides wrapper
    @wrapper = @parent.children()
    # set slides
    @slides = @wrapper.children()
    # set slider dimensions
    @dimensions()

    # build DOM
    @build()


  # Methods for CSS3 management
  Glide::css =
    isSupported: (declaration) ->
      isSupported = false
      prefixes = 'Khtml ms O Moz Webkit'.split(' ')
      clone = document.createElement 'div'
      declarationCapital = null

      declaration = declaration.toLowerCase()
      isSupported = true if clone.style[declaration] isnt undefined
      if isSupported is false
        declarationCapital = declaration.charAt(0).toUpperCase() + declaration.substr(1)
        i = 0
        while i < prefixes.length
          if clone.style[prefixes[i] + declarationCapital] isnt undefined
            isSupported = true
            break
          i++

      if window.opera
        if window.opera.version() < 13 then isSupported = false

      if isSupported is 'undefined' or isSupported is undefined then isSupported = false

      return isSupported

    # Get browser css prefix
    getPrefix: ->
      return '' unless window.getComputedStyle
      styles = window.getComputedStyle(document.documentElement, '')
      return '-' + (Array::slice
        .call(styles)
        .join('')
        .match(/-(moz|webkit|ms)-/) or (styles.OLink is "" and [ "", "o" ])
      )[1] + '-'


  $.fn[name] = (options) ->
    @each ->
      # $.data this, "api_" + name, new Glide($(this), options)  unless $.data(this, "api_" + name)
      new Glide $(this), options


) jQuery, window, document
