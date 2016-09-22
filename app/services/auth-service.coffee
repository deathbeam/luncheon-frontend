luncheon.service "AuthService", ($rootScope, $http, SessionService, Config) ->
  login: (credentials, success, failure) ->
    credentials = SessionService.credentials || {} unless credentials
    headers = authorization: "Basic " + btoa("#{credentials.username}:#{credentials.password}")

    onSuccess = (response) ->
      SessionService.create credentials if response.data.name
      success && success(response)
    
    onFailure = (error) ->
      if Config.mockRest
        SessionService.create credentials
      else
        SessionService.invalidate()
        $rootScope.$broadcast "loginFailed"
      
      failure && failure(error)

    $http.get('user', headers : headers).then onSuccess, onFailure
  
  logout: ->
    $http.post('logout', {}).finally ->
      SessionService.invalidate()
      $rootScope.$broadcast "logout"