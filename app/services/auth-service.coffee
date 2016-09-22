luncheon.service "AuthService", ($rootScope, $http) ->
  login: (credentials, success, failure) ->
    headers = {}
    headers = authorization: "Basic " + btoa("#{credentials.username}:#{credentials.password}") if credentials

    onSuccess = (response) ->
      $rootScope.authenticated = !!response.data.name
      $rootScope.$broadcast "loginSuccessful"
      success && success(response)
    
    onFailure = (error) ->
      $rootScope.authenticated = false
      $rootScope.$broadcast "loginFailed"
      failure && failure(error)

    $http.get('user', headers : headers).then onSuccess, onFailure
  
  logout: ->
    $http.post('logout', {}).finally ->
      $rootScope.authenticated = false
      $rootScope.$broadcast "logout"