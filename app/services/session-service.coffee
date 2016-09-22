luncheon.service "SessionService", ->
  @create = (credentials) ->
    @credentials = credentials

  @invalidate = ->
    @credentials = null

  @ 