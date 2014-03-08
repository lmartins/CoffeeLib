var mw;

mw = (function(mw) {
  var myFeature;
  myFeature = {
    config: {
      container: $('#myFeature'),
      itemNavSelector: 'h3',
      itemNavProcessor: function($selection) {
        return 'Preview of ' + $selection.eq(0).text();
      }
    },
    init: function(config) {
      if (config && typeof config === 'object') {
        $.extend(myFeature.config, config);
      }
      myFeature.$container = myFeature.config.container;
      myFeature.$sections = myFeature.$container.find('ul.sections > li');
      myFeature.$container.addClass('MultiIndex');
      myFeature.$section_nav = $('<ul/>').attr('id', 'section_nav').prependTo(myFeature.$container);
      myFeature.$item_nav = $('<ul/>').attr('id', 'item_nav').insertAfter(myFeature.$section_nav);
      myFeature.$content = $('<p/>').attr('id', 'content').insertAfter(myFeature.$item_nav);
      myFeature.buildSectionNav(myFeature.$sections);
      myFeature.$section_nav.find('li:first').click();
      myFeature.$container.find('ul.sections').hide();
      return myFeature.initialized = true;
    },
    buildSectionNav: function($sections) {
      return $sections.each(function() {
        var $section;
        $section = $(this);
        return $('<li/>').text($section.find('h2:first').text()).appendTo(myFeature.$section_nav).data('section', $section).click(myFeature.showSection);
      });
    },
    buildItemNav: function($items) {
      return $items.each(function() {
        var $item, myText;
        $item = $(this);
        myText = myFeature.config.itemNavProcessor($item.find(myFeature.config.itemNavSelector));
        return $('<li>').text(myText).appendTo(myFeature.$item_nav).data('item', $item).click(myFeature.showContentItem);
      });
    },
    showSection: function() {
      var $items, $li, $section;
      $li = $(this);
      myFeature.$item_nav.empty();
      myFeature.$content.empty();
      $section = $li.data('section');
      $li.addClass('current').siblings().removeClass('current');
      $items = $section.find('ul li');
      myFeature.buildItemNav($items);
      return myFeature.$item_nav.find('li:first').click();
    },
    showContentItem: function() {
      var $item, $li;
      $li = $(this);
      $li.addClass('current').siblings().removeClass('current');
      $item = $li.data('item');
      return myFeature.$content.html($item.html());
    }
  };
  return myFeature;
})(mw || {});

$(document).ready(mw.init);

/*
//# sourceMappingURL=multiindex.js.map
*/
