
/*
PUB/SUB PATTERN
 */
var pubsub;

pubsub = {
  init: function() {
    return this.bindEvents();
  },
  sendMessage: function() {
    var message;
    message = $('input').val();
    $('body').trigger('messageReceived', {
      message: message
    });
    return false;
  },
  displayMessage: function(data) {
    var li;
    $('body').trigger('messageDisplayed');
    li = $("<li />").text(data.message).css("display", "none");
    $("ul").append(li);
    return $("ul>li").last().fadeIn();
  },
  flashMessage: function() {
    return $('.flash').text('youve got a new message').fadeIn(500, function() {
      var self;
      self = this;
      return setTimeout((function() {
        return $(self).fadeOut(500);
      }), 2000);
    });
  },
  bindEvents: function() {
    $('form').on('submit', function() {
      pubsub.sendMessage();
      return false;
    });
    $('body').on('messageReceived', function(event, data) {
      return pubsub.displayMessage(data);
    });
    return $('body').on('messageDisplayed', function(event, data) {
      return pubsub.flashMessage();
    });
  }
};

$(function() {
  return pubsub.init();
});

/*
//# sourceMappingURL=pubsub.js.map
*/
