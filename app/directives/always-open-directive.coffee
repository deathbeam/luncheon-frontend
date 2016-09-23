# This directive will check if user is logged in
luncheon.directive "alwaysOpen", () ->
  require: 'uiSelect'
  link: (scope, element, attrs, ctrl) ->
    ctrl.close = -> ctrl.refreshItems()
    ctrl.open = true
    ctrl.toggle()