luncheon.service "AuthService", ($rootScope, $http, SessionService, Config) ->
  login = (credentials, success, failure) ->
    # Use Session credentials if possible, and recheck if our session is still valid
    # If we do not have session, just try to log in with provided credentials
    credentials = SessionService.credentials || {} unless credentials

    # Create Base64 encrypted header from credentials
    headers = authorization: "Basic " + btoa("#{credentials.username}:#{credentials.password}")

    onSuccess = (response) ->
      if !!response.data.id
        SessionService.create credentials, id
        success && success(response)
    
    onFailure = (error) ->
      if Config.mockRest && credentials.username == Config.mockUsername && credentials.password == Config.mockPassword
        SessionService.create credentials, 0
        success && success(error)
      else
        SessionService.invalidate()
        failure && failure(error)
    
    # Send our login request to REST service
    $http.get('user', headers : headers).then onSuccess, onFailure
  
  logout = ->
    $http.post('logout', {}).finally ->
      SessionService.invalidate()
      $rootScope.$broadcast "logout"
  
  checkLogin = (success, failure) ->
    login null, success, failure

  login: login
  logout: logout
  checkLogin: checkLogin