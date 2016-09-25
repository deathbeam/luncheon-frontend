# Disable disabled things
$ -> $('body').on 'click', 'a.disabled', (event) -> event.preventDefault()

# Transform date array to date
Array::toDate = -> new Date @[0], @[1] - 1, @[2], 0, 0, 0, 0

# Nice string representation of date
Date::yyyymmdd = -> @toISOString().substring 0, 10

# Construct ID from date
Date::toId = ->
  mm = @getMonth() + 1 # getMonth() is zero-based
  dd = @getDate()
  
  [
    @getFullYear(),
    mm < 10 and "0#{mm}" or mm,
    dd < 10 and "0#{dd}" or dd
  ].join('')

# Create main Angular module
luncheon = window.luncheon = angular.module "luncheon", [
  "ngRoute",
  "ngCookies",
  "ngLoadingSpinner",
  "ui.bootstrap",
  "http-auth-interceptor",
  "pascalprecht.translate"
]

# Base URL for rest calls
luncheon.constant 'BASE_URL', 'http://localhost:3000'

# Base on login/logout events
luncheon.constant 'REDIRECTS',
  home: '/user'
  login: '/login'
  errNotFound: '/error/404'
  errForbidden: '/error/403'
  errOther: '/error/500'

# Authorization events
luncheon.constant 'AUTH_EVENTS',
  loginConfirmed: 'event:auth-loginConfirmed'
  loginFailed: 'event:auth-loginFailed'
  loginCancelled: 'event:auth-loginCancelled'
  loginRequired: 'event:auth-loginRequired'
  forbidden: 'event:auth-forbidden'

# User roles
luncheon.constant 'USER_ROLES',
  all: '*'
  admin: 'admin'
  user: 'user'