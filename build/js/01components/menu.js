var Menu, getSiblings,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

getSiblings = require("./utilities/siblings");

Menu = (function() {
  function Menu(elem) {
    this.elem = elem;
    this.toggleActiveItem = __bind(this.toggleActiveItem, this);
    this.menu = this.elem;
    this.menuItems = this.menu.children;
    this.menuInit();
  }

  Menu.prototype.menuInit = function() {
    var index, item, metaEl, _i, _len, _ref;
    _ref = this.menuItems;
    for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
      item = _ref[index];
      item.classList.add("item");
      item.classList.add("item" + (index + 1));
      item.addEventListener('click', this.toggleActiveItem);
      metaEl = document.createElement('span');
      metaEl.classList.add('meta');
      item.appendChild(metaEl);
    }
    this.menuUpdate();
  };

  Menu.prototype.toggleActiveItem = function(e) {
    var elem, item, others, _i, _len;
    elem = e.currentTarget;
    others = getSiblings(elem);
    elem.classList.add('is-active');
    for (_i = 0, _len = others.length; _i < _len; _i++) {
      item = others[_i];
      item.classList.remove('is-active');
    }
    this.menuUpdate();
  };

  Menu.prototype.menuUpdate = function() {
    var index, item, metaEl, _i, _len, _ref, _results;
    _ref = this.menuItems;
    _results = [];
    for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
      item = _ref[index];
      metaEl = item.querySelector('.meta');
      if (item.classList.contains('is-active')) {
        _results.push(metaEl.innerHTML = " - " + (index + 1) + " - Active");
      } else {
        _results.push(metaEl.innerHTML = " - " + (index + 1));
      }
    }
    return _results;
  };

  return Menu;

})();

/*
//# sourceMappingURL=menu.js.map
*/
