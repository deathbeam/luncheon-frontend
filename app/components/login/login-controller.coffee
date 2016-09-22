luncheon.controller "LoginController", ($rootScope, $scope, $location, AuthService, NotifyService, Config) ->
  $scope.credentials = username: "", password: ""

  $scope.login = ->
    onSuccess = -> NotifyService.success "Boli ste úspešne prihlásení."
    onFailure = (error) -> NotifyService.danger "Prihlásenie sa nepodarilo (chyba #{error.status})."
    AuthService.login $scope.credentials, onSuccess, onFailure