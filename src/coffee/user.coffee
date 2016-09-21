# Convert month number to it's string representation
monthToString = (monthNum) ->
  switch monthNum
    when 0 then "Jan"
    when 1 then "Feb"
    when 2 then "Mar"
    when 3 then "Apr"
    when 4 then "Máj"
    when 5 then "Jún"
    when 6 then "Júl"
    when 7 then "Aug"
    when 8 then "Sep"
    when 9 then "Okt"
    when 10 then "Nov"
    when 11 then "Dec"
    else ""

# Convert date string to day, month and year
parseDate = (dateString) ->
  date = new Date Date.parse(dateString)

  {
    raw: dateString
    day: date.getDate()
    month: date.getMonth()
    year: date.getYear()
  }

# Transform lunches data to usable representation that can be displayed in template
transformLunches = (lunches) ->
  viewLunches = []

  for lunch in lunches
    date = parseDate lunch.date
    date.month = monthToString date.month
    
    viewLunches.push
      date: date
      description: lunch.description
      soup: lunch.soup
      ordered: lunch.ordered
  
  viewLunches.sort (a, b) ->
    a = new Date a.date.raw
    b = new Date b.date.raw
    a - b

# Create our User module
angular.module("luncheon").controller "User", ($scope, $http) ->
  lunches = [
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

  $scope.lunches = transformLunches lunches