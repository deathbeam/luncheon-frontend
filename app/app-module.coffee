# Disable disabled things
$ -> $('body').on 'click', 'a.disabled', (event) -> event.preventDefault()

# Transform date array to date
Array::toDate = -> new Date @[0], @[1] - 1, @[2], 0, 0, 0, 0

# Nice string representation of date
Date::yyyymmdd = -> @toISOString().substring 0, 10
Date::toId = -> @yyyymmdd().split('-').join('')

# Create main Angular module
luncheon = window.luncheon = angular.module "luncheon", [ "ngRoute", "ngLoadingSpinner", "ui.bootstrap" ]

luncheon.constant 'Config',
  ###
  When set to true, app will try to load dummy data and ignore errors
  during rest calls
  ###
  mockRest: true

  ###
  Username and password to use for loggining in when we are mocking rest
  ###
  mockUsername: "admin"
  mockPassword: "admin"

luncheon.run ($rootScope, $location, SessionService, NotifyService, AuthService, Config) ->
  # Prevent changing routes if not allowed to
  $rootScope.$on '$routeChangeStart', (event, next) ->
    # If we are trying to go back to login page and we are already logged in, prevent it
    if next.originalPath == "/login" && SessionService.authenticated
      event.preventDefault()
      NotifyService.warning "Už ste prihlásený."
    # If we are trying to access page where login is required and we are not logged in, prevent it
    else if next.loginRequired
      AuthService.checkLogin()
      
      unless SessionService.authenticated
        NotifyService.danger "Na prístup k #{next.originalPath} musíte byť prihlásený."
        $rootScope.$broadcast "loginRequired"
  
  # Set page title variable based on current route
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    $rootScope.title = if _.has(current.$$route, "title")
      current.$$route.title
    else ""
  
  # Call when the the login is confirmed
  $rootScope.$on 'loginSuccessful', ->
    $location.path('/user').replace()
  
  # Call when the the login failed
  $rootScope.$on 'loginFailed', ->
    $location.path('/login').replace()
  
  # Call when someone tried to access page where login is required
  $rootScope.$on 'loginRequired', ->
    $location.path('/login')
  
  # Call when we logged out
  $rootScope.$on 'logout', ->
    $location.path('/login')