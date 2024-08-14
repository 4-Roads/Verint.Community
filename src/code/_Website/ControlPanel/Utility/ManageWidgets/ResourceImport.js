// Client-side behaviors for the widget importing modal, bundled up as a plugin

(function ($) {
    var innerUploadError,
        innerUploadComplete,
        innerUploadStarted;

    // expose stub modal callbacks globally for availability to the modal control
    $.extend(window, {
        uploadError: function () { innerUploadError(); },
        uploadComplete: function () { innerUploadComplete(); },
        uploadStarted: function () { innerUploadStarted(); }
    });

    var isUploaded = false,
		setupContext = function (parent, settings) {
		    var context = {
		        parent: $(parent),
		        settings: settings
		    };
		    context.elements = $.extend({}, settings.selectors);
		    $.each(context.elements, function (key, value) { context.elements[key] = parent.find(value); });
		    return context;
		},
        setupAction = function (context) {
            // expose callbacks for the Uploader to the global scope so they can be called by name

			// implement the behavior for when an upload error occurs
            innerUploadError = function () {
                isUploaded = false;
                context.parent.trigger('uploadError');
            };
			// implement behavior for when an upload is complete
            innerUploadComplete = function () {
                isUploaded = true;
                // once uploaded, ask for information about the import to verify its valid
                $.pageMethod('ValidateImport', {
                    data: { uploadContext: context.settings.uploadContext },
                    success: function (msg) {
                        context.parent.trigger('uploadComplete', msg);
                    },
					error: function(xhr) {
						context.parent.trigger('uploadError');
					}
                });
            };
			// implement behavior for when an upload has begun
            innerUploadStarted = function () {
                isUploaded = false;
                context.parent.trigger('uploadStarted');
            };

            context.elements.saveButton.on('click', function (e, data) {
                if (!isUploaded) {
                    return false;
                }
            });
        },
        setupUi = function (context) {
            context.parent
                .on('uploadStarted', function(e, data) {
					context.elements.uploadLink.hide();
					context.elements.uploadLinkPlaceHolder.attr('style', 'visible').show();
                })
                .on('uploadError', function(e, data) {
                    $('.field-item.file .field-item-validation').html(context.settings.errorMessage).show();
                })
                .on('uploadComplete', function(e, data) {
					$('.field-item.file .field-item-validation').empty();
					context.elements.uploadLink.show();
					context.elements.uploadLinkPlaceHolder.hide();
					context.elements.uploadLink.removeClass('disabled')
                });
        };

    $.fn.resourceImport = function (options) {
        var settings = $.extend({}, $.fn.resourceImport.defaults, options || {});
        return this.each(function () {
            var context = setupContext($(this), settings);
            setupUi(context);
            setupAction(context);
        });
    };
    $.extend($.fn.resourceImport, {
        defaults: {
            uploadContext: '',
            selectors: {
                saveButton: 'a[id$="Save"]',
				uploadLink: '.internal-link.upload-file',
				uploadLinkPlaceHolder: '.internal-link.upload-file.placeholder'
            },
            errorMessage: 'There was an error uploading the resource file.'
        }
    });

})(jQuery);
