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
luncheon.controller "UserController", ($scope, $http, NotifyService, Config) ->
  # Load lunches
  $http.get('lunches/date/' + new Date().yyyymmdd())
    .success((data, status, headers, config) ->
      $scope.lunches = data.sort (a, b) -> 
        a = a.date.toDate()
        b = b.date.toDate()
        a - b
    ).error((data, status, headers, config) ->
      if Config.mockRest
        $scope.lunches = dummyLunches.sort (a, b) -> 
          a = a.date.toDate()
          b = b.date.toDate()
          a - b
      
      NotifyService.danger "Obedy sa nepodarilo načítať' (chyba #{status})."
    )

  # List of months in their string representation
  $scope.months = [
    "", # Empty entry because of 1 based months from Spring
    "Jan", "Feb", "Mar", "Apr", "Máj", "Jún",
    "Júl", "Aug", "Sep", "Okt", "Nov", "Dec"
    ]
  
  # Function that will order the lunch
  $scope.order = (lunch) ->
    data = $.extend {}, lunch
    data.ordered = true

    $http.post('lunches/lunch', data)
      .success((data, status, headers, config) ->
        lunch.ordered = true
        NotifyService.success "Obed #{lunch.date.toDate().yyyymmdd()} bol úspešne objednaný."
      ).error((data, status, headers, config) ->
        lunch.ordered = true if Config.mockRest
        NotifyService.danger "Obed #{lunch.date.toDate().yyyymmdd()} sa nepodarilo objednať (chyba #{status})."
      )
    