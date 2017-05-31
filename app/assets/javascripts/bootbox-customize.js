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
            label: '<i class="fa fa-times"></i>'
        },
        confirm: {
            label: '<i class="fa fa-check"></i>'
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
      type = message.type || "input";

    if (!message) { return true; }

    if ($.rails.fire(element, 'prompt')) {
      switch(type) {
        case "input":
          input_prompt();
          break;
        case "select":
          select_prompt(parseParams(value));
          break;
        case "choose_owner":
          choose_owner_prompt(parseParams(value));
          break;
        default:
          input_prompt();
          break;
      }
    }

    function input_prompt() {
      bootbox.prompt({
        onEscape: true,
        title: title,
        value: value,
        buttons: {
          cancel: {
            label: '<i class="fa fa-times"></i>'
          },
          confirm: {
            label: '<i class="fa fa-check"></i>'
          }
        },
        callback: function (result) {
          if(result) {
            finalResult = {};
            finalResult[name] = result;

            callback = $.rails.fire(element, 'prompt:complete', [finalResult]);
            if(callback) {
              var oldPromptGetter = $.rails.promptGetter;
              $.rails.promptGetter = function() { return true; };
              element.trigger('click.rails');
              $.rails.promptGetter = oldPromptGetter;
            }
          }
        }
      });
    }

    function choose_owner_prompt() {
      var html = $("#owner_chooser").html();
      var dialog = bootbox.dialog({
        title: title,
        message: html,
        callback: function (result) {
          if(result) {
            callback = $.rails.fire(element, 'prompt:complete', [result]);
            if(callback) {
              var oldPromptGetter = $.rails.promptGetter;
              $.rails.promptGetter = function() { return true; };
              element.trigger('click.rails');
              $.rails.promptGetter = oldPromptGetter;
            }
          }
        }
      });
    }

    function select_prompt(kv) {
      bootbox.prompt({
        title: title,
        inputType: "select",
        inputOptions: kv,
        callback: function (result) {
          if(result) {
            finalResult = {};
            finalResult[name] = result;

            callback = $.rails.fire(element, 'prompt:complete', [finalResult]);
            if(callback) {
              var oldPromptGetter = $.rails.promptGetter;
              $.rails.promptGetter = function() { return true; };
              element.trigger('click.rails');
              $.rails.promptGetter = oldPromptGetter;
            }
          }
        }
      });
    }

    function parseParams(str) {
      return str.split('&').reduce(function (params, param) {
        var paramSplit = param.split('=').map(function (value) {
          return decodeURIComponent(value.replace('+', ' '));
        });
        params.push({text: [paramSplit[0]], value: paramSplit[1]});
        return params;
      }, []);
    }

    return false;
  }
});

