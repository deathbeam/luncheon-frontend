luncheon.service "AuthSharedService", ($rootScope, $http, authService, SessionService) ->
  login: (username, password, success, failure) ->
    config = 
      ignoreAuthModule: 'ignoreAuthModule'
      params:
        username: username
        password: password
    
    $http.post('authenticate', '', config)
      .success((data, status, headers, config) ->
        authService.loginConfirmed(data)
        success && success(data)
      ).error((data, status, headers, config) ->
        SessionService.invalidate()
        failure && failure(status)
      )
  
  isAuthorized: (authorizedRoles) ->
    unless angular.isArray(authorizedRoles)
      return true if authorizedRoles == '*'
      authorizedRoles = [authorizedRoles]

    isAuthorized = false;
    angular.forEach authorizedRoles, (authorizedRole) ->
        authorized = !!SessionService.login && SessionService.userRoles.indexOf(authorizedRole) != -1
        isAuthorized = authorized || authorizedRole == '*'
    
    isAuthorized