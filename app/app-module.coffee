# This function is ran after window is fully loaded
$ ->
  # Load Bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip placement: "bottom"

# Create main Angular module
luncheon = window.luncheon = 
  angular.module "luncheon", [
    "ngRoute",
    "restangular",
    "ngLoadingSpinner"
    ]

# Set page title variable based on current route
luncheon.run ($rootScope) ->
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    $rootScope.title = current.$$route.title