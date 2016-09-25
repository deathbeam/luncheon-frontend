luncheon.controller "LoginController", ($scope, AuthService) ->
  $scope.login = -> AuthService.login $scope.credentials