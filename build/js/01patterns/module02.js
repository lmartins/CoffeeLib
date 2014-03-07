
/*
THE PATTERN MODULE
http://toddmotto.com/mastering-the-module-pattern/
 */
'use strict';
var Module, ModuleTwo;

Module = (function() {
  var anotherMethod, privateMethod, someMethod;
  privateMethod = function() {};
  someMethod = function() {};
  anotherMethod = function() {};
  return {
    someMethod: someMethod,
    anotherMethod: anotherMethod
  };
})();

ModuleTwo = (function(Module) {
  Module.extension = function() {
    return console.log("Module is Extended");
  };
  return Module;
})(Module || {});

console.log(Module);

/*
//# sourceMappingURL=module02.js.map
*/
