// Generated by CoffeeScript 1.8.0
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  $(function() {
    var byNumber, elementValue, enoughNumbers, num, numberStream, numberValue, selectedNumbers, toggleNumber, _i;
    for (num = _i = 0; _i <= 31; num = ++_i) {
      $("#game").append("<div class=\"number\" data-num=\"" + num + "\">" + num + "</div>");
    }
    numberValue = function(e) {
      return $(e.currentTarget).text();
    };
    elementValue = function(e) {
      return $(e.currentTarget);
    };
    byNumber = function(a, b) {
      return a > b;
    };
    toggleNumber = function(numbers, number) {
      if (__indexOf.call(numbers, number) >= 0) {
        return numbers.filter(function(n) {
          return n !== number;
        });
      } else {
        if (numbers.length < 7) {
          return numbers.concat(number);
        } else {
          return numbers;
        }
      }
    };
    numberStream = function() {
      return $(".number").asEventStream("click").map(numberValue).map(parseInt).scan([], toggleNumber);
    };
    selectedNumbers = numberStream();
    enoughNumbers = selectedNumbers.map(function(nums) {
      return nums.length >= 7;
    });
    selectedNumbers.onValue(function(numbers) {
      var n, _j, _len, _results;
      $(".number").removeClass("selected");
      $("#results").text(numbers.sort(byNumber).join(","));
      _results = [];
      for (_j = 0, _len = numbers.length; _j < _len; _j++) {
        n = numbers[_j];
        _results.push($("[data-num=" + n + "]").addClass("selected"));
      }
      return _results;
    });
    selectedNumbers.delay(2000).onEnd(function() {
      return $(".selected").removeClass("selected");
    });
    return enoughNumbers.onValue(function(enable) {
      return $("#clear").toggle(enable);
    });
  });

}).call(this);

//# sourceMappingURL=main.js.map