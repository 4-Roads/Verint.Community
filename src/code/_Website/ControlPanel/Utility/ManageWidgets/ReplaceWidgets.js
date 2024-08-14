/*
Manages the UI around selecting a target widget and theme.
events raised:
	targetWidgetSelection
		data:
			string themeName
			string fragmentId
*/
(function ($) {
	$.fn.widgetSelector = function (options) {
		var settings = $.extend({}, $.fn.widgetSelector.defaults, options || {}),
			selector = this;

		settings.widgetList = $(settings.widgetList);
		settings.replacementWidgetList = $(settings.replacementWidgetList);
		settings.themeList = $(settings.themeList);

		var raiseChange = function () {
			selector.trigger(settings.eventName, {
				widget: settings.widgetList.val(),
				theme: settings.themeList.val()
			});
		};

		settings.widgetList.on('change', raiseChange);
		settings.themeList.on('glowChange', raiseChange);

		settings.themeList.on('glowChange', function () {
			settings.widgetList.find('option[value!=""]').remove();
			settings.replacementWidgetList.find('option[value!=""]').remove();
			$.pageMethod(settings.listWidgetsMethod, {
				data: {
					themeName: settings.themeList.val()
				},
				success: function (results) {
					$.each(results, function (i, widget) {
						settings.widgetList.append('<option value="' + widget.Id + '">' + widget.Name + '</option>');
						settings.replacementWidgetList.append('<option value="' + widget.Id + '">' + widget.Name + '</option>');
					});
				},
				error: function (msg) { alert(msg); }
			});
		});

		return selector;
	};
	$.extend($.fn.widgetSelector, {
		defaults: {
			eventName: 'targetWidgetSelection',
			widgetList: '.TargetWidgetList select',
			replacementWidgetList: '.ReplacmentSelection select',
			listWidgetsMethod: 'ListContentFragments',
			themeList: '.TargetThemeList select'
		},
		// globally-available shim to ensure a true 'change' event is raised on the TargetThemeList's internal state
		// called from the Glow.DropDownList's onchange, which does not respect true change events
		raiseThemeChange: function () {
			$($.fn.widgetSelector.defaults.themeList).trigger('glowChange');
		}
	});
} (jQuery));


/* manages the UI around selecting/paging containers for fragment replacements
events raised:
	events:
		targetContainerSelection
		data:
			string[] containerIds
*/
(function($){
	var liveBound = false;
	var getContainers = function(settings, pageIndex, callback) {
		$.pageMethod(settings.listMethod, {
			data: {
				themeName: settings.themeName,
				contentFragmentId: settings.contentFragmentId,
				pageIndex: pageIndex,
				pageSize: settings.pageSize
			},
			success: function (results) {
				callback(results);
			},
			error: function (msg) { alert(msg); }
		});
	};
	$.fn.containerSelector = function(options) {
		var settings = $.extend({}, $.fn.containerSelector.defaults, options || {}),
			selector = this,
			containers = null,
			options = selector.find(settings.options),
			pager = selector.find(settings.pager),
			selectAll = selector.find(settings.selectAll),
			noContainers = selector.find(settings.noContainers);

		var raiseChange = function() {
			var values = $.map(options.find('input:checked'),function(item) {
				return $(item).val();
			});
			selector.trigger(settings.eventName, [values]);
		};

		var loadPageOfContainers = function(page) {
			getContainers(settings, page, function (results) {
				containers = results.Containers;
				if(results.TotalCount === 0) {
					selectAll.hide();
					noContainers.show();
				} else if(results.TotalCount === 1 || results.PageSize === 1) {
					selectAll.hide();
					noContainers.hide();
				} else {
					selectAll.show();
					noContainers.hide();
				}
				// show results
				options.empty();
				$.each(containers, function(i, container) {
					options.append($.template(settings.template, container));
				});
				// show pager
				pager.empty();
				if(results.TotalCount > results.PageSize) {
					var pageCount = Math.ceil(results.TotalCount/results.PageSize), i;
					for(i = 0; i < pageCount; i++) {
						var link = $('<li><a href="#" data-page="'+i+'">'+(i+1)+'</a></li>');
						if(i === results.PageIndex) {
							link.addClass('current');
						}
						pager.append(link);
					}
				}
			});
		};
		loadPageOfContainers(0);

		selector
            .off('click', settings.pager + ' a')
            .on('click', settings.pager + ' a', function(e,data){
				e.preventDefault();
				var pageIndex = parseInt($(this).attr('data-page'),10);
				loadPageOfContainers(pageIndex);
				selectAll.find(settings.inputs).prop('checked', false);
				options.empty();
				raiseChange();
			});

		if(!liveBound) {
			liveBound = true;
            options.on('change', settings.inputs, function(e,data){
				raiseChange();
			});
            selector.on('change', settings.allSelector, function(e,data){
				if($(this).is(':checked')) {
					selector.find(settings.inputs).prop('checked',true);
				} else {
					selector.find(settings.inputs).prop('checked', false);
				}
				raiseChange();
			});
		}

		return this;
	};
	$.extend($.fn.containerSelector, {
		defaults: {
			eventName: 'targetContainerSelection',
			listMethod: 'ListContainers',
			template: 'ContainersTemplate',
			selectAll: '.SelectAll',
			noContainers: '.NoContainers',
			inputs: 'input[type=checkbox]',
			allSelector: 'input[value=all]',
			options: '.Containers',
			pager: '.Pager',
			pageSize: 40
		}
	});
}(jQuery));


