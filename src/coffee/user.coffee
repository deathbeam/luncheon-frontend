# Dummy data
dummyLunches = [
    description: "No proste obed"
    date: "2016-04-01"
    soup: true
    ordered: false
  ,
    description: "No proste ďalší obed"
    date: "2016-05-04"
    soup: false
    ordered: false
  ]

# Convert date string to day, month and year
parseDate = (dateString) ->
  date = new Date dateString

  raw: dateString
  day: date.getDate()
  month: date.getMonth()
  year: date.getYear()

# Transform lunches data to usable representation that can be displayed in template
transformLunches = (lunches) ->
  transformed = []

  lunches.forEach (l) ->
    clone = $.extend {}, l
    clone.date = parseDate l.date
    transformed.push clone
  
  transformed.sort (a, b) -> Date.parse(a.date.raw) - Date.parse(b.date.raw)

# Create our User controller
angular.module("luncheon").controller "User", ($scope, $http) ->
  # Load lunches
  $scope.lunches = transformLunches dummyLunches

  # List of months in their string representation
  $scope.months = [
    "Jan", "Feb", "Mar", "Apr", "Máj", "Jún",
    "Júl", "Aug", "Sep", "Okt", "Nov", "Dec"
    ]
  
  # Function that will order the lunch
  $scope.order = (lunch) ->
    lunch.ordered = true