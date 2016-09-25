# Manages logged in user session
luncheon.service "SessionService", ($cookies) ->
  @create = (data) ->
    $cookies.putObject "luncheon", data

  @invalidate = ->
    $cookies.remove "luncheon"
  
  @get = -> $cookies.getObject("luncheon") || {}

  @