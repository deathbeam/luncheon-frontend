# Manages logged in user session
luncheon.service "SessionService", ->
  @create = (sessionId, userId, userRole) ->
    @id = sessionId
    @userId = userId
    @userRole = userRole

  @invalidate = ->
    @id = null
    @userId = null
    @userRole = null

  @ 