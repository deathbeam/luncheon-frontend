angular.module("luncheon")
  .config ($routeProvider) ->
    
    $routeProvider
      .when '/login',
        title: 'Login'
        templateUrl: 'app/components/login/login-view.html'
      .when '/user',
        title: 'User'
        templateUrl: 'app/components/user/user-view.html'
        controller: 'UserController'