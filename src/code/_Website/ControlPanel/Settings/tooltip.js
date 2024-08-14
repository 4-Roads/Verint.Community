(function ($, global) {
	// private methods    
	var _init = function (options) {
		var settings = $.extend({}, $.fn.cpToolTip.defaults, options || {}, { popUpPanel: null });

		return this.each(function () {
			$(this)
				.on('mouseover', function () {
					_showTooltip($(this), settings);
				})
				.on('mouseleave', function () {
					_hideTooltip($(this), settings);
				});
		});
	},
	_showTooltip = function (el, settings) {
		if (!settings.popUpPanel) {
			settings.popUpPanel = $('<div></div>');
			settings.popUpPanel.glowPopUpPanel({
				cssClass: settings.cssClass,
				position: settings.position,
				zIndex: settings.zIndex,
				hideOnDocumentClick: true
			});
		}

		settings.popUpPanel.glowPopUpPanel('html', settings.tooltip);
		settings.popUpPanel.glowPopUpPanel('show', el);
	},
	_hideTooltip = function (el, settings) {
		if (settings.popUpPanel) {
			settings.popUpPanel.glowPopUpPanel('hide');
		}
	};

	$.fn.cpToolTip = function (method) {
		if (method in api) {
			return api[method].apply(this, Array.prototype.slice.call(arguments, 1));
		} else if (typeof method === 'object' || !method) {
			return _init.apply(this, arguments);
		} else {
			$.error('Method ' + method + ' does not exist on jQuery.fn.evolutionToolTip');
		}
	};
	$.extend($.fn.cpToolTip, {
		defaults: {
			tooltip: '',
			position: 'up left',
			cssClass: '',
			zIndex: 100
		}
	});
})(jQuery, window);
