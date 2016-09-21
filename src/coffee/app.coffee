# This function is ran after window is fully loaded
$ ->
  # Load Bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip placement: "bottom"

# Get current date in correct format
Date::yyyymmdd = () ->
  @toISOString().substring 0, 10

# Simple message logger
window.addMessageCounter = 0
window.addMessage = (message, level="info") ->
  addMessageCounter++
  $('#messages').append """
    <div id="message-#{addMessageCounter}"
         class="alert alert-#{level} alert-dismissible"
         role="alert"
         style="display: none">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      #{message}
    </div>
  """

  $('#message-' + addMessageCounter).fadeIn('slow').delay(5000).fadeOut 'slow'

# Create main Angular module
angular.module "luncheon", [ "ngLoadingSpinner" ]