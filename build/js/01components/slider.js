(function($, window, document, undefined_) {
  var Glide, defaults, name;
  name = 'glide';
  defaults = {
    autoplay: 4000,
    hoverpause: true,
    circular: false,
    animationDuration: 500,
    animationTimingFunc: 'cubic-bezier(0.165, 0.840, 0.440, 1.000)',
    arrows: true,
    arrowsWrapperClass: 'slider-arrows',
    arrowMainClass: 'slider-arrow',
    arrowRightClass: 'slider-arrow--right',
    arrowRightText: 'next',
    arrowLeftClass: 'slider-arrow--left',
    arrowLeftText: 'prev',
    navigation: true,
    navigationCenter: true,
    navigationClass: 'slider-nav',
    navigationItemClass: 'slider-nav__item',
    navigationCurrentItemClass: 'slider-nav__item--current',
    keyboard: true,
    touchDistance: 60,
    beforeInit: function() {},
    afterInit: function() {},
    beforeTransition: function() {},
    afterTransition: function() {}
  };
  Glide = function(parent, options) {
    var self;
    self = this;
    this.options = $.extend({}, defaults, options);
    this.currentSlide = 0;
    if (!this.css.isSupported('transition') || !this.css.isSupported('transform')) {
      this.cssSupport = false;
    } else {
      this.cssSupport = true;
    }
    this.offset = this.options.circular ? 2 : 0;
    this.options.beforeInit.call(this);
    this.parent = parent;
    this.init();
    this.play();
    this.options.afterInit.call(this);
    return {
      current: function() {
        return -self.currentSlide + 1;
      },
      reinit: function() {
        return self.init();
      },
      play: function() {
        return self.play();
      },
      stop: function() {
        return self.pause();
      },
      next: function(callback) {
        return self.slide(1, false, callback);
      },
      prev: function(callback) {
        return self.slide(distance - 1, true, callback);
      },
      jump: function(distance, callback) {
        return self.slide(distance - 1, true, callback);
      },
      nav: function(target) {
        if (self.navigation.wrapper) {
          self.navigation.wrapper.remove();
        }
        self.options.navigation = target ? target : self.options.navigation;
        return self.navigation();
      },
      arrows: function(target) {
        if (self.arrows.wrapper) {
          self.arrows.wrapper.remove();
        }
        self.options.arrows = target ? target : self.options.arrows;
        return self.arrows();
      }
    };
  };
  Glide.prototype.build = function() {
    this.bindings();
    if (this.slides.length > 1) {
      if (this.options.circular) {
        this.circular();
      }
      if (this.options.arrows) {
        this.arrows();
      }
      if (this.options.navigation) {
        this.navigation();
      }
    }
    return this.events();
  };
  Glide.prototype.circular = function() {
    this.firstClone = this.slides.filter(':first-child').clone().width(this.slides.spread);
    this.lastClone = this.slides.filter(':last-child').clone().width(this.slides.spread);
    return this.wrapper.append(this.firstClone).prepend(this.lastClone).width(this.parent.width() * (this.slides.length + 2)).trigger('clearTransition').trigger('setTranslate', [-this.slides.spread]);
  };
  Glide.prototype.navigation = function() {
    var i;
    this.navigation.items = {};
    this.navigation.wrapper = $('<div />', {
      'class': this.options.navigationClass
    }).appendTo(this.options.navigation === true ? this.parent : this.options.navigation);
    i = 0;
    while (i < this.slides.length) {
      this.navigation.items[i] = $('<a />', {
        'href': '#',
        'class': this.options.navigationItemClass,
        'data-distance': i
      }).appendTo(this.navigation.wrapper);
      i++;
    }
    this.navigation.items[0].addClass(this.options.navigationCurrentItemClass);
    if (this.options.navigationCenter) {
      return this.navigation.wrapper.css({
        'left': '50%',
        'width': this.navigation.wrapper.children().outerWidth(true) * this.navigation.wrapper.children().length,
        'margin-left': -(this.navigation.wrapper.outerWidth(true) / 2)
      });
    }
  };
  Glide.prototype.arrows = function() {
    this.arrows.wrapper = $('<div />', {
      'class': this.options.arrowsWrapperClass
    }).appendTo(this.options.arrows === true ? this.parent : this.options.arrows);
    this.arrows.right = $('<a />', {
      'href': '#',
      'class': this.options.arrowMainClass + ' ' + this.options.arrowRightClass,
      'data-distance': '1',
      'html': this.options.arrowRightText
    }).appendTo(this.arrows.wrapper);
    return this.arrows.left = $('<a />', {
      'href': '#',
      'class': this.options.arrowMainClass + ' ' + this.options.arrowLeftClass,
      'data-distance': '-1',
      'html': this.options.arrowLeftText
    }).appendTo(this.arrows.wrapper);
  };
  Glide.prototype.bindings = function() {
    var o, prefix, self;
    self = this;
    o = this.options;
    prefix = this.css.getPrefix();
    return this.wrapper.bind({
      'setTransition': function() {
        return $(this).css(prefix + 'transition', prefix + 'transform' + o.animationDuration + 'ms ' + o.animationTimingFunc);
      },
      'clearTransition': function() {
        return $(this).css(prefix + 'transition', 'none');
      },
      'setTranslate': function(event, translate) {
        if (self.cssSupport) {
          return $(this).css(prefix + 'transform', 'translate3d(' + translate + 'px, 0px, 0px)');
        } else {
          return $(this).css('margin-left', translate);
        }
      }
    });
  };
  Glide.prototype.events = function() {
    if (this.options.touchDistance) {
      this.parent.on({
        'touchstart MSPointerDown': $.proxy(this.events.touchstart, this),
        'touchmove MSPointerMove': $.proxy(this.events.touchmove, this),
        'touchend MSPointerUp': $.proxy(this.events.touchend, this)
      });
    }
    if (this.arrows.wrapper) {
      $(this.arrows.wrapper).children().on('click touchstart', $.proxy(this.events.arrows, this));
    }
    if (this.navigation.wrapper) {
      $(this.navigation.wrapper).children().on('click touchstart', $.proxy(this.events.navigation, this));
    }
    if (this.options.keyboard) {
      $(document).on('keyup.glideKeyup', $.proxy(this.events.keyboard, this));
    }
    if (this.options.hoverpause) {
      this.parent.on('mouseover mouseout', $.proxy(this.events.hover, this));
    }
    return $(window).on('resize', $.proxy(this.events.resize, this));
  };
  Glide.prototype.events.navigation = function(event) {
    if (!this.wrapper.attr('disabled')) {
      event.preventDefault();
      return this.slide($(event.currentTarget).data('distance'), true);
    }
  };
  Glide.prototype.events.arrows = function(event) {
    if (!this.wrapper.attr('disabled')) {
      event.preventDefault();
      return this.slide($(event.currentTarget).data('distance'), false);
    }
  };
  Glide.prototype.events.keyboard = function(event) {
    if (!this.wrapper.attr('disabled')) {
      if (event.keyCode === 39) {
        this.slide(1);
      }
      if (event.keyCode === 37) {
        return this.slide(-1);
      }
    }
  };
  Glide.prototype.events.hover = function(event) {
    this.pause();
    if (event.type === 'mouseout') {
      return this.play();
    }
  };
  Glide.prototype.events.resize = function(event) {
    this.dimensions();
    return this.slide(0);
  };
  Glide.prototype.disabledEvents = function() {
    return this.wrapper.attr('disabled', true);
  };
  Glide.prototype.enableEvents = function() {
    return this.wrapper.attr('disabled', false);
  };
  Glide.prototype.events.touchstart = function(event) {
    var touch;
    touch = event.originalEvent.touches[0] || event.originalEvent.changedTouches[0];
    this.events.touchStartX = touch.pageX;
    this.events.touchStartY = touch.pageY;
    return this.events.touchSin = null;
  };
  Glide.prototype.events.touchmove = function(event) {
    var powEX, powEY, subExSx, subEySy, touch, touchCathetus, touchHypotenuse;
    touch = event.originalEvent.touches[0] || event.originalEvent.changedTouches[0];
    subExSx = touch.pageX - this.events.touchStartX;
    subEySy = touch.pageY - this.events.touchStartY;
    powEX = Math.abs(subExSx << 2);
    powEY = Math.abs(subEySy << 2);
    touchHypotenuse = Math.sqrt(powEX + powEY);
    touchCathetus = Math.sqrt(powEY);
    this.events.touchSin = Math.asin(touchCathetus / touchHypotenuse);
    if (this.events.touchSin * (180 / Math.PI) < 45) {
      return event.preventDefault();
    }
  };
  Glide.prototype.events.touchend = function(event) {
    var touch, touchDistance;
    touch = event.originalEvent.touches[0] || event.originalEvent.changedTouches[0];
    touchDistance = touch.pageX - this.events.touchStartX;
    if ((touchDistance > this.options.touchDistance) && (this.events.touchSin * (180 / Math.PI) < 45)) {
      return this.slide(-1);
    } else if ((touchDistance < -this.options.touchDistance) && (this.events.touchSin * (180 / Math.PI) < 45)) {
      return this.slide(1);
    }
  };
  Glide.prototype.slide = function(distance, jump, callback) {
    var currentSlide, fromFirst, fromLast, offset, self, slidesLength;
    this.pause();
    this.options.beforeTransition.call(this);
    self = this;
    currentSlide = jump ? 0 : this.currentSlide;
    slidesLength = -(this.slides.length - 1);
    fromFirst = false;
    fromLast = false;
    if (currentSlide === 0 && distance === -1) {
      fromFirst = true;
      currentSlide = slidesLength;
    } else if (currentSlide === slidesLength && distance === 1) {
      fromLast = true;
      currentSlide = 0;
    } else {
      currentSlide = currentSlide + (-distance);
    }
    offset = this.slides.spread * currentSlide;
    if (this.options.circular) {
      offset = offset - this.slides.spread;
      if (fromLast || fromFirst) {
        this.disabledEvents();
      }
      if (fromLast) {
        offset = this.slides.spread * (slidesLength - 2);
      }
      if (fromFirst) {
        offset = 0;
      }
    }
    if (this.cssSupport) {
      this.wrapper.trigger('setTransition').trigger('setTranslate', [offset]);
    } else {
      this.wrapper.stop().animate({
        'margin-left': offset
      }, this.options.animationDuration);
    }
    if (this.options.circular) {
      if (fromFirst || fromLast) {
        this.afterAnimation(function() {
          self.wrapper.trigger('clearTransition');
          return self.enableEvents();
        });
      }
    }
    if (fromLast) {
      this.afterAnimation(function() {
        fromLast = false;
        return self.wrapper.trigger('setTranslate', [-self.slides.spread]);
      });
    }
    if (fromFirst) {
      this.afterAnimation(function() {
        fromFirst = false;
        return self.wrapper.trigger('setTranslate', [self.slides.spread * (slidesLength - 1)]);
      });
    }
    if (this.options.navigation && this.navigation.wrapper) {
      $(this.parent).children('.' + this.options.navigationClass).children().eq(-currentSlide).addClass(this.options.navigationCurrentItemClass).siblings().removeClass(this.options.navigationCurrentItemClass);
    }
    this.currentSlide = currentSlide;
    this.afterAnimation(function() {
      self.options.afterTransition.call(self);
      if ((callback !== 'undefined') && (typeof callback === 'function')) {
        return callback();
      }
    });
    return this.play();
  };
  Glide.prototype.play = function() {
    var self;
    self = this;
    if (this.options.autoplay) {
      return this.auto = setInterval(function() {
        return self.slide(1, false);
      }, this.options.autoplay);
    }
  };
  Glide.prototype.pause = function() {
    if (this.options.autoplay) {
      return this.auto = clearInterval(this.auto);
    }
  };
  Glide.prototype.afterAnimation = function(callback) {
    return setTimeout(function() {
      return callback();
    }, this.options.animationDuration + 10);
  };
  Glide.prototype.dimensions = function() {
    this.slides.spread = this.parent.width();
    this.wrapper.width(this.slides.spread * (this.slides.length + this.offset));
    return this.slides.add(this.firstClone).add(this.lastClone).width(this.slides.spread);
  };
  Glide.prototype.init = function() {
    this.wrapper = this.parent.children();
    this.slides = this.wrapper.children();
    this.dimensions();
    return this.build();
  };
  Glide.prototype.css = {
    isSupported: function(declaration) {
      var clone, declarationCapital, i, isSupported, prefixes;
      isSupported = false;
      prefixes = 'Khtml ms O Moz Webkit'.split(' ');
      clone = document.createElement('div');
      declarationCapital = null;
      declaration = declaration.toLowerCase();
      if (clone.style[declaration] !== void 0) {
        isSupported = true;
      }
      if (isSupported === false) {
        declarationCapital = declaration.charAt(0).toUpperCase() + declaration.substr(1);
        i = 0;
        while (i < prefixes.length) {
          if (clone.style[prefixes[i] + declarationCapital] !== void 0) {
            isSupported = true;
            break;
          }
          i++;
        }
      }
      if (window.opera) {
        if (window.opera.version() < 13) {
          isSupported = false;
        }
      }
      if (isSupported === 'undefined' || isSupported === void 0) {
        isSupported = false;
      }
      return isSupported;
    },
    getPrefix: function() {
      var styles;
      if (!window.getComputedStyle) {
        return '';
      }
      styles = window.getComputedStyle(document.documentElement, '');
      return '-' + (Array.prototype.slice.call(styles).join('').match(/-(moz|webkit|ms)-/) || (styles.OLink === "" && ["", "o"]))[1] + '-';
    }
  };
  return $.fn[name] = function(options) {
    return this.each(function() {
      return new Glide($(this), options);
    });
  };
})(jQuery, window, document);

/*
//# sourceMappingURL=slider.js.map
*/
