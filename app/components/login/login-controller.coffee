luncheon.controller "LoginController", ($rootScope, $scope, AuthService, NotifyService, Config) ->
  $scope.credentials = AuthService.credentials

  $scope.login = ->
    onSuccess = -> 
      NotifyService.success "Boli ste úspešne prihlásení."
      $rootScope.$broadcast "loginSuccessful"

    onFailure = (error) -> 
      NotifyService.danger "Prihlásenie sa nepodarilo (chyba #{error.status})."
      $rootScope.$broadcast "loginSuccessful" if Config.mockRest
    
    AuthService.login @credentials, onSuccess, onFailure
  
  AuthService.login()