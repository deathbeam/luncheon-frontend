luncheon.directive 'ngAccess', (AuthSharedService) ->
  link: (scope, element, attrs) ->
    roles = attrs.ngAccess.split(',')
    
    if roles.length > 0
      if AuthSharedService.isAuthorized(roles)
        element.removeClass('hidden')
      else
        element.addClass('hidden')