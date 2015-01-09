$ ->

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


   getRandomNumber = (min, max) ->
      Math.floor(Math.random() * (max - min) + min)

   getRandomNumbers = (count) ->
      for[1..count]
         getRandomNumber(1,31)

   for num in [1..31]
      $("#game").append("<div class=\"number\" data-num=\"#{num}\">#{num}</div>")


   resetClickStream = $("#clear").asEventStream("click")
   escapeKeyStream = fromKey(27)
   rKeyUpStream = fromKey(82)

   clearSelectionsStream = resetClickStream.merge(escapeKeyStream)

   randomNumbers = rKeyUpStream
      .flatMapLatest () -> numberStream(getRandomNumbers(7))

   clearSelections = clearSelectionsStream
      .map([])
      .startWith([])
      .flatMapLatest (acc) -> numberStream(acc)

   selectedNumbers = clearSelections
      .merge(randomNumbers)
      .toProperty()

   enoughNumbers = selectedNumbers.map (nums) -> nums.length >= 7

   selectedNumbers.onValue renderNumbers

   enoughNumbers.onValue (enable) -> $("#clear").toggle(enable)
