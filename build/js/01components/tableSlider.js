var TableSlider;

TableSlider = (function() {
  function TableSlider(elem) {
    this.elem = elem;
    this.init();
  }

  TableSlider.prototype.init = function() {
    var newHTML, origHTML;
    this.elContent = this.elem;
    this.elContainer = this.elContent.parentNode;
    origHTML = this.elContainer.innerHTML;
    newHTML = "<div class='TableSlider-wrapSlider'>" + origHTML + "</div>";
    this.elContainer.innerHTML = newHTML;
    this.elScroller = this.elContainer.querySelector('.TableSlider-wrapSlider');
    this.elScroller.addEventListener('scroll', this.updateContents);
    this.elScroller.addEventListener('update', this.updateContents);
  };

  TableSlider.prototype.updateContents = function() {
    var currentPos, elContainerWidth, elContentWidth, elParent;
    currentPos = this.scrollLeft;
    elParent = this.parentNode;
    elContainerWidth = this.clientWidth;
    elContentWidth = this.querySelector('table').clientWidth;
    if (elContentWidth > elContainerWidth) {
      elParent.classList.add('overflowRight');
    }
    if (currentPos > 20) {
      elParent.classList.add('overflowLeft');
    } else {
      elParent.classList.remove('overflowLeft');
    }
    if (elContentWidth - currentPos - 20 < elContainerWidth) {
      return elParent.classList.remove('overflowRight');
    } else {
      return elParent.classList.add('overflowRight');
    }
  };

  return TableSlider;

})();

/*
//# sourceMappingURL=tableSlider.js.map
*/
