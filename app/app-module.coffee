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
    "ngResource"
    "ngRoute",
    "ngLoadingSpinner",
    "http-auth-interceptor"
    ]

luncheon.constant 'Config',
  ###
  When set to true, app will try to load dummy data and ignore errors
  during rest calls
  ###
  mockRest: true

  ###
  User roles for authentication
  ###
  roles:
    all: '*',
    admin: 'admin',
    user: 'user'

luncheon.run ($rootScope, $location, AuthSharedService, NotifyService, SessionService, Config) ->
  # Set page title variable based on current route
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    $rootScope.title = if _.has(current.$$route, "title")
      current.$$route.title
    else ""
  
  # Call when the 403 response is returned by the server
  $rootScope.$on 'event:auth-forbidden', (rejection) ->
     unless Config.mockRest then $rootScope.$evalAsync -> $location.path('/error/403').replace()
  
  # Call when the the client is confirmed
  $rootScope.$on 'event:auth-loginConfirmed', (event, data) ->
    SessionService.create(data)
    $rootScope.authenticated = true
    $location.path('/user')

  # Call when the 401 response is returned by the server
  $rootScope.$on 'event:auth-loginRequired', (event, data) ->
    SessionService.invalidate()
    $rootScope.authenticated = false
    $location.path('/login') unless Config.mockRest
  
  # If the user is not yet authenticated the function broadcast “event:auth-loginRequired”.
  # If the user is not authorized the function broadcast “event:auth-loginRequired”.
  $rootScope.$on '$routeChangeStart', (event, next) ->
    if next.originalPath == "/login" && $rootScope.authenticated
      event.preventDefault() unless Config.mockRest
      NotifyService.warning "Už ste prihlásený."
    else if next.access && next.access.loginRequired && !$rootScope.authenticated
      event.preventDefault() unless Config.mockRest
      NotifyService.danger "Na prístup k #{next.originalPath} musíte byť prihlásený."
      $rootScope.$broadcast "event:auth-loginRequired", {}
    else if next.access && !AuthSharedService.isAuthorized(next.access.authorizedRoles)
      event.preventDefault() unless Config.mockRest
      NotifyService.danger "Na prístup k #{next.originalPath} nemáte dostatočné oprávnenie."
      $rootScope.$broadcast "event:auth-forbidden", {}