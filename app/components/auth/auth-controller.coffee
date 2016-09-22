luncheon.controller "AuthController", ($scope, $location, NotifyService) ->
  $scope.login = ->
    $location.path('/user')
    NotifyService.success "Boli ste úspešne prihlásení."