$ ->
   for num in [0..31]
      $("#game").append("<div class=\"number\" data-num=\"#{num}\">#{num}</div>")

   numberValue = (e) ->
      $(e.currentTarget).text()

   elementValue = (e) ->
      $(e.currentTarget)

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

      
   numberStream = () ->
      $(".number").asEventStream("click")
      .map numberValue
      .map parseInt
      .scan [], toggleNumber
 
   selectedNumbers = numberStream()
   enoughNumbers = selectedNumbers.map (nums) -> nums.length >= 7

   selectedNumbers.onValue (numbers) ->
      $(".number").removeClass "selected"
      $("#results").text numbers.sort(byNumber).join ","
      for n in numbers
         $("[data-num=#{n}]").addClass "selected"

   selectedNumbers.delay(2000).onEnd () ->
      $(".selected").removeClass "selected"

   enoughNumbers.onValue (enable) -> $("#clear").toggle(enable)

   #test