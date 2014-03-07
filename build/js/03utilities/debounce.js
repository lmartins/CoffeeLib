var debounce;

debounce = function(func, threshold, execAsap) {
  var debounced, timeout;
  timeout = void 0;
  return debounced = function() {
    var args, delayed, obj;
    delayed = function() {
      if (!execAsap) {
        func.apply(obj, args);
      }
      return timeout = null;
    };
    obj = this;
    args = arguments;
    if (timeout) {
      clearTimeout(timeout);
    } else {
      if (execAsap) {
        func.apply(obj, args);
      }
    }
    return timeout = setTimeout(delayed, threshold || 100);
  };
};

/*
//# sourceMappingURL=debounce.js.map
*/
