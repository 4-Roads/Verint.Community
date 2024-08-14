
function ClientPopulatedPopupMenu (varName, contextMenuName, inactiveButtonCssClass, activeButtonCssClass, menuItemFormats)
{
	this.VariableName = varName;
	this.ContextMenuName = contextMenuName;
	this.InactiveButtonCssClass = inactiveButtonCssClass;
	this.ActiveButtonCssClass = activeButtonCssClass;
	this.LastParameterData = new Array();
	this.MenuLoaded = false;
	this.Element = null;
	this.AnimatedButtons = new Array();
	this.MenuParameterData = null;
	this.MenuItemFormats = menuItemFormats;

	// menuItemFormats = [i]
	//						[0] = JS function to return true/false to determine if item should be rendered based on parameters
	//                      [1] = Title
	//						[2] = Icon URL
	//						[3] = NavigateUrl
	//						[4] = Target
	//						[5] = ClientSideCommand
	
	this.LoadMenu = function(element, event, parameterData, menuParameterData)
	{
		this.MenuParameterData = menuParameterData;

		if (this.Element == element)
		{
			eval('window.' + this.ContextMenuName + '.Close();');
			this.LastElement = null;
			this.Element = null;
		}
		else
		{
			eval('window.' + this.ContextMenuName + '.Close();');
			this.Element = element;
			this.Element.className = this.ActiveButtonCssClass;
			this.LastParameterData = parameterData;
			this.PopulateMenu();
			this.ShowContextMenu();
		}

		return false;
	}
	
	this.PopulateMenu = function()
	{
		var menu = eval('window.' + this.ContextMenuName);
		menu.ClearItems();
		
		var i, item;
		for (i = 0; i < this.MenuItemFormats.length; i++)
		{
			if (this.MenuItemFormats[i][0] && this.MenuItemFormats[i][0](this.LastParameterData))
			{
				item = new Telligent_PopupMenuItem('item' + i, this.ApplyParameters(this.MenuItemFormats[i][1]));
				item.NavigateUrl = this.ApplyParameters(this.MenuItemFormats[i][3]);
				item.Target = this.ApplyParameters(this.MenuItemFormats[i][4]);
				item.ClientScript = new Function(this.ApplyParameters(this.MenuItemFormats[i][5]));
				item.IconUrl = this.ApplyParameters(this.MenuItemFormats[i][2]);
				menu.AddItem(item);
			}
		}
		
		menu.OnMenuCloseFunction = new Function('eval(\'window.' + this.VariableName + '.ContextMenuClosed();\')');
		menu.Refresh();
	}
	
	this.ApplyParameters = function(value)
	{
		if (!value)
			return value;
		else
			value = new String(value);
	
		var re;
		for (i = 0; i < this.LastParameterData.length; i++)
		{
			re = new RegExp('\\{' + i + '\\}', 'g');
			value = value.replace(re, this.LastParameterData[i]);
		}
		
		return value;
	}	
	
	this.StartAnimation = function(element)
	{
		var index = 0;
		for (index = 0; index < this.AnimatedButtons.length; index++)
		{
			if (!this.AnimatedButtons[index])
				break;
		}
		
		window.document.body.style.cursor = 'progress';
		this.AnimatedButtons[index] = new Array(element, window.setTimeout('window.' + this.VariableName + '.ProcessAnimation(' + index + ', true);', 249), -1);
		
		return index;
	}
	
	this.ProcessAnimation = function(index, highlight)
	{
		var ad = this.AnimatedButtons[index];
		if (ad)
		{
			window.clearTimeout(ad[1]);
			
			if (ad[2] == 0)
			{
				this.AnimatedButtons[index] = null;
				window.clearTimeout(ad[1]);
				
				window.document.body.style.cursor = 'auto';
				
				if (this.Element == ad[0])
					ad[0].className = this.ActiveButtonCssClass;
				else
					ad[0].className = this.InactiveButtonCssClass;
					
				this.AnimatedButtons[index] = null;
				
				return;
			}
			else
			{
				if (ad[2] > 0)
					ad[2] -= 1;
					
				if (highlight)
				{
					ad[0].className = this.ActiveButtonCssClass;
					window.document.body.style.cursor = 'progress';
					ad[1] = window.setTimeout('window.' + this.VariableName + '.ProcessAnimation(' + index + ', false);', 249);
				}
				else
				{
					ad[0].className = this.InactiveButtonCssClass;
					window.document.body.style.cursor = 'progress';
					ad[1] = window.setTimeout('window.' + this.VariableName + '.ProcessAnimation(' + index + ', true);', 249);
				}
			}
		}
	}
	
	this.StopAnimation = function(index)
	{
		var ad = this.AnimatedButtons[index];
		
		if (ad)
		{
			ad[2] = 6;
		}
	}
	
	this.ContextMenuClosed = function()
	{
		this.LastElement = this.Element;
		
		if (this.LastElement)
			this.LastElement.className = this.InactiveButtonCssClass;
			
		this.Element = null;
	}

	this.ShowContextMenu = function()
	{
		var menu = eval('window.' + this.ContextMenuName);
		menu.OpenAtElement(this.Element);
	}
}
