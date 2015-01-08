$ ->
   for num in [0..31]
      $("#game").append("<div class=\"number\" data-num=\"#{num}\">#{num}</div>")

   numberValue = (e) ->
      $(e.currentTarget).text()

   byNumber = (a, b) ->
      a > b

   toggleNumber = (numbers, number) ->
      if number in numbers
         return numbers.filter (n) -> n isnt number
      else
         if numbers.length < 7
            return numbers.concat number
         else
            return numbers

   numberStream = (seed) ->
      $(".number").asEventStream("click")
      .map numberValue
      .map parseInt
      .scan seed, toggleNumber

   renderNumbers = (numbers) ->
      $(".number").removeClass "selected"
      $("#results").text numbers.sort(byNumber).join ","
      for n in numbers
         $("[data-num=#{n}]").addClass "selected"

   fromKey = (keyCode) ->
      $(document).asEventStream("keyup").filter( (e) -> e.keyCode == keyCode )

   # end of helpers

   resetClick = $("#clear").asEventStream("click")
   escapeKey = fromKey(27)

   rKey = fromKey(82).startWith("click")

   clearSelections = resetClick.merge(escapeKey)

   randomNumbers = rKey
      .flatMapLatest () -> numberStream([1..7])

   selectedNumbers = clearSelections
      .map([])
      .startWith([])
      .flatMapLatest (acc) -> numberStream(acc)
      .toProperty()


   enoughNumbers = selectedNumbers.map (nums) -> nums.length >= 7

   selectedNumbers.combine(randomNumbers, ".concat").onValue(renderNumbers)

   enoughNumbers.onValue (enable) -> $("#clear").toggle(enable)
