# Create our User controller
luncheon.controller "UserController", ($scope, $http, NotifyService, AuthService, OrderService, Config) ->
  # Split orders to soups and meals and sort them
  transformOrders = (orders) ->
    transformed = new Map()

    divide = (order, l) ->
      order.ordered = order.ordered || l.ordered

      switch l.lunch.soup
        when true 
          order.soups.push l
          order.selectedSoup = l if l.ordered
        when false
          order.meals.push l
          order.selectedMeal = l if l.ordered

    add = (l) ->
      key = l.lunch.date.toDate().yyyymmdd()

      unless transformed.has key
        transformed.set key,
          ordered: false
          date: l.lunch.date.toDate()
          soups: []
          meals: []

      divide transformed.get(key), l

    orders.forEach (l) -> add(l)
    Array.from(transformed.values()).sort (a, b) -> 
        a.date - b.date

  # Load lunches
  now = new Date()
  OrderService.forDate(now).then (
    (response) ->
      $scope.orders = transformOrders response
    ), (
    (error) ->
      NotifyService.danger "Objednávku #{now.toId()} sa nepodarilo načítať (chyba #{error.status})."
    )

  # List of months in their string representation
  $scope.months = [
    "Jan", "Feb", "Mar", "Apr", "Máj", "Jún",
    "Júl", "Aug", "Sep", "Okt", "Nov", "Dec"
    ]
  
  $scope.logout = -> AuthService.logout()

  $scope.selected = value: [ 2016, 1, 11 ].toDate()

  # Function that will order the lunch
  $scope.save = (lunch) ->
    data = $.extend {}, lunch
    data.ordered = true

    $http.post("lunches/lunch", data).then (
      (response) ->
        lunch.ordered = true
        NotifyService.success "Objednávka #{lunch.date.toId()} bola úspešne spracovaná."
      ), (
      (error) ->
        lunch.ordered = true if Config.mockRest
        NotifyService.danger "Objednávku #{lunch.date.toId()} sa nepodarilo spracovať (chyba #{error.status})."
      )
  
  # Function that will order the lunch
  $scope.cancel = (lunch) ->
    data = $.extend {}, lunch
    data.ordered = false

    $http.post("lunches/lunch", data).then (
      (response) ->
        lunch.ordered = false
        NotifyService.success "Objednávka #{lunch.date.toId()} bola úspešne zrušená."
      ), (
      (error) ->
        lunch.ordered = false if Config.mockRest
        NotifyService.danger "Objednávku #{lunch.date.toId()} sa nepodarilo zrušiť (chyba #{error.status})."
      )
    