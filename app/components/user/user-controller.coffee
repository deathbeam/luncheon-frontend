# Dummy data
dummyLunches = [
    description: "No proste obed"
    date: [ 2016, 4, 1 ]
    soup: true
    ordered: false
  ,
    description: "No proste ďalší obed"
    date: [ 2016, 12, 4 ]
    soup: false
    ordered: false
  ,
    description: "Obed obed obeeeed"
    date: [ 2016, 5, 3 ]
    soup: true
    ordered: false
  ,
    description: "Obeeeeeededeeeed"
    date: [ 2017, 1, 22 ]
    soup: true
    ordered: false
  ]

# Create our User controller
luncheon.controller "UserController", ($scope, Restangular, NotifyService, AuthService, Config) ->
  Lunches = Restangular.all 'lunches'

  # Load lunches
  Lunches.one('date', new Date().yyyymmdd()).get().then (
    (response) ->
      $scope.lunches = response.data.sort (a, b) -> 
        a = a.date.toDate()
        b = b.date.toDate()
        a - b
    ), (
    (error) ->
      if Config.mockRest
        $scope.lunches = dummyLunches.sort (a, b) -> 
          a = a.date.toDate()
          b = b.date.toDate()
          a - b
      
      NotifyService.danger "Obedy sa nepodarilo načítať' (chyba #{error.status})."
    )

  # List of months in their string representation
  $scope.months = [
    "", # Empty entry because of 1 based months from Spring
    "Jan", "Feb", "Mar", "Apr", "Máj", "Jún",
    "Júl", "Aug", "Sep", "Okt", "Nov", "Dec"
    ]
  
  $scope.logout = -> AuthService.logout()

  # Function that will order the lunch
  $scope.order = (lunch) ->
    data = $.extend {}, lunch
    data.ordered = true

    Lunches.all('lunch').post(data).then (
      (response) ->
        lunch.ordered = true
        NotifyService.success "Obed #{lunch.date.raw} bol úspešne objednaný."
      ), (
      (error) ->
        lunch.ordered = true if Config.mockRest
        NotifyService.danger "Obed #{lunch.date.raw} sa nepodarilo objednať (chyba #{error.status})."
      )
    