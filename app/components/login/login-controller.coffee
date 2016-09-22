luncheon.controller "LoginController", ($rootScope, $scope, $location, AuthService, NotifyService) ->
  $scope.credentials = username: "", password: ""

  $scope.login = ->
    AuthService.authenticate $scope.credentials, (
      (response) ->
        NotifyService.success "Boli ste úspešne prihlásení."
        $location.path('/user')
      ), (
      (error) ->
        NotifyService.danger "Prihlásenie sa nepodarilo (chyba #{error.status})."
        if test then $location.path('/user') else $location.path('/')
      )
    