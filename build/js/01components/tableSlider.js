var TableSlider, tableSliders;

TableSlider = (function() {
  function TableSlider(elem) {
    this.elem = elem;
    this.init();
  }

  TableSlider.prototype.init = function() {
    var elContainer, elContainerWidth, elContent, elContentWidth, elScroller, newHTML, origHTML;
    elContent = this.elem;
    elContainer = elContent.parentNode;
    elContainerWidth = elContainer.clientWidth;
    elContentWidth = elContent.clientWidth;
    origHTML = elContainer.innerHTML;
    newHTML = "<div class='TableSlider-wrapSlider'>" + origHTML + "</div>";
    elContainer.innerHTML = newHTML;
    elScroller = elContainer.querySelector('.TableSlider-wrapSlider');
    if (elContentWidth > elContainerWidth) {
      elContainer.classList.add('overflowRight');
    }
    elScroller.addEventListener('scroll', function(e) {
      var currentPos;
      currentPos = this.scrollLeft;
      if (currentPos > 20) {
        elContainer.classList.add('overflowLeft');
      } else {
        elContainer.classList.remove('overflowLeft');
      }
      if (elContentWidth - currentPos - 20 < elContainerWidth) {
        return elContainer.classList.remove('overflowRight');
      } else {
        return elContainer.classList.add('overflowRight');
      }
    });
  };

  return TableSlider;

})();

tableSliders = document.querySelectorAll('.slideTable');

Array.prototype.forEach.call(tableSliders, function(el, i) {
  var slider;
  return slider = new TableSlider(el);
});

/*
//# sourceMappingURL=tableSlider.js.map
*/
