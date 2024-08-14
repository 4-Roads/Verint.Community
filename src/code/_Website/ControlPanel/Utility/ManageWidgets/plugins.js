// a small library of custom, specific, plugins supporting the client-side-heavy
// behaviors of the widget-editing-UI

// executes ASP.NET postback for a given post-backing link
// usage: $('somelink').postBack();
(function ($) {
	$.fn.postBack = function () {
		var href = $(this).attr('href');
		if (href !== null && href.indexOf('javascript:') === 0) {
			eval(href.substring(11));
		}
		return this;
	};
})(jQuery);


// simple caching of traversal responses from the perspective of a selection
// allows lazy-loading and caching of common calls like 'closest', 'find', 'children', etc
// usage:  $('...').cached('closest_tr', function(){ return this.closest('tr'); })
(function ($) {
	var prefix = '_cache_';
	$.fn.cached = function (method, selector) {
		var key = prefix + method + selector;
		var results = this.data(key);
		if (results === null || typeof results === 'undefined') {
			results = this[method](selector);
			this.data(key, results);
		}
		return results;
	};
})(jQuery);


// allows simple jQuery-native calling of ASP.NET static page WebMethods
// $.pageMethod('ProcessArray', {
//	data: { ids: [1, 2, 3] },
//	success: function (msg) { console.log(msg); }
// });
(function ($) {
	// a naive shallow-serializing obj-to-JSON method
	// good enough only for serializing simple parameters to WebMethods
	var toJSON = function (obj) {
		var pairs = [], obj = obj || {};
		$.each(obj, function (key, val) {
			var pair = '"' + key + '":';
			if ($.isArray(val)) {
				pair += ('[' + $.map(val, serialize) + ']');
			} else {
				pair += serialize(val);
			}
			pairs.push(pair);
		});
		return ('{' + pairs.join(',') + '}');
	};
	var serialize = function (val) {
		switch (typeof val) {
			case 'string':
				return '"' + val + '"';
			case 'boolean':
				return val ? 'true' : 'false';
			default:
				return String(val);
		}
	};

	$.pageMethod = function (methodName, options) {
		// post a webmethod-compatible Ajax request
		$.ajax($.extend({
			contentType: "application/json; charset=utf-8",
			dataType: 'json',
			type: 'POST',
			url: window.location.pathname + '/' + methodName
		}, options, {
			data: toJSON(options.data || {}),
			success: function (response) { (options.success || function () { })(response.d); },
			error: function (response) { (options.error || function () { })(response.d); }
		}));
	};

})(jQuery);


