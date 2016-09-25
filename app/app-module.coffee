# Disable disabled things
$ -> $('body').on 'click', 'a.disabled', (event) -> event.preventDefault()

# Transform date array to date
Array::toDate = -> new Date @[0], @[1] - 1, @[2], 0, 0, 0, 0

# Nice string representation of date
Date::yyyymmdd = -> @toISOString().substring 0, 10

# Construct ID from date
Date::toId = ->
  mm = @getMonth() + 1 # getMonth() is zero-based
  dd = @getDate()
  mm = "0#{mm}" if mm < 10
  dd = "0#{dd}" if dd < 10

  [@getFullYear(), mm, dd].join('')

# Create main Angular module
luncheon = window.luncheon = angular.module "luncheon", [
  "ngRoute",
  "ngCookies",
  "ngLoadingSpinner",
  "ui.bootstrap",
  "http-auth-interceptor"
]

# Base URL for rest calls
luncheon.constant 'BASE_URL', 'http://localhost:3000'

# Base on login/logout events
luncheon.constant 'REDIRECTS',
  home: '/user'
  login: '/login'
  errNotFound: '/error/404'
  errForbidden: '/error/403'
  errOther: '/error/500'

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

luncheon.run ( $rootScope
, $location
, NotifyService
, AuthService
, SessionService
, AUTH_EVENTS
, REDIRECTS) ->
  # Prevent changing routes if not allowed to
  $rootScope.$on '$routeChangeStart', (event, next) ->
    # If we are trying to go back to login page and we are already logged in,
    # prevent it
    if next.originalPath == REDIRECTS.login && AuthService.isAuthenticated()
      event.preventDefault()
      NotifyService.warning "Už ste prihlásení."
    # If we are trying to access page where login is required and we are not
    # logged in, prevent it
    else if next.loginRequired
      unless AuthService.isAuthorized(next.authorizedRoles)
        event.preventDefault()
        if AuthService.isAuthenticated()
          $rootScope.$broadcast AUTH_EVENTS.forbidden
        else
          $rootScope.$broadcast AUTH_EVENTS.loginRequired
  
  # Set page title variable based on current route
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    if _.has(current.$$route, 'title')
      $rootScope.title = current.$$route.title
  
  # Call when the the login is confirmed
  $rootScope.$on AUTH_EVENTS.loginConfirmed, (event, data) ->
    nextPath = if $rootScope.requestedPath
      $rootScope.requestedPath
    else REDIRECTS.home

    $rootScope.requestedPath = null
    NotifyService.success "Boli ste úspešne prihlásení."
    SessionService.create data
    $location.path(nextPath).replace()
  
  # Call when the the login failed
  $rootScope.$on AUTH_EVENTS.loginFailed, (event, error) ->
    NotifyService.danger "Prihlásenie sa nepodarilo
      (#{error.status} #{error.statusText})."
    
    SessionService.invalidate()
  
  # Call when someone tried to access page where login is required
  $rootScope.$on AUTH_EVENTS.loginRequired, (event, error) ->
    NotifyService.danger "Na prístup musíte byť prihlásení."
    SessionService.invalidate()
    $rootScope.requestedPath = $location.path()
    $location.path REDIRECTS.login
  
  # Call when we do not have permissions to do what we want to do
  $rootScope.$on AUTH_EVENTS.forbidden, (event, error) ->
    NotifyService.danger "Na prístup nemáte povolenie."
    $location.path(REDIRECTS.errForbidden).replace()

  # Call when we logged out
  $rootScope.$on AUTH_EVENTS.loginCancelled, (event, data) ->
    NotifyService.info "Boli ste odhlásení."
    SessionService.invalidate()
    $rootScope.requestedPath = null
    $location.path REDIRECTS.login