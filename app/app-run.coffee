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