/* little templating helper
supports parsing a basic text template into into a fast, cached, re-usable templating function
usage:
<!-- a template -->
<script type="text/html" id="MyTemplate">
	<div>Name: {%: name %}</div>
	<div>Age: {%= age %}</div>
	{% if(age > 18) %}
		Old enough to vode
	{% } %}
</script>

// compile the template
var myTemplate = $.template('MyTemplate');
// use the template
var templatedText = myTemplate({
	name: 'Smith',
	age: 25
});

Notes:
	Prints some identifier:
		{%= someIdentifier %}
	Prints some identifier, HTML-escaped:
		{%: someIdentifier %}
	Evaluates expression, without printing
		{% someExpression %}
*/
(function () {
	var templates = {},
		compile = function (template) {
			return new Function("ctx",
				"var encode = function(raw){ return raw" +
				".replace(/&/g,'&amp;').replace(/</g,'&lt;')" +
				".replace(/>/g,'&gt;').replace(/\"/g,'&quot;'); }, " +
				"lines = []; with(ctx){ lines.push('" + template
					.replace(/\'/g, "\\'")
					.replace(/[\r\n]/g, '')
					.replace(/%\}\s*\{%/g, '')
					.replace(/\{%=([\s\S]+?)%\}/g, "' + String($1) + '")
					.replace(/\{%:([\s\S]+?)%\}/g, "' + encode(String($1)) + '")
					.replace(/\{%(.*?)%\}/g, "'); $1 lines.push('") +
				"'); } return lines.join('');");
		};
	$.template = function (source, data) {
		var compiledTemplate = templates[source];
		if (typeof compiledTemplate === 'undefined') {
			var template = (template = document.getElementById(source)) !== null
				? template.innerHTML : source;
			templates[source] = compiledTemplate = compile(template);
		}
		return data ? compiledTemplate(data) : compiledTemplate;
	};
} (jQuery));


/* supports the pinning of an element from scrolling out of vertical bounds of the page */
/* usage
	$('someDiv').dockPanel();
*/
(function ($) {
	$.fn.dockPanel = function (options) {
		var settings = $.extend({}, $.fn.dockPanel.defaults, options || {});

		return this.each(function () {
			var dockWrapper = $(this), global = $(window),
				top = dockWrapper.offset().top - settings.padding,
				defaults = {
					top: dockWrapper.css('top'),
					position: dockWrapper.css('position')
				}, docked = false, scrollTimer = 0, bounced = false;

			global.on('scroll', function () {
				var shouldBeFixed = global.scrollTop() >= top;
				if (shouldBeFixed && !docked) {
					docked = true;
					dockWrapper.css({ position: 'fixed', top: settings.padding + 'px' });
				} else if (!shouldBeFixed && docked) {
					docked = false;
					dockWrapper.css({ position: defaults.position, top: defaults.top });
				}
			});
		});
	};
	$.extend($.fn.dockPanel, {
		defaults: { padding: 25 }
	});
})(jQuery);


/* PlaceHolder Input which supports HTML5-style "placeholder" attribute
which allows default text in a text input.
given:
	<textarea data-placeholder="Name here" id="someArea" />
usage:
	$('#someArea').placeHolderInput();
*/
(function ($) {
	$.fn.placeHolderInput = function (options) {
		var settings = $.extend({}, $.fn.placeHolderInput.defaults, options || {});
		return this.filter('input[type="text"]').each(function () {
			var input = $(this),
				placeHolderValue = input.attr(settings.attribute);
			if (typeof placeHolderValue !== 'undefined' && placeHolderValue !== null) {
				input.on('focus', function () {
					if (input.val() === placeHolderValue) {
						input.val('').removeClass(settings.emptyClass);
					}
				});
				var showPlaceHolder = function () {
					if (input.val() === '') {
						input.addClass(settings.emptyClass).val(placeHolderValue);
					}
				};
				input.on('blur', function () { showPlaceHolder(); });
				showPlaceHolder();
			}
		});
	};
	$.extend($.fn.placeHolderInput, {
		defaults: {
			attribute: 'data-placeholder',
			emptyClass: 'empty'
		}
	});
})(jQuery);


// shortcut plugin for alternating the color of a selection of table rows
// $('table.tr').alternateClass();
(function ($) {
	$.fn.alternateClass = function (options) {
		var settings = $.extend({}, $.fn.alternateClass.defaults, options || {});
		return this.filter(':visible').removeClass(settings.cssClass).filter(':even').addClass(settings.cssClass);
	};
	$.extend($.fn.alternateClass, {
		defaults: {
			cssClass: 'odd'
		}
	});
})(jQuery);


/* toggles the value of a checkbox */
(function ($) {
	$.fn.toggleValue = function () {
		if (this.is(':checked')) {
			return this.prop('checked', false);
		} else {
			return this.prop('checked', true);
		}
	};
})(jQuery);



/*
TextEditor jQuery Plugin
Supports enhancing textareas into more full-fledged programmer text editors
Does not support any particular editing library by default, but can be extended
(for Ace, Bespin/Skywriter, etc)

usage:

$('textarea.editor').textEditor(options)

where options is an optional set of configuration data.

.textEditor() can be called multiple times on the same selection
to reconfigure the editor and it will not re-instantiate the editor.

To adapt an editing provider:

$.fn.textEditor.adapt({
	newSession(textAreaSelection, options) {
		// implementation for creating a new session
	},
	configure(session, options) {
		// implementation for configuring a ession
	},
	isSupported: function() {
		// impmlementation for determining whether adapter
		// is supported in current browser
	}
})

*/
(function ($) {

	var adapter = {
		// yields a new session of the given editing adapter
		newSession: function (textAreaSelection, options) { },
		// configures a given session
		configure: function (session, options) { },
		// returns whether or not the adapter is supported in the current browser
		isSupported: function () { },
		// resizes the height of a given session
		resize: function(session, height) { }
	};

	var sessions = [];

	var dataKey = '_text_editor';

	$.fn.textEditor = function (options) {
		if (adapter.isSupported()) {
			var settings = $.extend({}, $.fn.textEditor.defaults, options || {});
			return this.filter('textarea').each(function () {
				var textArea = $(this),
					session = textArea.data(dataKey);
				if (typeof session === 'undefined' || session === null) {
					// if autoresize plugin exists, resize the session
					// each time the underlying textarea resizes
					if($.fn.autoResize && settings.autoResize) {
						textArea.autoResize({
							onResize: function() {
								setTimeout(function(){
									adapter.resize(session, textArea.height());
								}, 50);
							},
							limit: 25000
						}).change();
					}
					// capture and assign the default mode if there was one provided
					var defaultMode = textArea.attr('data-default-mode');
					if (typeof defaultMode !== 'undefined' && defaultMode !== null) {
						settings.mode = defaultMode;
					}

					session = adapter.newSession(textArea, settings);
					textArea.data(dataKey, session);
					sessions.push(session);
				} else {
					adapter.configure(session, options);
				}
			});
		}
	};
	$.extend($.fn.textEditor, {
		defaults: {
			theme: null,
			mode: null,
			showInvisibles: false,
			highlightLine: true,
			showGutter: true,
			showMargin: false,
			autoResize: false
		},
		adapt: function (api) {
			adapter = api;
			$.fn.textEditor.adapter = api;
		},
		configureAllSessions: function(settings) {
			$.each(sessions, function(i, session) {
				adapter.configure(session, settings);
			});
		},
		adapter: adapter
	});

} (jQuery));




/*
Extends the $.fn.textEditor plugin to be powered by the Ace Text Editor
*/
(function ($, aceApi, req) {
	if (typeof aceApi !== 'undefined' && typeof req !== 'undefined') {

		var modes = {
			javascript: req('ace/mode/javascript').Mode,
			xml: req('ace/mode/xml').Mode,
			html: req('ace/mode/html').Mode,
			css: req('ace/mode/css').Mode,
			velocity: req('ace/mode/velocity').Mode
		};

		var themes = {
			Clouds: 'ace/theme/clouds',
			Cobalt: 'ace/theme/cobalt',
			Dawn: 'ace/theme/dawn',
			Eclipse: 'ace/theme/eclipse',
			Monokai: 'ace/theme/monokai',
			MonoIndustrial: 'ace/theme/mono_industrial',
			PastelOnDark: 'ace/theme/pastel_on_dark',
			Twilight: 'ace/theme/twilight',
			VisualStudio: 'ace/theme/textmate'
		};

		var aceAdapter = {
			newSession: function (textAreaSelection, options) {
				var textArea = $(textAreaSelection);
				var pre = $('<pre></pre>')
				.text(textArea.val())
				.css({
					width: '100%',
					height: textArea.height(),
					position: 'relative'
				})
				.insertAfter(textArea);
				textArea.hide();

				// re-update the original source text area with contents of editor as it is edited
				var editor = aceApi.edit(pre.get(0)),
				session = editor.getSession();

				session.addEventListener('change', function (e, data) {
					textArea.val(session.toString()).change();
				});

				this.configure(editor, options);

				return editor;
			},
			configure: function (session, options) {
				session.setSelectionStyle(false);
				if (typeof options.theme !== 'undefined' && typeof themes[options.theme] !== 'undefined') {
					session.setTheme(themes[options.theme]);
				}
				if (typeof options.mode !== 'undefined' && typeof modes[options.mode] !== 'undefined') {
					session.getSession().setMode(new modes[options.mode]());
				}
				if (typeof options.highlightLine !== 'undefined') {
					session.setHighlightActiveLine(options.highlightLine);
				}
				if (typeof options.showInvisibles !== 'undefined') {
					session.setShowInvisibles(options.showInvisibles);
				}
				if (typeof options.showGutter !== 'undefined') {
					session.renderer.setShowGutter(options.showGutter);
				}
				if (typeof options.showMargin !== 'undefined') {
					session.renderer.setShowPrintMargin(options.showMargin);
				}
			},
			isSupported: function () {
				return $.browser.webkit || $.browser.mozilla || ($.browser.msie && parseFloat($.browser.version) >= 9);
			},
			resize: function(session, height) {
				height += 10;
				$(session.container).height(height);
				session.resize();
			}
		};

		// adapt the text editor plugin for Ace
		$.fn.textEditor.adapt(aceAdapter);
	}

} (jQuery, window.ace, window.require));
