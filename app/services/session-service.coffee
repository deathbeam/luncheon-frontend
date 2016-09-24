# Manages logged in user session
luncheon.service "SessionService", ->
  @create = (data) ->
    @id = data.id
    @pid = data.pid
    @barCode = data.barCode
    @firstName = data.firstName
    @lastName = data.lastName
    @userRole = data.relation
    @longName = data.longName

  @invalidate = ->
    @id = null
    @pid = null
    @barCode = null
    @firstName = null
    @lastName = null
    @userRole = null
    @longName = null

  @