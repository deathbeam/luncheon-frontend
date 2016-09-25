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
    !!SessionService.getId()
  
  @isAuthorized = (authorizedRoles) ->
    authorizedRoles = [authorizedRoles] unless angular.isArray authorizedRoles
    @isAuthenticated() && (
      authorizedRoles.indexOf(USER_ROLES.all) != -1 ||
      authorizedRoles.indexOf(SessionService.getUserRole()) != -1)
  
  @getAccount = () ->
    $http.get("#{BASE_URL}/security/account")
      .then onLoginFulfilled, onLoginRejected

  @login = (credentials, check) ->
    credentials = credentials || {}

    # Create Base64 encrypted header from credentials
    headers = authorization: "Basic " +
      btoa("#{credentials.username}:#{credentials.password}")
    
    # Send our login request to REST service
    $http
      .get("#{BASE_URL}/authenticate",
        { headers : headers, config: ignoreAuthModule: true })
      .then onLoginFulfilled, onLoginRejected
  
  @logout = ->
    $http
      .post("#{BASE_URL}/logout", {})
      .finally -> authService.loginCancelled()

  @