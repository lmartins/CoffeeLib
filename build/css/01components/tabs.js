var mdf;

mdf = {};

mdf.Tabs = function(el, options) {
  if (el) {
    return this.init(el, options);
  }
};

Tabs.prototype = function() {
  return {
    name: "mdf_tabs",
    init: function(el, options) {
      var tab;
      this.element = $(el);
      this.options = options;
      this.element.bind('destroyed', $.proxy(this.teardown, this));
      $.data(el, this.name, this);
      this.element.addClass(this.name + 'tabs');
      this.activate(this.element.children('li:first'));
      tab = this.tab;
      return this.element.children('li:gt(0)').each(function() {
        return tab($(this)).hide();
      });
    }
  };
};

mdf.HistoryTabs = function(el, options) {
  if (el) {
    return this.init(el, options);
  }
};

mdf.HistoryTabs.prototype = new mdf.Tabs();

$.extend(mdf.HistoryTabs.prototype, {
  name: 'mdf_history_tabs'
});

/*
//# sourceMappingURL=tabs.js.map
*/
