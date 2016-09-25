luncheon.service "AuthService", ( $rootScope
, $http
, authService
, SessionService
, USER_ROLES
, AUTH_EVENTS
, BASE_URL
) ->
  onLoginRejected = (error) ->
    $rootScope.$broadcast AUTH_EVENTS.loginFailed, error

  onLoginFulfilled = (response) ->
    if !!response.data.id
      authService.loginConfirmed response.data
    else
      onLoginRejected response

  @isAuthenticated = () ->
    !!SessionService.get().id
  
  @isAuthorized = (authorizedRoles) ->
    authorizedRoles = [] unless authorizedRoles
    authorizedRoles = [authorizedRoles] unless angular.isArray authorizedRoles
    isAuthenticated = @isAuthenticated()
    return isAuthenticated unless isAuthenticated

    userRoles = SessionService.get().authorities.map (role) -> role.name
    userRoles = [].concat.apply userRoles
    isAuthorized = true

    authorizedRoles.forEach (authorizedRole) ->
      isAuthorized = isAuthenticated &&
        (authorizedRole == USER_ROLES.all ||
        userRoles.indexOf(authorizedRole) != -1)
    
    isAuthorized

  @login = (credentials, check) ->
    credentials = credentials || {}

    # Create Base64 encrypted header from credentials
    headers = authorization: "Basic " +
      btoa("#{credentials.username}:#{credentials.password}")
    
    # Send our login request to REST service
    $http
      .get("#{BASE_URL}/authenticate",
        { headers : headers, ignoreAuthModule: true })
      .then onLoginFulfilled, onLoginRejected
  
  @logout = ->
    $http
      .post("#{BASE_URL}/logout", {})
      .finally -> authService.loginCancelled()

  @