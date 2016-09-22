luncheon.service "SessionService", ->
  @create = (data) ->
    @id = data.id
    @login = data.login
    @userRoles = []

    angular.forEach data.authorities, ((value, key) ->
      @push(value.name)
    ), @userRoles

  @invalidate = ->
    @id = null
    @login = null
    @userRoles = null

  @