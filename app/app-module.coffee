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
  loginConfirmed: 'event:auth-loginConfirmed'
  loginFailed: 'event:auth-loginFailed'
  loginCancelled: 'event:auth-loginCancelled'
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

luncheon.run ($rootScope, $location, NotifyService, AuthService, SessionService, CONFIG, AUTH_EVENTS) ->
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
          $rootScope.$broadcast AUTH_EVENTS.forbidden
        else
          $rootScope.$broadcast AUTH_EVENTS.loginRequired
  
  # Set page title variable based on current route
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    $rootScope.title = if _.has(current.$$route, "title")
      current.$$route.title
    else ""
  
  # Call when the the login is confirmed
  $rootScope.$on AUTH_EVENTS.loginConfirmed, (event, data) ->
    NotifyService.success "Boli ste úspešne prihlásení."
    SessionService.create data
    $location.path('/user').replace()
  
  # Call when the the login failed
  $rootScope.$on AUTH_EVENTS.loginFailed, (event, error) ->
    NotifyService.danger "Prihlásenie sa nepodarilo (#{error.status} #{error.statusText})."
    SessionService.invalidate()
    $location.path('/login').replace()
  
  # Call when someone tried to access page where login is required
  $rootScope.$on AUTH_EVENTS.loginRequired, (event, error) ->
    NotifyService.danger "Na prístup musíte byť prihlásený."
    $location.path('/login')
  
  # Call when we do not have permissions to do what we want to do
  $rootScope.$on AUTH_EVENTS.forbidden, (event, error) ->
    NotifyService.danger "Na prístup nemáte povolenie."
    $location.path('/login').replace()

  # Call when we logged out
  $rootScope.$on AUTH_EVENTS.loginCancelled, (event, data) ->
    NotifyService.info "Boli ste odhlásení."
    SessionService.invalidate()
    $location.path('/login')