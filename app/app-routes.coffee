luncheon
  .config ($routeProvider, $httpProvider) ->
    $routeProvider
      .when '/login',
        title: 'Login'
        templateUrl: 'app/components/login/login-view.html'
        controller: 'LoginController'
      .when '/user',
        title: 'User'
        templateUrl: 'app/components/user/user-view.html'
        controller: 'UserController'
      .otherwise
        redirectTo: '/login'
    
    $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'