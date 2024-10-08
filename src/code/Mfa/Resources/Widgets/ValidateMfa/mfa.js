(function($, global)
{
    if (typeof $.fourroads === 'undefined')
        $.fourroads = {};

    if (typeof $.fourroads.widgets === 'undefined')
        $.fourroads.widgets = {};

    var attachHandlers = function (context) {
            context.selectors.submit.on('click', function(e) {
                e.preventDefault();
                save(context, context.selectors.validateInput.val());
                return false;
            });
            
            // enter key on code entry
			context.selectors.validateInput.bind('keypress', function(e){
				// if enter was pressed, trigger a click on the submit button
				if (e.keyCode === 13) {
					e.preventDefault();
					context.selectors.submit.trigger('click');
				}
			});
        },
        scrapeElements = function (context) {
            $.each([context.selectors], function(i, set) {
                $.each(set, function(key, value) {
                    set[key] = $(value);
                });
            });
        },
        save = function(context , code) {
            var data = {
                validationCode: code,
                persist: context.selectors.persistPeriod.is(':checked')
            };

            context.selectors.validateInput.closest('.field-item').find('.field-item-validation').hide();

            return $.telligent.evolution.post({
                url: context.urls.validate,
                data: data,
                dataType: 'json',
                success: function(response) {
                    if (response.result === "true") {
                        window.location = context.urls.returnUrl;
                    } else {
                        //Show error message
                        context.selectors.validateInput.closest('.field-item').find('.field-item-validation').show();
                    }

                }
            });
        };

    $.fourroads.widgets.validateMfa = {
        register: function(context) {
            scrapeElements(context);
            attachHandlers(context);
        }
    };
})(jQuery, window);
