luncheon.service "OrderService", ($http, $q, SessionService, BASE_URL) ->
  # Split orders to soups and meals and sort them
  transformOrders = (orders) ->
    transformed = new Map()

    splitToKind = (transformedOrder, order) ->
      transformedOrder.ordered = transformedOrder.ordered || order.ordered
      transformedOrder.changeable = transformedOrder.changeable &&
        order.changeable

      switch order.lunch.soup
        when true
          transformedOrder.soups.push order.lunch
          transformedOrder.selectedSoup = order.lunch if order.ordered
        when false
          transformedOrder.meals.push order.lunch
          transformedOrder.selectedMeal = order.lunch if order.ordered

    transform = (order) ->
      key = order.lunch.date.toDate().yyyymmdd()

      unless transformed.has key
        transformed.set key,
          ordered: false
          changeable: true
          date: order.lunch.date.toDate()
          user: order.user
          soups: []
          meals: []

      splitToKind transformed.get(key), order

    orders.forEach (order) -> transform(order)
    Array.from(transformed.values()).sort (a, b) -> a.date - b.date
  
  @forDate = (date, onSuccess, onFailure) ->
    date = date.toId()
    defer = $q.defer()

    rejectResult = (error) -> defer.reject error

    onOrderFulfilled = (response) ->
      orders = response.data.slice()
      lunchPromises = []
      
      orders.forEach (order) ->
        lunchPromises.push $http.get("#{BASE_URL}/lunches/id/#{order.lunch}")
      
      onLunchesFulfilled = (response) ->
        lunches = response.slice()

        orders.forEach (order) ->
          lunches.forEach (lunch) ->
            if parseInt(order.lunch) == parseInt(lunch.data.id)
              order.lunch = lunch.data

        defer.resolve transformOrders(orders)
      
      $q.all(lunchPromises).then(onLunchesFulfilled, rejectResult)

    $http
      .get("#{BASE_URL}/orders/date/#{date}/user/#{SessionService.getId()}")
      .then onOrderFulfilled, rejectResult

    defer.promise
  
  @save = (order) ->
    orders = []

    order.meals.forEach (meal) ->
      orders.push
        user: order.user
        lunch: meal.id
        ordered: order.selectedMeal && meal.id == order.selectedMeal.id || false
        changeable: order.changeable
    
    order.soups.forEach (soup) ->
      orders.push
        user: order.user
        lunch: soup.id
        ordered: order.selectedSoup && soup.id == order.selectedSoup.id || false
        changeable: order.changeable

    $http.post("#{BASE_URL}/orders/orders", orders)
  
  @
