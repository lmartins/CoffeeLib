
/*
THE PATTERN MODULE
 */
'use strict';
var NewsWidget;

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

/*
//# sourceMappingURL=module.js.map
*/
