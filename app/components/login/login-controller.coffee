luncheon.controller "LoginController", ($rootScope, $scope, AuthService, NotifyService) ->
  $scope.credentials = AuthService.credentials

  $scope.login = ->
    onSuccess = -> 
      NotifyService.success "Boli ste úspešne prihlásení."
      $rootScope.$broadcast "loginSuccessful"

    onFailure = (error) -> 
      NotifyService.danger "Prihlásenie sa nepodarilo (chyba #{error.status})."
      $rootScope.$broadcast "loginFailed"
    
    AuthService.login $scope.credentials, onSuccess, onFailure
  
  # Check if we are already logged in on login page load
  AuthService.checkLogin -> $rootScope.$broadcast "loginSuccessful"