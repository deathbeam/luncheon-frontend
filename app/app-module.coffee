# This function is ran after window is fully loaded
$ ->
  # Load Bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip placement: "bottom"

# Get current date in correct format
Date::yyyymmdd = () ->
  @toISOString().substring 0, 10

# Simple JQuery Boostrap alerts plugin
alertCounter = 0
$.fn.extend
  alert: (options) ->
    settings =
      text: ""
      type: "info"
      delay: 5000
      fadeIn: "slow"
      fadeOut: "slow"
    
    settings = $.extend settings, options
    
    @each () ->
      alertCounter++

      $(this).append """
        <div id="alert-#{alertCounter}"
            class="alert alert-#{settings.type} alert-dismissible"
            role="alert"
            style="display: none">
          <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          #{settings.text}
        </div>
      """

      $('#alert-' + alertCounter).fadeIn(settings.fadeIn).delay(settings.delay).fadeOut settings.fadeOut

# Create main Angular module
luncheon = angular.module "luncheon", [ "ngRoute", "ngLoadingSpinner" ]

# Set page title variable based on current route
luncheon.run ($rootScope) ->
  $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
    $rootScope.title = current.$$route.title