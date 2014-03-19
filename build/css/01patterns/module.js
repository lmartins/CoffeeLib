
/*
THE PATTERN MODULE
 */
'use strict';
var Module, ModuleTwo, NewsWidget;

NewsWidget = {
  settings: {
    numArticles: 5,
    articlesList: $('#articlesList'),
    moreButton: $('#moreBtn')
  },
  init: function() {
    console.log("News Widget initiated");
    return this.bindUIActions();
  },
  bindUIActions: function() {
    var self;
    self = this;
    return this.settings.moreButton.on('click', function() {
      return self.getMoreArtiles(self.settings.numArticles);
    });
  },
  getMoreArtiles: function(numToGet) {
    var self;
    self = this;
    return console.log(numToGet);
  }
};

NewsWidget.init();

Module = (function() {
  var publicAPI, publicMethod, _privateMethod;
  _privateMethod = function() {
    return console.log("Some text from the private method, called from the public method");
  };
  publicMethod = function() {
    console.log("something from the public method");
    return _privateMethod();
  };
  return publicAPI = {
    publicMethod: publicMethod
  };
})();

ModuleTwo = (function(Module) {
  Module.extension = function() {
    return console.log("Text from the extension Module");
  };
  return Module;
})(Module || {});

/*
//# sourceMappingURL=module.js.map
*/
