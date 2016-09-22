test = true
LUNCH_GET = 'lunches/date'
LUNCH_POST = 'lunches/lunch'

# Dummy data
dummyLunches = [
    description: "No proste obed"
    date: "2016-04-01"
    soup: true
    ordered: false
  ,
    description: "No proste ďalší obed"
    date: "2016-12-04"
    soup: false
    ordered: false
  ,
    description: "Obed obed obeeeed"
    date: "2016-05-03"
    soup: true
    ordered: false
  ,
    description: "Obeeeeeededeeeed"
    date: "2017-05-04"
    soup: true
    ordered: false
  ]

# Simplify adding messages even more
addMessage = (message, type) ->
  $("#messages").alert
    text: message
    type: type

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

getLunchData = (lunch) ->
  clone = $.extend {}, lunch
  clone.date = clone.date.raw
  clone

# Create our User controller
angular.module("luncheon").controller "UserController", ($scope, $http) ->
  # Load lunches
  onSuccess = (response) ->
    $scope.lunches = transformLunches response.data
  
  onFailure = (error)->
    $scope.lunches = if test then transformLunches(dummyLunches) else []
    addMessage "Obedy sa nepodarilo načítať' (chyba #{error.status}).", "danger"
  
  now = new Date().yyyymmdd()
  $http.get("#{LUNCH_GET}/#{now}").then onSuccess, onFailure

  # List of months in their string representation
  $scope.months = [
    "Jan", "Feb", "Mar", "Apr", "Máj", "Jún",
    "Júl", "Aug", "Sep", "Okt", "Nov", "Dec"
    ]
  
  # Function that will order the lunch
  $scope.order = (lunch) ->
    onSuccess = (response) ->
      lunch.ordered = true
      addMessage "Obed #{lunch.date.raw} bol úspešne objednaný.", "success"
    
    onFailure = (error)->
      lunch.ordered = true if test
      addMessage "Obed #{lunch.date.raw} sa nepodarilo objednať (chyba #{error.status}).", "danger"
    
    newLunch = getLunchData lunch
    newLunch.ordered = true
    $http.post(LUNCH_POST, newLunch).then onSuccess, onFailure
    