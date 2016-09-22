luncheon
  .config ($routeProvider, $httpProvider, Config) ->
    $routeProvider
      .when '/',
        redirectTo: '/login'
        access:
          loginRequired: false
          authorizedRoles: [ Config.roles.all ]
      .when '/error/:code',
        title: 'Error'
        templateUrl: "app/components/error/error-view.html",
        controller: "ErrorController"
      .when '/login',
        title: 'Login'
        templateUrl: 'app/components/login/login-view.html'
        controller: 'LoginController'
        access:
          loginRequired: false
          authorizedRoles: [ Config.roles.all ]
      .when '/user',
        title: 'User'
        templateUrl: 'app/components/user/user-view.html'
        controller: 'UserController'
        access:
          loginRequired: true
          authorizedRoles: [ Config.roles.all ]
      .otherwise
        redirectTo: '/error/404'
        access:
          loginRequired: false
          authorizedRoles: [ Config.roles.all ]