# Dummy data
dummyLunches = [
    description: "No proste obed"
    date: "2016-04-01"
    soup: true
    ordered: true
  ,
    description: "No proste ďalší obed"
    date: "2016-05-04"
    soup: false
    ordered: false
  ]

# Convert date string to day, month and year
parseDate = (dateString) ->
  date = new Date Date.parse(dateString)

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
  
  transformed.sort (a, b) -> new Date(a.date.raw) - new Date(b.date.raw)

# Create our User module
angular.module("luncheon").controller "User", ($scope, $http) ->
  # Load lunches
  $scope.lunches = transformLunches dummyLunches

  # Convert month number to it's string representation
  $scope.months = [
    "Jan", "Feb", "Mar", "Apr", "Máj", "Jún",
    "Júl", "Aug", "Sep", "Okt", "Nov", "Dec"
    ]