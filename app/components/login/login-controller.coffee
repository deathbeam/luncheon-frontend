luncheon.controller "LoginController", ($scope, AuthService, NotifyService) ->
  $scope.login = -> AuthService.login $scope.credentials