# Create our User controller
luncheon.controller "UserController", ( $scope
, NotifyService
, AuthService
, OrderService
, SessionService) ->
  # Load lunches
  now = new Date()
  onFulfilled = (response) -> $scope.orders = response
  onRejected = (error) ->
    NotifyService.danger "Objednávku #{now.toId()} sa nepodarilo načítať
      (chyba #{error.status})."
  
  OrderService.forDate(now).then onFulfilled, onRejected

  # List of months in their string representation
  $scope.months = [
    "Jan", "Feb", "Mar", "Apr", "Máj", "Jún",
    "Júl", "Aug", "Sep", "Okt", "Nov", "Dec"
    ]
  
  # We want to show user name right?
  $scope.username = -> SessionService.get().longName

  # Bind logout function to current scope
  $scope.logout = -> AuthService.logout()

  # Function that will order the lunch
  $scope.makeOrder = (order) ->
    unless order.selectedMeal
      NotifyService.warning "Objednávku #{order.date.toId()} sa nepodarilo
        spracovať (prosím vyberte aspoň jedno hlavné jedlo)."
      return

    onFulfilled = (response) ->
      order.ordered = true
      NotifyService.success "Objednávka #{order.date.toId()} bola úspešne
        spracovaná."
    
    onRejected = (error) ->
      NotifyService.danger "Objednávku #{order.date.toId()} sa nepodarilo
        spracovať (chyba #{error.status} #{error.statusText})."

    OrderService.save(order).then onFulfilled, onRejected
  
  # Function that cancel order of the lunch
  $scope.cancelOrder = (order) ->
    data = $.extend {}, order
    data.ordered = false
    data.selectedMeal = null
    data.selectedSoup = null

    onFulfilled = (response) ->
      order.ordered = data.ordered
      order.selectedMeal = data.selectedMeal
      order.selectedSoup = data.selectedSoup
      NotifyService.success "Objednávka #{order.date.toId()} bola úspešne
        zrušená."
    
    onRejected = (error) ->
      NotifyService.danger "Objednávku #{order.date.toId()} sa nepodarilo
        zrušiť (chyba #{error.status} #{error.statusText})."

    OrderService.save(data).then onFulfilled, onRejected