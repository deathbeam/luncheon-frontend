luncheon
  .config ($routeProvider, $httpProvider) ->
    $routeProvider
      .when '/login',
        title: 'Prihlásenie'
        templateUrl: 'app/components/login/login-view.html'
        controller: 'LoginController'
      .when '/user',
        title: 'Zoznam obedov'
        templateUrl: 'app/components/user/user-view.html'
        controller: 'UserController'
        loginRequired: true
      .otherwise
        redirectTo: '/login'
    
    ###
    The custom "X-Requested-With" is a conventional header sent by browser clients,
    and it used to be the default in Angular but they took it out in 1.3.0.
    Spring Security responds to it by not sending a "WWW-Authenticate" header in a
    401 response, and thus the browser will not pop up an authentication dialog
    (which is desirable in our app since we want to control the authentication).
    ###
    $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'