luncheon.factory "AuthService", ($rootScope, $http) ->
  authenticate: (credentials, success, failure) ->
    headers = if credentials
      authorization : "Basic " + btoa("#{credentials.username}:#{credentials.password}")
    else {}

    $http.get('user', headers : headers).then (
      (response) ->
        $rootScope.authenticated = !!response.data.name
        success && success(response)
        
      ), (
      (error) ->
        $rootScope.authenticated = false
        failure && failure(error)
      )