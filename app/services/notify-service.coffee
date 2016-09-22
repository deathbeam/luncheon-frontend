counter = 0
luncheon.factory "NotifyService", ->
  notify = (text, type) ->
    counter++
    
    $("#messages").append """
      <div id="alert-#{counter}"
          class="alert alert-#{type} alert-dismissible"
          role="alert"
          style="display: none">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        #{text}
      </div>
    """

    $('#alert-' + counter).fadeIn("slow").delay(5000).fadeOut "slow"

  info: (m) -> notify m, "info"
  warning: (m) -> notify m, "warning"
  danger: (m) -> notify m, "danger"
  success: (m) -> notify m, "success"