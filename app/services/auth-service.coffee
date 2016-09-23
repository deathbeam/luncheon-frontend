luncheon.service "AuthService", ($rootScope, $http, SessionService, CONFIG, USER_ROLES) ->
  isAuthenticated = () -> 
    !!SessionService.userId
  
  isAuthorized = (authorizedRoles) ->
    authorizedRoles = [authorizedRoles] unless angular.isArray authorizedRoles
    isAuthenticated() && (
      authorizedRoles.indexOf(USER_ROLES.all) != -1 ||
      authorizedRoles.indexOf(SessionService.userRole) != -1)
  
  login = (credentials, success, failure) ->
    credentials = credentials || {}

    # Create Base64 encrypted header from credentials
    headers = authorization: "Basic " + btoa("#{credentials.username}:#{credentials.password}")

    onSuccess = (response) ->
      if !!response.data.id
        SessionService.create response.data.id, response.data.user.id, response.data.user.role
        success && success(response)
    
    onFailure = (error) ->
      if CONFIG.mockRest && credentials.username == CONFIG.mockUsername && credentials.password == CONFIG.mockPassword
        SessionService.create 1, 1, USER_ROLES.admin
        success && success(error)
      else
        SessionService.invalidate()
        failure && failure(error)
    
    # Send our login request to REST service
    $http.get('user', headers : headers).then onSuccess, onFailure
  
  logout = ->
    $http.post('logout', {}).finally ->
      SessionService.invalidate()
      $rootScope.$broadcast AUTH_EVENTS.logoutSuccess

  login: login
  logout: logout
  isAuthenticated: isAuthenticated
  isAuthorized: isAuthorized