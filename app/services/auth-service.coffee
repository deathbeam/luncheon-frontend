luncheon.service "AuthService", ( $rootScope
, $http
, authService
, SessionService
, USER_ROLES
, AUTH_EVENTS
, BASE_URL
) ->
  @isAuthenticated = () ->
    !!SessionService.userId
  
  @isAuthorized = (authorizedRoles) ->
    authorizedRoles = [authorizedRoles] unless angular.isArray authorizedRoles
    @isAuthenticated() && (
      authorizedRoles.indexOf(USER_ROLES.all) != -1 ||
      authorizedRoles.indexOf(SessionService.userRole) != -1)
  
  @login = (credentials) ->
    credentials = credentials || {}

    # Create Base64 encrypted header from credentials
    headers = authorization: "Basic " +
      btoa("#{credentials.username}:#{credentials.password}")

    onSuccess = (response) ->
      authService.loginConfirmed response.data if response.data.id
    
    onFailure = (error) ->
      $rootScope.$broadcast AUTH_EVENTS.loginFailed, error
    
    # Send our login request to REST service
    $http
      .get("#{BASE_URL}/user",
        { headers : headers },
        { config: ignoreAuthModule: true })
      .then onSuccess, onFailure
  
  @logout = ->
    $http
      .post("#{BASE_URL}/logout", {})
      .finally -> authService.loginCancelled()

  @