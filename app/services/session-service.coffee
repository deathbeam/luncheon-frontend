# Manages logged in user session
luncheon.service "SessionService", ->
  @create = (credentials, id) ->
    @credentials = credentials
    @authenticated = true
    @id = id

  @invalidate = ->
    @credentials = null
    @authenticated = false
    @id = null

  @ 