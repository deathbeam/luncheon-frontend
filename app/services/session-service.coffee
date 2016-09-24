# Manages logged in user session
luncheon.service "SessionService", ->
  @create = (data) ->
    @id = data.id
    @userId = data.user.id
    @userRole = data.user.role

  @invalidate = ->
    @id = null
    @userId = null
    @userRole = null

  @ 