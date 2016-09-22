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
luncheon.controller "UserController", ($scope, Restangular, NotifyService) ->
  Lunches = Restangular.all 'lunches'

  # Load lunches
  Lunches.one('date', new Date().toISOString().substring(0, 10)).get().then (
    (response) ->
      $scope.lunches = response.data.sort (a, b) -> 
        a = new Date(a.date[0], a.date[1] - 1, a.date[2], 0, 0, 0, 0)
        b = new Date(b.date[0], b.date[1] - 1, b.date[2], 0, 0, 0, 0)
        a - b
    ), (
    (error) ->
      if test
        $scope.lunches = dummyLunches.sort (a, b) -> 
          a = new Date(a.date[0], a.date[1] - 1, a.date[2], 0, 0, 0, 0)
          b = new Date(b.date[0], b.date[1] - 1, b.date[2], 0, 0, 0, 0)
          a - b
      
      NotifyService.danger "Obedy sa nepodarilo načítať' (chyba #{error.status})."
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

    Lunches.all('lunch').post(data).then (
      (response) ->
        lunch.ordered = true
        NotifyService.success "Obed #{lunch.date.raw} bol úspešne objednaný."
      ), (
      (error) ->
        lunch.ordered = true if test
        NotifyService.danger "Obed #{lunch.date.raw} sa nepodarilo objednať (chyba #{error.status})."
      )
    