# Create our User controller
luncheon.controller "UserController", ($scope, $http, NotifyService, AuthService, OrderService, CONFIG) ->
  # Load lunches
  now = new Date()
  OrderService.forDate(now).then (
    (response) ->
      $scope.orders = response
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
        lunch.ordered = true if CONFIG.mockRest
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
        lunch.ordered = false if CONFIG.mockRest
        NotifyService.danger "Objednávku #{lunch.date.toId()} sa nepodarilo zrušiť (chyba #{error.status})."
      )
    