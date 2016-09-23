luncheon.controller "LoginController", ($rootScope, $scope, AuthService, NotifyService, AUTH_EVENTS) ->
  $scope.credentials = AuthService.credentials

  $scope.login = ->
    onSuccess = -> 
      NotifyService.success "Boli ste úspešne prihlásení."
      $rootScope.$broadcast AUTH_EVENTS.loginSuccess

    onFailure = (error) -> 
      NotifyService.danger "Prihlásenie sa nepodarilo (chyba #{error.status})."
      $rootScope.$broadcast AUTH_EVENTS.loginFailed
    
    AuthService.login $scope.credentials, onSuccess, onFailure