/* manages the UI around selecting a replacement widget
	events raised:
		replacementWidgetSelection
		data:
			widget
*/
(function($){
	$.fn.replacementWidgetSelector = function(options) {
		var settings = $.extend({}, $.fn.replacementWidgetSelector.defaults, options || {}),
			selector = this;

		settings.widgetList = selector.find(settings.widgetList);

		var raiseChange = function(){
			selector.trigger(settings.eventName, {
				widget: settings.widgetList.val()
			});
		};

		settings.widgetList.on('change',raiseChange);

		return selector;
	};
	$.extend($.fn.replacementWidgetSelector, {
		defaults: {
			eventName: 'replacementWidgetSelection',
			widgetList: 'select'
		}
	});
}(jQuery));



/* manages the UI around configuring a replacement widget
	events raised:
		replacementConfigured
		data:
			replacementFragmentConfiguration
*/
(function($){
	var setupContext = function (parent, settings) {
			var context = {
				parent: $(parent),
				settings: settings
			};
			context.elements = $.extend({}, settings.selectors);
			$.each(context.elements, function (key, value) { context.elements[key] = parent.find(value); });
			return context;
		},
		bound = false;

	$.fn.replacementWidgetConfigurator = function(options) {
		var settings = $.extend({}, $.fn.replacementWidgetConfigurator.defaults, options || {});

		return this.each(function () {
			var self = $(this);
			var context = setupContext($(this), settings);
			var url = settings.configurationUrl.replace(/TYPEID/,encodeURIComponent(settings.replacementWidgetId));
			context.elements.configFrame.attr('src',url);
			if(!bound) {
				bound = true;
				$(document).on('configuredContentFragment', function(e,data){
					// trigger event to consumer with configuration data
					self.trigger(context.settings.eventName, {
						replacementFragmentConfiguration: data
					});
				});
			}
		});
	};
	$.extend($.fn.replacementWidgetConfigurator, {
		defaults: {
			eventName: 'replacementWidgetConfiguration',
			selectors: {
				configFrame: 'iframe',
				configurationUrl: ''
			}
		}
	});

}(jQuery));


