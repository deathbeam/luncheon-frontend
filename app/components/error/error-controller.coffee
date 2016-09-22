luncheon.controller 'ErrorController', ($scope, $routeParams) ->
  $scope.code = $routeParams.code;

  switch $scope.code
    when "403" then $scope.message = "Ups! K tejto stránke nemáte prístup."
    when "404" then $scope.message = "Stránka sa nenašla."
    else
        $scope.code = 500
        $scope.message = "Ups! Neočakávaná chyba."