# This function is ran after window is fully loaded
$ ->
  # Load Bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip placement: "bottom"

# Transform date array to date
Array::toDate = -> new Date @[0], @[1] - 1, @[2], 0, 0, 0, 0

# Nice string representation of date
Date::yyyymmdd = -> @toISOString().substring 0, 10

# Create main Angular module
luncheon = window.luncheon = 
  angular.module "luncheon", [
    "ngRoute",
    "restangular",
    "ngLoadingSpinner"
    ]

luncheon.constant 'Config',
  ###
  When set to true, app will try to load dummy data and ignore errors
  during rest calls
  ###
  mockRest: true

# Set page title variable based on current route
luncheon.run ($rootScope, $location, Config) ->
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    $rootScope.title = if _.has(current.$$route, "title")
      current.$$route.title
    else ""
  
  # Call when the the login is confirmed
  $rootScope.$on 'loginSuccessful', ->
    $location.path('/user')
  
  # Call when the the login failed
  $rootScope.$on 'loginFailed', ->
    if Config.mockRest then $location.path('/user') else $location.path('/')
  
  # Call when we logged out
  $rootScope.$on 'logout', ->
    $location.path('/')