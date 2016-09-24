luncheon.service "AuthService", ($rootScope, $http, authService, SessionService, CONFIG, USER_ROLES, AUTH_EVENTS) ->
  # Mock user
  mockUser = {
    id: 1,
    user: {
      id: 1,
      role: USER_ROLES.admin
    }
  }

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
    headers = authorization: "Basic " + btoa("#{credentials.username}:#{credentials.password}")

    onSuccess = (response) ->
      if !!response.data.id
        authService.loginConfirmed response.data
    
    onFailure = (error) ->
      if CONFIG.mockRest && credentials.username == CONFIG.mockUsername && credentials.password == CONFIG.mockPassword
        authService.loginConfirmed mockUser
      else
        $rootScope.$broadcast AUTH_EVENTS.loginFailed, error
    
    # Send our login request to REST service
    $http.get('user', headers : headers, config: ignoreAuthModule: true).then onSuccess, onFailure
  
  @logout = ->
    $http.post('logout', {}).finally -> authService.loginCancelled()

  @