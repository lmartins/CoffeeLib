
/*
PUB/SUB PATTERN
 */
var pubsub, sendMessage;

pubsub = {};

$('form').on('submit', function() {
  return false;
});

sendMessage = function() {
  var message;
  message = $('input').val();
  $('body').trigger('messageReceived', {
    message: message
  });
  return false;
};

/*
//# sourceMappingURL=pubsub.js.map
*/
