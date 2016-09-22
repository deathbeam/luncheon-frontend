angular.module("luncheon")
  .config ($routeProvider) ->
    $routeProvider
      .when '/login',
        title: 'Login'
        templateUrl: 'app/components/auth/login-view.html'
        controller: 'AuthController'
      .when '/user',
        title: 'User'
        templateUrl: 'app/components/user/user-view.html'
        controller: 'UserController'
      .otherwise
        redirectTo: '/login'