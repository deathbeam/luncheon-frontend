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
  
  # Bind logout function to current scope
  $scope.logout = -> AuthService.logout()

  # Function that will order the lunch
  $scope.makeOrder = (order) ->
    unless order.selectedMeal
      NotifyService.warning "Objednávku #{order.date.toId()} sa nepodarilo spracovať (prosím vyberte aspoň jedno hlavné jedlo)."
      return

    OrderService.save(order).then (
      (response) ->
        order.ordered = true
        NotifyService.success "Objednávka #{order.date.toId()} bola úspešne spracovaná."
      ), (
      (error) ->
        order.ordered = true if CONFIG.mockRest
        NotifyService.danger "Objednávku #{order.date.toId()} sa nepodarilo spracovať (chyba #{error.status} #{error.statusText})."
      )
  
  # Function that cancel order of the lunch
  $scope.cancelOrder = (order) ->
    data = $.extend {}, order
    data.ordered = false
    data.selectedMeal = null
    data.selectedSoup = null

    OrderService.save(data).then (
      (response) ->
        order.ordered = data.ordered
        order.selectedMeal = data.selectedMeal
        order.selectedSoup = data.selectedSoup
        NotifyService.success "Objednávka #{order.date.toId()} bola úspešne zrušená."
      ), (
      (error) ->
        if CONFIG.mockRest
          order.ordered = data.ordered
          order.selectedMeal = data.selectedMeal
          order.selectedSoup = data.selectedSoup
        
        NotifyService.danger "Objednávku #{order.date.toId()} sa nepodarilo zrušiť (chyba #{error.status} #{error.statusText})."
      )
    