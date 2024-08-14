// Client-side behaviors for the widget-management list page, bundled up as a plugin

(function ($) {
	// expose a global callback for the modal to call when it closes
	var innerWidgetsImported = function () { };
	var innerResourcesImported = function () { };
	var innerWidgetsReverted = function () { };
	var innerGetWidgetSelection = function() { };
	$.extend(this, {
		widgetsImported: function (value) { return innerWidgetsImported(value); },
		resourcesImported: function (value) { return innerResourcesImported(value); },
		widgetsReverted: function (value) { return innerWidgetsReverted(); },
		getWidgetSelection: function () { return innerGetWidgetSelection(); }
	});
	var dataKey = '_widget_data',
		// gets a set of instance identifiers corresponding to current selection
		getSelection = function (context) {
			return context.elements.checkBoxes
				.filter(':visible')
				.filter(':checked')
				.map(function (i, element) { return $(element).closest('tr').attr('data-identifier'); })
				.toArray();
		},
		// serializes the current widget selection to a form field for post backing
		serializeSelection = function (context, identifier) {
			// if provided an identifier, just uses the identifier
			if (typeof identifier !== 'undefined' && identifier !== null && identifier.length > 0) {
				context.elements.selectedWidgetsInput.val(identifier);
				// otherwise, uses the currently checked widgets
			} else {
				context.elements.selectedWidgetsInput.val(getSelection(context).join(','));
			}
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
		getCachedWidgetData = function (context, row) {
			var data = row.data(dataKey);
			if (typeof data === 'undefined' || data === null) {
				data = getWidgetData(context, row);
				row.data(dataKey, data);
				context.identifiers[data.identifier] = row;
			}
			return data;
		},
		invalidateCachedWidgetData = function (context, row) {
			row.removeData(dataKey);
		},
		getWidgetData = function (context, row) {
			var identifier = row.attr('data-identifier'),
				name = row.find('strong.name a').html(),
				description = row.find('span.description').html(),
				rawThemes = row.attr('data-themes'),
				rawProviders = row.attr('data-providers');
			data = {
				name: name,
				description: description,
				nameAndDescription: (name + " " + description).toLowerCase(),
				identifier: identifier,
				provider: row.attr('data-provider'),
				versions: $.map(row.attr('data-versions').split(','), function (rawVersion) {
					var rawVersionParts = rawVersion.split('|', 2);
					return {
						type: rawVersionParts[0],
						theme: rawVersionParts.length === 2 ? rawVersionParts[1] : null
					};
				})
			};
			return data;
		},
		// verifies that all tokens can be found within a given value
		matchesTokens = function (value, tokens) {
			var isMatch = true;
			if (tokens.length >= 1) {
				for (var i in tokens) {
					if (value.indexOf(tokens[i]) < 0) {
						isMatch = isMatch && false;
						if (!isMatch) {
							break;
						}
					}
				}
			}
			return isMatch;
		},
		buildWidgetFilterQuery = function (context) {
			var rawTokenText = context.elements.filterInput.val().replace(context.elements.filterInput.attr('data-placeholder'), '');
			var rawProviderQuery = context.elements.providerSelect.val();
			var rawThemeQuery = context.elements.themeSelect.val();

			var tokens = rawTokenText.toLowerCase().split(' ');
			if (tokens.length === 1 && tokens[0] === "") {
				tokens = [];
			}

			var providerQueryParts = rawProviderQuery.split(',', 2);
			var provider = providerQueryParts.length === 2 ? providerQueryParts[1] : null;

			var types = providerQueryParts[0].length > 1 ? providerQueryParts[0].split('-') : [];

			var theme = null;
			if (rawThemeQuery === "-1") {
				theme = "";
			} else if (rawThemeQuery.length > 2) {
				theme = rawThemeQuery;
			} else {
				theme = null;
			}

			var providers = rawProviderQuery === "" ? [] : rawProviderQuery.split(',', 2);
			return {
				tokens: tokens,
				types: types,
				provider: provider,
				theme: theme
			};
		},
		exists = function (set, test) {
			var matches = false;
			for (var i = 0; i < set.length; i++) {
				if (test(set[i])) {
					matches = true;
					break;
				}
			}
			return matches;
		},
		filterWidgets = function (context) {
			var query = buildWidgetFilterQuery(context);

			var toShow = [], toHide = [];

			var matching = 0, widget, widgetData;
			context.elements.rows.each(function () {
				widget = $(this);
				widgetData = getCachedWidgetData(context, widget);

				var isMatch = true;

				// check for theme/type match

				// check for provider match
				if (query.provider !== null && query.provider !== widgetData.provider) {
					isMatch = false;
				}

				if (isMatch) {
					// first get all widget versions that match the queried theme (if there was one)
					var matchingThemeVersions = query.theme === null ? widgetData.versions :
						$.grep(widgetData.versions, function (version) {
							return version.theme === query.theme;
						});

					// if there was no queried type, just ensure there were at least one matching theme version
					if (query.types.length === 0) {
						isMatch = matchingThemeVersions.length > 0;
					} else if (query.types.length === 1) {
						// check if all selected theme versions are all of the same type as query.types[0]
						isMatch = matchingThemeVersions.length > 0 &&
							!exists(matchingThemeVersions, function (themeVersion) {
								return themeVersion.type !== query.types[0];
							});
					} else if (query.types.length === 2) {
						// check that matching theme versions contains a custom version AND
						//	 there is a default version for the current theme or for no theme
						isMatch = matchingThemeVersions.length > 0 &&
							exists(matchingThemeVersions, function (v) { return v.type === 'custom'; }) &&
							exists(widgetData.versions, function (v) { return v.type === 'default' && (v.theme === "" || v.theme === query.theme); });
					}
				}

				// check for token match
				if (isMatch && query.tokens.length >= 1 && !matchesTokens(widgetData.nameAndDescription, query.tokens)) {
					isMatch = false;
				}

				if (isMatch) {
					toShow.push(widget.get(0));
					matching++;
				} else {
					toHide.push(widget.get(0));
				}
			});
			context.elements.filterInput.trigger('filtered',
			{
				query: query,
				show: $(toShow),
				hide: $(toHide)
			});
			raiseSelectionEvents(context);
		},
		raiseSelectionEvents = function (context) {
			// alert the ui to how many are selected
			var allCheckBoxes = context.elements.checkBoxes;
			var visibleCheckBoxes = context.elements.checkBoxes.filter(':visible');
			var checkedBoxes = visibleCheckBoxes.filter(':checked');
			var data = {
				checkedRows: checkedBoxes.parents('tr.WidgetRow'),
				allRows: context.elements.rows,
				checkedCount: checkedBoxes.length
			};
			if (checkedBoxes.length === 0) {
				context.elements.table.trigger('noneSelected', data);
			} else if (checkedBoxes.length === allCheckBoxes.length) {
				context.elements.table.trigger('allSelected', data);
			} else {
				context.elements.table.trigger('someSelected', data);
			}
		},
		// sets up core actions, events, and functionality - no UI
		setupAction = function (context) {
			// shortcuts for deleting and handling results
			var deleteWidgets = function (identifiers, theme) {
				// build a callback to return the current selection from the modal
				innerGetWidgetSelection = function() {
					return {
						identifiers: identifiers,
						theme: theme
					};
				};
				var url = $.telligent.evolution.url.modify({
					url: context.settings.revertUrl,
					query: {
						fragmentSelectionCallback: 'getWidgetSelection',
						callback: 'widgetsReverted'
					}
				});
				Telligent_Modal.Open(url, 940, 700, null)
			};

			// capture the content of the name/description of displayed widgets for indexed search later
			context.identifiers = {};
			context.elements.rows.each(function () { getCachedWidgetData(context, $(this)); });

			// set up filtering
			context.elements.filterInput
				.on('keypress', function (e) {
					if (e.which === 13) {
						e.stopPropagation();
						e.preventDefault();
						return false;
					}
				})
				.on('keyup', function (e) {
					e.stopPropagation();
					filterWidgets(context);
				});
			context.elements.providerSelect.on('change', function (e) {
				filterWidgets(context);
			});
			context.elements.themeSelect.on('change', function (e) {
				filterWidgets(context);
			});

			// select/deselect-all checkbox
			context.elements.allCheckbox.on('change', function () {
				if (context.elements.allCheckbox.is(':checked')) {
					context.elements.checkBoxes
					//.prop('checked', false)
						.filter(':visible')
						.prop('checked', true);
				} else {
					context.elements.checkBoxes//.filter(':visible')
						.prop('checked', false);
				}
			});

			context.elements.table
			// clicking the row is an alias for checking the checkbox
                .on('click', 'td', function (e) {
					if ($(e.target).is(':not(input,a)')) {
						$(e.target)
								.cached('closest', 'tr')
								.cached('find', 'input[type="checkbox"]')
								.toggleValue()
								.change();
					}
				})
				// enter/leave highlighting
                .on('mouseenter', 'tr', function (e) {
					$(this).trigger('rowEnter');
				})
                .on('mouseleave', 'tr', function (e) {
					$(this).trigger('rowLeave');
				})
				// multi-selection support
                .on('change', 'input[type="checkbox"]', function (e) {
					raiseSelectionEvents(context);
				})
				// single item exporting
                .on('click', 'a.export', function (e) {
					serializeSelection(context, getCachedWidgetData(context, $(e.target).cached('closest', 'tr')).identifier);
					context.elements.exportSelected.postBack();
					return false;
				})
				// single item reverting
                .on('click', 'a.revert', function (e) {
					var widgetData = getCachedWidgetData(context, $(e.target).cached('closest', 'tr'));
					deleteWidgets([widgetData.identifier], context.elements.themeSelect.val());
					return false;
				})
				// single item deleting
                .on('click', 'a.delete', function (e) {
					var widgetData = getCachedWidgetData(context, $(e.target).cached('closest', 'tr'));

					var theme = context.elements.themeSelect.val();

					if((theme === null || theme.length === 0) && widgetData.versions !== null) {
						var customThemeVersions = $.grep(widgetData.versions, function(v) {
							return v.type === 'custom' && v.theme !== null && v.theme.length > 0;
						});
						var customNonThemeVersions = $.grep(widgetData.versions, function(v) {
							return v.type === 'custom' && (v.theme === null || v.theme.length === 0);
						});
						if(customThemeVersions.length > 0 && customNonThemeVersions.length === 0) {
							theme = customThemeVersions[0].theme;
						}
					}

					deleteWidgets([widgetData.identifier], theme);
					return false;
				})
                .on('click', '.license-restricted', function (e) {
			        alert(context.settings.text_Resources_LicenseRestricted);
				    return false;
				})
				// handle linking directly to theme versions widgets when editing
                .on('click', 'a.edit', function (e) {
					e.preventDefault();
					var themeName = context.elements.themeSelect.val();
					var editUrl = $(e.target).attr('href').replace(/THEMENAME/, themeName === "-1" ? "" : themeName);
					window.location.href = editUrl;
				});

			// multi item exporting
			context.elements.exportSelected.on('click', function (e, data) {
				serializeSelection(context);
			});
			// multi item resource exporting
			context.elements.exportSelectedResources.on('click', function (e, data) {
				serializeSelection(context);
			});
			// multi item deleting
			context.elements.deleteSelected.on('click', function (e, data) {
                var theme = context.elements.themeSelect.val();
                // if all selected widgets were of the same single custom theme, then even if there wasn't a selectd theme filter, consider
                // the reversion to be intended for these widgets+theme combination
                if(theme === null || theme.length === 0) {
                    var selectedWidgetDatas = context.elements.checkBoxes
				        .filter(':visible')
				        .filter(':checked')
				        .map(function (i, element) { return getWidgetData(context, $(element).closest('tr')); });
                    var allHaveSameSingleThemeVersion = true, themeOfSelectedWidgets = null;
                    $.each(selectedWidgetDatas, function(i, widgetData) {
                        if(widgetData.versions === null) {
                            allHaveSameSingleThemeVersion = false;
                            return;
                        }
                        if(widgetData.versions.length === 1 && widgetData.versions[0].type === 'custom') {
                            themeOfSelectedWidgets = widgetData.versions[0].theme;
                        }
                        var customVersions = $.grep(widgetData.versions, function(v) { return v.type === 'custom'; });
                        if(customVersions.length > 1 || (customVersions.length === 1 && (customVersions[0].theme === null || customVersions[0].theme.length === 0))) {
                            allHaveSameSingleThemeVersion = false;
                            return;
                        }
                    });
                    if(allHaveSameSingleThemeVersion && themeOfSelectedWidgets !== null) {
                        theme = themeOfSelectedWidgets;
                    }
                }
				deleteWidgets(getSelection(context), theme, 'rowDeleted');
				return false;
			})

			innerWidgetsImported = function (value) {
				context.parent.trigger('widgetsImported', value);
			};

			innerResourcesImported = function (succeeded) {
				context.parent.trigger('resourcesImported', succeeded);
			};

			innerWidgetsReverted = function() {
				context.elements.table.trigger('widgetsDeleted');
			}
		},
		// sets up all ui which displays actions/events/functionality
		setupUi = function (context) {
			var refreshAndAlternateRows = function () {
				$(context.settings.selectors.rows).alternateClass();
			};

			context.elements.filterInput.placeHolderInput();
			// fasten the side dock
			context.elements.dock.dockPanel();
			// colorize the rows
			refreshAndAlternateRows();
			// bind custom ui stuff
			context.parent
				.on('rowEnter', function (e) {
					$(e.target)
						.addClass('over')
						.cached('find', 'div.WidgetActions a').show();
				})
				.on('rowLeave', function (e) {
					$(e.target)
						.removeClass('over')
						.cached('find', 'div.WidgetActions a').hide();
				})
				.on('noneSelected', function (e, data) {
					context.elements.multiWidgetActionsWrapper.slideUp(context.settings.animationDuration);
					data.allRows.removeClass('selected');
				})
				.on('someSelected', function (e, data) {
					context.elements.multiWidgetActionsText.html($.template(context.settings.selectedMessage, { count: data.checkedCount }));
					context.elements.multiWidgetActionsWrapper.slideDown(context.settings.animationDuration);
					data.allRows.removeClass('selected');
					data.checkedRows.addClass('selected');
				})
				.on('allSelected', function (e, data) {
					context.elements.multiWidgetActionsText.html($.template(context.settings.selectedMessage, { count: data.checkedCount }));
					context.elements.multiWidgetActionsWrapper.slideDown(context.settings.animationDuration);
					data.allRows.addClass('selected');
				})
				.on('filtered', function (e, data) {
					data.show.show();
					data.hide.hide();
					refreshAndAlternateRows();
					if ($(context.settings.selectors.rows).filter(':visible').length == 0)
						$("#WidgetsNotFound").show();
					else
						$("#WidgetsNotFound").hide();
					// don't show 'themed' flags on row items if filtering to only view default theme
					if (data.query.theme === '-1') {
						context.elements.list.addClass('defaultTheme');
					} else {
						context.elements.list.removeClass('defaultTheme');
					}
				})
				.on('filterCleared', function (e, data) {
					context.elements.rows.show();
					context.elements.list.removeClass('defaultTheme').removeClass('defaultProvider');
				})
				.on('widgetsDeleted', function (e, data) {
					alert(context.settings.widgetDeleteSuccessMessage);
					window.location.reload();
				})
				.on('widgetsImported', function (e, succeeded) {
					if (succeeded) {
						alert(context.settings.widgetImportSuccessMessage);
						window.location.reload();
					}
				})
				.on('resourcesImported', function (e, succeeded) {
					if (succeeded) {
						alert(context.settings.resourceImportSuccessMessage);
						window.location.reload();
					}
				});
		};
	$.fn.widgetManager = function (options) {
		var settings = $.extend({}, $.fn.widgetManager.defaults, options || {});
		return this.each(function () {
			var context = setupContext($(this), settings);
			setupUi(context);
			setupAction(context);
		});
	};
	$.extend($.fn.widgetManager, {
		defaults: {
			revertUrl: '',
			animationDuration: 150,
			selectedMessage: '{%= count %} widget{% if(count > 1){ %}s{% } %} selected',
			resourceImportSuccessMessage: 'Resources imported successfully',
			selectors: {
				dock: 'div.Dock',
				list: 'div.WidgetList',
				table: 'div.WidgetList table',
				rows: 'div.WidgetList table tr.WidgetRow',
				checkBoxes: 'div.WidgetList table td input[type="checkbox"]',
				filterInput: 'input[name=WidgetFilter]',
				themeSelect: 'select[id$=ThemeSelect]',
				providerSelect: 'select[id$=ProviderSelect]',
				multiWidgetActionsWrapper: 'div.MultiWidgetActions',
				multiWidgetActionsText: 'h4.SelectionMessage',
				allCheckbox: 'th input[type="checkbox"]',
				exportSelected: 'a[id$="ExportSelectedWidgets"]',
				exportSelectedResources: 'a[id$="ExportSelectedWidgetResources"]',
				deleteSelected: 'div.Dock a.delete',
				selectedWidgetsInput: 'input[id$=SelectedWidgetIdentifiers]'
			}
		}
	});
})(jQuery);
