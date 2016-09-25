# Manages logged in user session
luncheon.service "SessionService", ($cookies) ->
  @create = (data) ->
    $cookies.put "luncheon_id", data.id
    $cookies.put "luncheon_pid", data.pid
    $cookies.put "luncheon_barCode", data.barCode
    $cookies.put "luncheon_firstName", data.firstName
    $cookies.put "luncheon_lastName", data.lastName
    $cookies.put "luncheon_userRole", data.relation
    $cookies.put "luncheon_longName", data.longName

  @invalidate = ->
    $cookies.remove "luncheon_id"
    $cookies.remove "luncheon_pid"
    $cookies.remove "luncheon_barCode"
    $cookies.remove "luncheon_firstName"
    $cookies.remove "luncheon_lastName"
    $cookies.remove "luncheon_userRole"
    $cookies.remove "luncheon_longName"
  
  @getId = -> $cookies.get "luncheon_id"
  @getPid = -> $cookies.get "luncheon_pid"
  @getBarCode = -> $cookies.get "luncheon_barCode"
  @getFirstName = -> $cookies.get "luncheon_firstName"
  @getLastName = -> $cookies.get "luncheon_lastName"
  @getUserRole = -> $cookies.get "luncheon_userRole"
  @getLongName = -> $cookies.get "luncheon_longName"

  @