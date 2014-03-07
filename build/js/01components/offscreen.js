
/*
Based on https://github.com/gijsroge/offscreen.js
 */
(function($) {
  return $.fn.offscreen = function(options) {
    var $this, defaults, offscreenInitiate;
    defaults = {
      rightClass: 'right-edge',
      leftClass: 'left-edge',
      bottomClass: 'bottom-edge',
      smartResize: false
    };
    options = $.extend(defaults, options);
    $this = $(this);
    offscreenInitiate = function() {
      var windowHeight, windowWidth;
      windowWidth = $(window).width();
      windowHeight = $(window).height();
      return $this.each(function() {
        var height, left, self, top, width;
        self = $(this);
        left = self.offset().left;
        top = self.offset().top;
        width = self.outerWidth();
        height = self.outerHeight();
        if (height + top > windowHeight) {
          self.addClass(defaults.bottomClass);
        }
        if (windowWidth < (left + width)) {
          self.addClass(defaults.rightClass);
        } else if (windowWidth > (left + width * 1.5)) {
          self.removeClass(defaults.rightClass);
        }
        if (left < 0) {
          return self.addClass(defaults.leftClass);
        } else if (left * 2 > width) {
          return self.removeClass(defaults.leftClass);
        }
      });
    };
    offscreenInitiate();
    if (defaults.smartResize) {
      return $(window).on('resize', debounce(function(e) {
        return offscreenInitiate();
      }, 150, false));
    }
  };
})(jQuery);

/*
//# sourceMappingURL=offscreen.js.map
*/
