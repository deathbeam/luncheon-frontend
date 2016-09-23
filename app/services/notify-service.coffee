# This service creates various Bootstrap notification to messages area
luncheon.service "NotifyService", ->
  self = @
  self.counter = 0

  notify = (text, type) ->
    self.counter++
    
    $("#messages").append """
      <div id="alert-#{self.counter}"
          class="alert alert-#{type} alert-dismissible"
          role="alert"
          style="display: none">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        #{text}
      </div>
    """

    $('#alert-' + self.counter).fadeIn("slow").delay(5000).fadeOut "slow"

  info: (m) -> notify m, "info"
  warning: (m) -> notify m, "warning"
  danger: (m) -> notify m, "danger"
  success: (m) -> notify m, "success"