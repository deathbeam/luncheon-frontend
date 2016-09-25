luncheon.directive 'access', (AuthService) ->
  link: (scope, element, attrs) ->
    roles = attrs.access.split ','

    if roles.length > 0
      if AuthService.isAuthorized roles
        element.removeClass 'hidden'
      else
        element.addClass 'hidden'