/* orchestrates the replacement of widgets,
collecting events target selection, container selection, and replacement selection/configuration
and performing actual replacements via Ajax */
(function ($) {
	var nullOrEmpty = function(value) {
			return typeof value === 'undefined' || value === null || value === '';
		},
		setupContext = function (parent, settings) {
			var context = {
				parent: $(parent),
				settings: settings
			};
			context.elements = $.extend({}, settings.selectors);
			$.each(context.elements, function (key, value) { context.elements[key] = parent.find(value); });
			return context;
		},
		hide = function(sel) {
			$(sel).hide();
		},
		show = function(sel) {
			$(sel).show();
		},
		performReplacement = function(context, replacementData) {
			if(confirm(context.settings.replacementConfirmationMessage)){
				$.pageMethod('Replace', {
					data: replacementData,
					success: function (results) {
						alert(context.settings.replacementSuccessMessage);
						window.location.href = window.location.href;
					},
					error: function (msg) {
						alert(msg);
					}
				});
			}
		};

	$.fn.widgetReplacer = function (options) {
		var settings = $.extend({}, $.fn.widgetReplacer.defaults, options || {});
		return this.each(function () {
			var context = setupContext($(this), settings);

			context.elements.widgetSelector.widgetSelector();
			context.elements.containerSelector.hide();
			context.elements.replacementSelector.replacementWidgetSelector().hide();
			context.elements.replacementConfiguration.hide();
			//context.elements.replacementConfiguration.replacementWidgetConfigurator().hide();

			// holds collected data from ui components before replacing
			var replacementData = {
				themeName: '',
				targetContentFragmentId: '',
				replacementContentFragmentId: '',
				replacementContentFragmentConfiguration: '',
				selectedContainerIds: []
			};

			$(this).on({
				targetWidgetSelection: function(e, data) {
					// show or hide container and replacement panels based on whether
					// there are target theme and widget selections made
					if(data !== null && !nullOrEmpty(data.widget) && !nullOrEmpty(data.theme)) {
						replacementData.themeName = data.theme;
						replacementData.targetContentFragmentId = data.widget;
						context.elements.containerSelector.find('input:checked').prop('checked', false);
						context.elements.containerSelector.containerSelector({
							themeName: data.theme,
							contentFragmentId: data.widget
						});
						show(context.elements.containerSelector);
						hide(context.elements.replacementSelector);
						hide(context.elements.replacementConfiguration);
					} else {
						replacementData.themeName = null;
						replacementData.targetContentFragmentId = null;
						hide(context.elements.containerSelector);
						hide(context.elements.replacementSelector);
						hide(context.elements.replacementConfiguration);
					}
				},
				targetContainerSelection: function(e, data) {
					// show or hide replacement based on whether there are containers selected
					if(data !==	 null && data.length > 0) {
						replacementData.selectedContainerIds = data;
						context.elements.replacementSelector.find('select').val("");
						show(context.elements.replacementSelector);
					} else {
						replacementData.selectedContainerIds = [];
						hide(context.elements.replacementSelector);
						hide(context.elements.replacementConfiguration);
					}
				},
				replacementWidgetSelection: function(e, data) {
					if(data !== null && !nullOrEmpty(data.widget)) {
						replacementData.replacementContentFragmentId = data.widget;
						show(context.elements.replacementConfiguration);
						context.elements.replacementConfiguration.replacementWidgetConfigurator({
							replacementWidgetId: data.widget,
							configurationUrl: context.settings.configurationUrl
						});
					} else {
						replacementData.replacementContentFragmentId = null;
						hide(context.elements.replacementConfiguration);
					}
				},
				replacementWidgetConfiguration: function(e, data) {
					if(data !== null)
					{
						replacementData.replacementContentFragmentConfiguration = data.replacementFragmentConfiguration || "";
						performReplacement(context, replacementData);
					} else {
						replacementData.replacementContentFragmentConfiguration = null;
						// don't perform replacement
					}
				}
			});
		});
	};
	$.extend($.fn.widgetReplacer, {
		defaults: {
			replacementConfirmationMessage: 'Are you sure you want to replace these widgets?',
			replacementSuccessMessage: 'Widgets were successfully replaced',
			configurationUrl: '',
			duration: 200,
			selectors: {
				widgetSelector: '.WidgetSelection',
				containerSelector: '.ContainerSelection',
				replacementSelector: '.ReplacmentSelection',
				replacementConfiguration: '.ReplacementConfiguration'
			}
		}
	});
}(jQuery));
