# Disable disabled things
$ -> $('body').on 'click', 'a.disabled', (event) -> event.preventDefault()

# Transform date array to date
Array::toDate = -> new Date @[0], @[1] - 1, @[2], 0, 0, 0, 0

# Nice string representation of date
Date::yyyymmdd = -> @toISOString().substring 0, 10
Date::toId = -> @yyyymmdd().split('-').join('')

# Create main Angular module
luncheon = window.luncheon = angular.module "luncheon", [ "ngRoute", "ngLoadingSpinner", "ui.bootstrap", "http-auth-interceptor" ]

# Authorization events
luncheon.constant 'AUTH_EVENTS',
  loginSuccess: 'event:auth-loginSuccess'
  loginFailed: 'event:auth-loginFailed'
  logoutSuccess: 'event:auth-logoutSuccess'
  loginRequired: 'event:auth-loginRequired'
  forbidden: 'event:auth-forbidden'

# User roles
luncheon.constant 'USER_ROLES',
  all: '*'
  admin: 'admin'
  user: 'user'

luncheon.constant 'CONFIG',
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

luncheon.run ($rootScope, $location, NotifyService, AuthService, CONFIG, AUTH_EVENTS) ->
  # Prevent changing routes if not allowed to
  $rootScope.$on '$routeChangeStart', (event, next) ->
    # If we are trying to go back to login page and we are already logged in, prevent it
    if next.originalPath == "/login" && AuthService.isAuthenticated()
      event.preventDefault()
      NotifyService.warning "Už ste prihlásený."
    # If we are trying to access page where login is required and we are not logged in, prevent it
    else if next.loginRequired
      unless AuthService.isAuthorized(next.authorizedRoles)
        if AuthService.isAuthenticated()
          NotifyService.danger "Na prístup k #{next.originalPath} nemáte povolenie."
          $rootScope.$broadcast AUTH_EVENTS.notAuthorized
        else
          NotifyService.danger "Na prístup k #{next.originalPath} musíte byť prihlásený."
          $rootScope.$broadcast AUTH_EVENTS.forbidden
  
  # Set page title variable based on current route
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    $rootScope.title = if _.has(current.$$route, "title")
      current.$$route.title
    else ""
  
  # Call when the the login is confirmed
  $rootScope.$on AUTH_EVENTS.loginSuccess, ->
    $location.path('/user').replace()
  
  # Call when the the login failed
  $rootScope.$on AUTH_EVENTS.loginFailed, ->
    $location.path('/login').replace()
  
  # Call when someone tried to access page where login is required
  $rootScope.$on AUTH_EVENTS.loginRequired, ->
    $location.path('/login')
  
  # Call when we do not have permissions to do what we want to do
  $rootScope.$on AUTH_EVENTS.forbidden, ->
    $location.path('/login').replace()

  # Call when we logged out
  $rootScope.$on AUTH_EVENTS.logoutSuccess, ->
    $location.path('/login')