$(document).ready(function() {
  $.rails.allowAction = function(element) {
  var message = element.data('confirm'),
    answer = false, callback;
  if (!message) { return true; }

  if ($.rails.fire(element, 'confirm')) {
    myCustomConfirmBox(message, function() {
      callback = $.rails.fire(element,
        'confirm:complete', [answer]);
        if(callback) {
          var oldAllowAction = $.rails.allowAction;
          $.rails.allowAction = function() { return true; };
          element.trigger('click');
          $.rails.allowAction = oldAllowAction;
        }
      });
    }
    return false;
  }

  function myCustomConfirmBox(message, callback) {
    bootbox.confirm({
      title: message,
      message: message,
      buttons: {
        cancel: {
            label: '<i class="fa fa-times"></i> Cancel'
        },
        confirm: {
            label: '<i class="fa fa-check"></i> Confirm'
        }
      },
      callback: function(confirmed) {
        if(confirmed){
          callback();
        }
      }
    });
  }

  $.rails.prompt = function(element) {
    var message = element.data('prompt'),
      title = message.title || "input value for key",
      name = message.name || "name",
      value = message.value || "value",
      type = message.typpe || "input";

    if (!message) { return true; }

    if ($.rails.fire(element, 'prompt')) {
      bootbox.prompt(title, function (result) {
        if(result) {
          finalResult = {};
          finalResult[name] = result;

          callback = $.rails.fire(element,
            'prompt:complete', [finalResult]);
          if(callback) {
            var oldPromptGetter = $.rails.promptGetter;
            $.rails.promptGetter = function() { return true; };
            element.trigger('click.rails');
            $.rails.promptGetter = oldPromptGetter;
          }
        }
      });
    }
    return false;
  }
});
