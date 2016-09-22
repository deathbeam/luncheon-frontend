luncheon.controller "LoginController", ($scope, $location, AuthSharedService, NotifyService, Config) ->
  $scope.rememberMe = true
  $scope.login = ->
    AuthSharedService.login $scope.username, $scope.password, (
      (data) ->
        NotifyService.success "Boli ste úspešne prihlásení."
      ), (
      (status) ->
        NotifyService.danger "Prihlásenie sa nepodarilo (chyba #{status})."
        $location.path('/user') if Config.mockRest
      )
    