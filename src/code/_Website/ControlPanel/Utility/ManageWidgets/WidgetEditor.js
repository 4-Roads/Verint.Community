// Client-side behaviors for the widget editing page, bundled up as a plugin
(function ($) {
	var innerUploadComplete, innerGetWidgetContext, editorSettings = {};

	// expose stub modal callbacks globally for availability to the modal control
	$.extend(window, {
		uploadComplete: function (value) { innerUploadComplete(value); },
		getWidgetContexts: function (lookUp, query) { innerGetWidgetContext(lookUp, query); }
	});

	var newFileTabId = 0,
	setupEditorSettings = function (context) {
		var loadEditorSettingsFromCookie = function () {
			var cookies = document.cookie.split(';');
			var cookieValue = null;
			for (var i = 0; i < cookies.length; i++) {
				var kv = cookies[i].split('=');
				if (kv !== null && kv.length > 0 && $.trim(kv[0]) === 'evolution_widgetEditorSettings') {
					cookieValue = kv[1];
					break;
				}
			};
			if (cookieValue !== null) {
				return deserializeSettings(cookieValue);
			} else {
				return {};
			}
		},
		saveEditorSettingsToCookie = function (settings) {
			var expirationDate = new Date();
			expirationDate.setTime(expirationDate.getTime() + (30 * 24 * 60 * 60 * 1000));
			document.cookie =
				'evolution_widgetEditorSettings=' + serializeSettings(settings) + '; expires=' + expirationDate.toGMTString() + '; path=/'
		},
		settingsFromControls = function () {
			return {
				theme: context.elements.editorThemeSelectInput.val(),
				showGutter: context.elements.editorGutterToggleInput.is(':checked'),
				showInvisibles: context.elements.editorShowInvisiblesInput.is(':checked'),
				highlightLine: context.elements.editorHighlightLineInput.is(':checked')
			};
		},
		serializeSettings = function (settings) {
			return (settings.theme + '|' + settings.showGutter + '|' + settings.showInvisibles + '|' + settings.highlightLine);
		},
		deserializeSettings = function (serializedSettings) {
			var settings = serializedSettings.split('|');
			return {
				theme: settings[0],
				showGutter: settings[1] === 'true',
				showInvisibles: settings[2] === 'true',
				highlightLine: settings[3] === 'true'
			};
		};

		editorSettings = $.extend(settingsFromControls(), loadEditorSettingsFromCookie());

		// display initial settings
		context.elements.editorThemeSelectInput
			.find('option')
			.removeAttr('selected')
			.end()
			.find('[value="' + editorSettings.theme + '"]')
			.attr('selected', 'selected');

		if (editorSettings.highlightLine) {
			context.elements.editorHighlightLineInput.prop('checked', true);
		} else {
			context.elements.editorHighlightLineInput.prop('checked', false);
		}

		if (editorSettings.showGutter) {
			context.elements.editorGutterToggleInput.prop('checked', true);
		} else {
			context.elements.editorGutterToggleInput.prop('checked', false);
		}

		if (editorSettings.showInvisibles) {
			context.elements.editorShowInvisiblesInput.prop('checked', true);
		} else {
			context.elements.editorShowInvisiblesInput.prop('checked', false);
		}

		context.parent.trigger('editorSettingsChanged', editorSettings);

		// handle changes to editor settings
		context.elements.editorThemeSelectInput
			.add(context.elements.editorGutterToggleInput)
			.add(context.elements.editorHighlightLineInput)
			.add(context.elements.editorShowInvisiblesInput)
			.on('change', function () {
				editorSettings = settingsFromControls();
				context.parent.trigger('editorSettingsChanged', editorSettings);
				saveEditorSettingsToCookie(editorSettings);
				return false;
			});
		context.elements.editorSettingsFieldset
			.on('mouseleave', function (e, data) {
				if (!$(e.target).is('select')) {
					context.settings.editorPopUpPanel.Hide();
				}
			});
		if ($.fn.textEditor.adapter.isSupported()) {
			context.elements.editorSettingsLink.show();
		} else {
			context.elements.editorSettingsLink.hide();
		}
	},
	prepareForSave = function(context) {
		captureCurrentSelectedTab(context);
		serializeEditableFileData(context);
		serializeNonEditableFileData(context);
	},
	validate = function(context) {
		return context.elements.saveLink.evolutionValidation('validate');
	},
	save = function(context) {
		prepareForSave(context);
		if(validate(context)) {
			context.elements.saveLink.postBack();
		}
	},
	saveAs = function(context, widgetName) {
		prepareForSave(context);
		context.elements.saveAsNameInput.val(widgetName);
		if(validate(context)) {
			context.elements.saveAsLink.postBack();
		}
	},
	saveForTheme = function(context, themeName) {
		prepareForSave(context);
		context.elements.themeNameInput.val(themeName);
		context.elements.saveForThemInput.val("true");
		if(validate(context)) {
			context.elements.saveAsLink.postBack();
		}
	},
	captureCurrentSelectedTab = function (context) {
		context.elements.selectedTabTextInput.val(context.tabPanes.GetSelectedTab().Text);
	},
	// serializes metadata about editable file fields into a single field
	// this field contains the names of the other fields which the server-side should inspect
	// for editable content, as editable content could have been added purely on the client side
	serializeEditableFileData = function (context) {
		var inputs = [];
		context.parent.find('div.EditableFile').each(function () {
			var fileWrapper = $(this);
			inputs.push(
				fileWrapper.cached('find', 'input.fileName').attr('name') + ',' +
				fileWrapper.cached('find', 'select.fileType').attr('name') + ',' +
				fileWrapper.cached('find', 'textarea.editor:last').attr('name'));
		});
		context.elements.serializedEditableFileDataInput.val(inputs.join('|'));
	},
	// serializes metadata about non-editable file fields into a single
	// field for the server side to consume.  contains a list of all non-editable file names,
	// as well as their upload context ids, if they were just uploaded via the MultiUpload GLOW control
	serializeNonEditableFileData = function (context) {
		var files = [];
		context.elements.nonEditableAttachmentList.find('tr').each(function () {
			var fileRow = $(this);
			files.push(fileRow.attr('data-filename') + ',' +
				fileRow.attr('data-upload-context'));
		});
		context.elements.serializedNonEditableFileDataInput.val(files.join('|'));
	},
	setupContext = function (parent, settings) {
		var context = {
			parent: $(parent),
			settings: settings
		};
		context.elements = $.extend({}, settings.selectors);
		$.each(context.elements, function (key, value) { context.elements[key] = parent.find(value); });
		// capture a reference to the tabbedPanes instance
		context.tabPanes = window[context.elements.tabbedPanesClientIdHolder.val()];
		return context;
	},
	// sets up core actions, events, and functionality - no UI
	setupAction = function (context) {
		// adds a new editable file tab
		// options:	 title, content.
		var addEditableFileTab = function (options) {
			options = $.extend({
				title: context.settings.newFileDefaultName,
				content: '',
				fileName: '',
				textMode: 'velocity'
			}, options);
			// add a new file tab
			newFileTabId++;
			var newTabContent = $.template(context.settings.newEditableFileTabTemplate, {
				fileIndex: newFileTabId,
				fileContent: options.content,
				fileName: options.fileName,
				textMode: options.textMode
			});
			var tab = new Telligent_TabbedPaneTab('newfile' + newFileTabId, options.title);
			context.tabPanes.AddTab(tab);
			context.tabPanes.Refresh();
			tab.SetPaneContent(newTabContent);
			context.tabPanes.SelectTab(tab);
			// trigger 'tabCreated' on the newly created content
			context.parent.find('div.EditableFile:last').trigger('fileTabCreated');
			return tab;
		};
		// handle file deletion clicks
		$(context.settings.selectors.editableAttachmentDeleteLinks).live('click', function () {
			var selectedTab = context.tabPanes.GetSelectedTab();
			if (confirm(context.settings.fileDeleteConfirmMessage)) {
				context.tabPanes.RemoveTab(selectedTab, false);
				context.tabPanes.Refresh();
			}
			return false;
		});
        // setup save for export button clicks
        context.elements.exportLink.on('click', function(e) {
            prepareForSave(context);
        });
		// handle save button clicks
		context.elements.saveLink.on('click', function (e) {
			e.preventDefault();
			save(context);
		});
		// handle save-as button clicks
		context.elements.saveAsLink.on('click', function (e) {
			e.preventDefault();
			var name = prompt(context.settings.saveAsMessage, "");
			if (name !== null && name.length > 0) {
				saveAs(context, name);
			}
		});
		// handle save for theme clicks
		context.elements.saveForThemeLink.on('click', function (e) {
			e.preventDefault();
			Telligent_Modal.Open(context.settings.themeSelectorPath.replace(/THEMENAME/, context.settings.currentTheme), 550, 500, function (result) {
				if (typeof result !== 'undefined' && result !== null) {
					saveForTheme(context, result);
				}
			});
		});
		context.elements.themeSelect.on('change', function (e) {
			window.location.href = context.settings.themedWidgetEditorPath.replace(/THEMENAME/, context.elements.themeSelect.val());
		});
		// handle widget delete clicks
		context.elements.deleteLink.on('click', function (e) {
			e.preventDefault();
			var confirmText;
			// if there are more than several versions, this is only deleting current version
			if (context.elements.themeSelect !== null && context.elements.themeSelect.find('option').length > 1) {
				confirmText = context.settings.widgetDeleteVersionConfirmMessage;
			} else {
				confirmText = context.settings.widgetDeleteConfirmMessage;
			}
			if (confirm(confirmText)) {
				context.elements.deleteLink.postBack();
			}
			return false;
		});
		// handle widget revert clicks
		context.elements.revertLink.on('click', function (e) {
			e.preventDefault();
			if (confirm(context.settings.widgetRevertConfirmMessage)) {
				context.elements.revertLink.postBack();
			}
			return false;
		});
		// handle adding new file tabs
		context.elements.addFileLink.on('click', function (e) {
			// add a new file tab
			addEditableFileTab();
			return false;
		});
		// handle the live updating of an editable file tab's name based on its file's name
		context.parent.find('input.fileName').live('keyup', function () {
			var target = $(this);
			// get the name for the currently-selected file type extension
			var extension = target.closest('div.EditableFile').find('option').filter(':selected').html();
			target.trigger('fileNameChanged', $.trim(target.val()) + "." + extension);
		});
		// handle the live updating of an editable file tab's name based on its file's selected extension
		$(context.settings.selectors.fileTypeSelectors).live('change', function (e) {
			var target = $(this);
			target.trigger('textModeChange', target.val());

			// get the name and extension for this file
			var fileNameInput = target.closest('div.EditableFile').find('input.fileName');
			var extension = target.find('option').filter(':selected').html();
			// alert the ui in name change
			$(fileNameInput).trigger('fileNameChanged', fileNameInput.val() + "." + extension);
		});
		// handle the deletion of associated files
		$(context.settings.selectors.nonEditableAttachmentDeleteLinks).live('click', function (e) {
			var row = $(this).closest('tr');
			if (confirm(context.settings.fileDeleteConfirmMessage)) {
				row.trigger('nonEditableFileDeleted').remove();
				if (context.elements.nonEditableAttachmentList.find('tr.AttachmentRow').length === 0) {
					context.parent.trigger('noNonEditableFiles');
				}
			}
		});
		var contextSearchTimeout = 0;
		innerGetWidgetContext = function (lookUp, query) {
			if (contextSearchTimeout) {
				clearTimeout(contextSearchTimeout);
			}
			contextSearchTimeout = setTimeout(function () {
				// show spinner
				lookUp.UpdateLookUps([new Telligent_LookUpTextBoxLookUp('', '<div style="text-align: center;"><img src="' + context.settings.spinnerPath + '" /></div>', '<div style="text-align: center;"><img src="' + context.settings.spinnerPath + '" /></div>', false)]);
				// load results
				$.pageMethod('SearchContexts', {
					data: { query: query },
					success: function (contexts) {
						if (contexts.length == 0) {
							lookUp.UpdateLookUps([new Telligent_LookUpTextBoxLookUp('', context.settings.noContextMatchFound, context.settings.noContextMatchFound, false)]);
						} else {
							lookUp.UpdateLookUps($.map(contexts, function (context) {
								return new Telligent_LookUpTextBoxLookUp(context.Id, context.Name, context.Name, true);
							}));
						}
					}
				});
			}, 100);
		};
		// implement the behavior that occurs after an upload complets
		innerUploadComplete = function (uploadContext) {
			// once the upload completes, ask the server side for more detailed
			// information about the upload
			$.pageMethod('ProcessUploads', {
				data: { uploadContext: uploadContext },
				success: function (files) {
					// after getting the more detailed information about the upload
					// display the uploaded files in their proper spot
					$.each(files, function (i, file) {
						// if it was an editable upload, make a tab for it
						if (file.IsEditable) {
							var extensionSplit = file.Name.lastIndexOf('.');
							addEditableFileTab({
								title: file.Name,
								content: file.Contents,
								fileName: file.Name.substring(0, extensionSplit),
								textMode: file.TextMode
							});
						} else {
							// otherwise, add it to the attachments tab

							// remove current attachments that have the same name
							context.elements.nonEditableAttachmentList
								.find('li[data-filename="' + file.Name + '"]')
								.remove();
							context.elements.nonEditableAttachmentList.trigger('nonEditableFileAdded', {
								fileName: file.Name,
								uploadContext: uploadContext
							});
						}
					});
				}
			});
		};
		$(context.elements.noAttachmentsMessageUploadLink).on('click', function () {
			context.elements.uploadLink.trigger('click');
		});
		context.elements.helpLink.on('click', function () {
			window.open(context.settings.helpPath, "ApiHelp", context.settings.popupSettings);
			return false;
		});
		// handle changes to editor settings
		setupEditorSettings(context);
	},
	setupValidation = function(context) {
		context.elements.saveLink
			.evolutionValidation({
				onValidated: function(isValid, buttonClicked, c) { },
				onSuccessfulClick: function(e) { }
			})
			.evolutionValidation('addField', context.elements.nameInput, {
				required: true
			}, context.elements.nameInput.closest('.CommonFormField').find('.field-item-validation'), null);
	},
	setupHotKeys = function (context) {
		$(document).on('keydown', function (e) {
			// ctrl+s saving
			if (e.ctrlKey && e.which == 83) {
				e.preventDefault();
				context.elements.saveLink.trigger('click');
				save(context);
			}
		});
	},
	// sets up all ui which displays actions/events/functionality
	setupUi = function (context) {

		context.elements.dockPanel.dockPanel();
		// helper for enhancing a text area to be a text editor
		var activateEditableText = function (textArea) {
			$(textArea).textEditor(editorSettings);
		};
		activateEditableText(context.elements.textAreas);
		context.parent
				.on('fileTabCreated', function (e, data) {
					activateEditableText($(e.target).find('textarea'));
				})
				.on('fileNameChanged', function (e, data) {
					if (data === null || data === '') {
						data = context.settings.newFileDefaultName;
					}
					// name changing, so assume that we can change the text of the current tab
					var selectedTab = context.tabPanes.GetSelectedTab();
					selectedTab.Text = data;
					// TODO - don't asign to _tabsetTab.  This should be done somewhere automatically within GLOW
					if (typeof selectedTab._tabsetTab !== 'undefined' && selectedTab._tabsetTab !== null) {
						selectedTab._tabsetTab.Text = data;
					}
					context.tabPanes.Refresh();
				})
				.on('nonEditableFileDeleted', function (e, data) {
				})
				.on('nonEditableFileAdded', function (e, data) {
					context.elements.noAttachmentsMessage.hide();
					// add the new files
					context.elements.nonEditableAttachmentList.append($(
						$.template(context.settings.newNonEditableFileTemplate, {
							fileName: data.fileName, uploadContext: data.uploadContext
						})));
				})
				.on('noNonEditableFiles', function (e, data) {
					context.elements.noAttachmentsMessage.show();
				})
				.on('textModeChange', function (e, data) {
					// update the mode on the editable text area related to this drop down
					$(e.target).closest('div.EditableFile').find('textarea.editor:last').textEditor({
						mode: data
					});
				})
				.on('editorSettingsChanged', function (e, data) {
					$.fn.textEditor.configureAllSessions(data);
				});
	};
	$.fn.widgetEditor = function (options) {
		var settings = $.extend({}, $.fn.widgetEditor.defaults, options || {});
		return this.each(function () {
			var context = setupContext($(this), settings);
			setupUi(context);
			setupAction(context);
			setupHotKeys(context);
			setupValidation(context);
		});
	};
	$.extend($.fn.widgetEditor, {
		defaults: {
			newEditableFileTabTemplate: 'NewFileTabTemplate',
			newNonEditableFileTemplate: 'NewNonEditableFileTemplate',
			newFileDefaultName: 'New File',
			saveAsMessage: 'Please provide a new name for this copy of the widget',
			fileDeleteConfirmMessage: "Are you sure you want to delete this file from the widget?",
			widgetDeleteConfirmMessage: "Are you sure you want to delete this widget?",
			widgetRevertConfirmMessage: "Are you sure you want to revert this widget to its initial version?",
			resourceDeleteConfirmMessage: "Are you sure you want to delete the resource \"NAME\"?",
			spinnerPath: '',
			helpPath: '',
			popupSettings: 'width=960,height=700,scrollbars=yes,toolbar=yes,location=yes,menubar=false',
			noContextMatchFound: 'No Matches Found',
			animationDuration: 300,
			editorPopUpPanel: '',
			selectors: {
				addFileLink: 'a.addfile',
                exportLink: 'a[id$="ExportButton"]',
				saveLink: 'a[id$="SaveButton"]',
				saveAsLink: 'a[id$="SaveAsButton"]',
				saveForThemeLink: 'a.savefortheme',
				deleteLink: 'a[id$="DeleteButton"]',
				uploadLink: 'a[id$="Upload"]',
				revertLink: 'a[id$="RevertButton"]',
				helpLink: 'a.help',
				serializedEditableFileDataInput: 'input[id$="SerializedEditableFileDataInput"]',
				serializedNonEditableFileDataInput: 'input[id$="SerializedNonEditableFileDataInput"]',
				tabbedPanesClientIdHolder: 'input[id$="TabbedPanesClientIdHolder"]',
				nameInput: ".WidgetName input[type='text']:last",
				saveAsNameInput: 'input[id$="SaveAsName"]',
				themeNameInput: 'input[id$="ThemeName"]',
				saveForThemInput: 'input[id$="SaveForTheme"]',
				selectedTabTextInput: 'input[id$="SelectedTabText"]',
				textAreas: 'textarea.editor',
				themeSelect: 'select[id$="ThemeVersion"]',
				fileTypeSelectors: 'select.fileType',
				dockPanel: 'div.Dock',
				nonEditableAttachmentList: 'table.NonEditableAttachmentList',
				nonEditableAttachmentDeleteLinks: 'table.NonEditableAttachmentList a.delete',
				editableAttachmentDeleteLinks: 'table.EditableContent a.delete',
				tabLinks: 'a.CommonPaneTab, a.CommonPaneTabSelected',
				noAttachmentsMessage: 'span.NoAttachments',
				noAttachmentsMessageUploadLink: 'span.NoAttachments ~ a.attach',
				tabLinkTables: 'table',
				editorThemeSelectInput: 'select.editorTheme',
				editorGutterToggleInput: 'input.editorGutter',
				editorHighlightLineInput: 'input.editorHighlightLine',
				editorShowInvisiblesInput: 'input.editorShowInvisibles',
				editorSettingsFieldset: 'fieldset.editorSettings',
				editorSettingsLink: 'a.editorSettings',
				resourceEditor: '.resource-editor'
			}
		}
	});

})(jQuery);
