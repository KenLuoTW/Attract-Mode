///////////////////////////////////////////////////
//
// Modern Dialogs module
// This is an internal part of
// Ambience HD theme for Attract-Mode Frontend
//
// by Oomek 2019
//
///////////////////////////////////////////////////

fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/common/module.nut" );

local md_dir = FeConfigDirectory + "themes/HeyChromey/scripts/modern-dialogs/";
fe.do_nut( md_dir + "math.nut" )
fe.do_nut( md_dir + "modern_dialog.nut" )
fe.do_nut( md_dir + "modern_dialog_animate.nut" )

config_power_menu <-
{
	[1] = ["關機", @"shutdown", @"/s /t 0"],
	[2] = ["睡眠", @"rundll32.exe", @"powrprof.dll, SetSuspendState 0,1,0"],
	[3] = ["重新啟動", @"shutdown", @"/r /t 0"],
};


class ModernDialogs
{
	key_add_favourite = "add_favourite"
	key_displays_menu = "displays_menu"
	key_filters_menu = "filters_menu"
	key_add_tags = "add_tags"
	key_exit = "exit"
	key_back = "back"
	key_default = "default"
	key_custom2 = "custom2"
	pressed_key = null
	dialog = null
	dialogAnimZoom = null
	dialog_row_height = 0
	dialog_rows = 6
	dialog_select_pos = 0

	enable_add_favourite = true
	enable_add_tags = true
	enable_filtersmenu = true

	title_add_favourite = "ADD TO FAVOURITES?"
	title_remove_favourite = "REMOVE FROM FAVOURITES?"
	title_displays_menu = "DISPLAYS"
	title_displays_exit = "EXIT ATTRACT-MODE?"
	title_filters_menu = "FILTERS"
	title_add_tags = "TAGS"
	title_exit = "POWER OPTIONS"
	title_opts_menu = "CONTEXT MENU"

	opt_configure = "Configure"
	opt_layout_options = "Configure Layout"
	opt_exit_to_desktop = "Exit to Desktop"
	opt_back = "Back"
	opt_exit = "Exit Attract-Mode"
	
	filters_gameregion_type = "Default"
	filters_gamecategory_type = "Default"
	filters_gameregion = "Game Region"
	filters_gamecategory = "Game Category"
	filters_favourite = "My favourites"
	filters_current_gameregion = "全部"
	filters_current_gamecategory = "全部遊戲"
	infavourites = false

	soundMenuSelect = null
	soundMenuPress = null
	soundMenuPopup = null

	constructor()
	{
		pressed_key = key_default
		dialog_row_height = ceil( fe.layout.height / 1080.0 * 50.0 / 1.0 ) * 1 //TODO / 2.0 and * 2.0 to investigate non 1080p resolutions
		dialog = ModernDialog( fe.layout.width / 2, fe.layout.height / 2, math.max( fe.layout.width / 3, fe.layout.height / 3 ), dialog_row_height, dialog_rows )
		dialog.frame.rows = dialog_rows
		dialogAnimZoom = ModernDialogAnimate( dialog )
		fe.overlay.set_custom_controls( dialog.title, dialog.list )
		
		fe.add_transition_callback( this, "modern_dialogs_overlay_transition" )
		fe.add_signal_handler( this, "modern_dialogs_on_signal" )
		
		soundMenuSelect = fe.add_sound( md_dir + "sounds/menu_select.wav" )
		soundMenuPress = fe.add_sound( md_dir + "sounds/menu_press.wav" )
		soundMenuPopup = fe.add_sound( md_dir + "sounds/menu_popup.wav" )
		fe.add_transition_callback( this, "sound_transition" )
	}

	function powermenu()
	{
		local dialog_options = []
		local dialog_title = title_exit
		dialog_options.push( opt_exit )
		foreach (key, data in config_power_menu)
			dialog_options.push( data[0] )
		dialog_options.push( opt_back )
		local result = fe.overlay.list_dialog( dialog_options, dialog_title, 0, dialog_options.len() - 1 )

		for ( local i = 1; i <= config_power_menu.len(); i++ )
		{
			if (( result ) == i )
				fe.plugin_command_bg( config_power_menu[i][1], config_power_menu[i][2] )
		}

		switch( result )
		{
			case 0:
				fe.signal( "exit_to_desktop" )
				break
			case config_power_menu.len() + 1:
				break
			default:
				break
		}
		pressed_key = key_default
	}

	function optmenu()
	{
		local dialog_options = []
		local dialog_title = title_opts_menu;
		dialog_options.append(opt_configure);
		dialog_options.append(opt_layout_options);
		dialog_options.append(opt_exit_to_desktop);
		dialog_options.append(opt_back);
		local result = fe.overlay.list_dialog( dialog_options, dialog_title, 0 )

		switch( result )
		{
			case 0:
				fe.signal("configure");
				break;
			case 1:
				fe.signal("layout_options");
				break;
			case 2:
				fe.signal("exit_to_desktop");
				break;
			default:
				break;
		}
		pressed_key = key_default
	}
	
	function filtersmenu()
	{
		local dialog_options = []
		local dialog_title = title_filters_menu;
		dialog_options.append(filters_gameregion);
		dialog_options.append(filters_gamecategory);
		dialog_options.append(filters_favourite);
		local result = fe.overlay.list_dialog( dialog_options, dialog_title, 0 )

		switch( result )
		{
			case 0:
				gameregionmenu();
				break;
			case 1:
				gamecategorymenu();
				break;
			case 2:
				if (fe.filters.len() > 0)
				{
					local idx = 0;
					foreach (filter in fe.filters)
					{
						if (filter.name == "我的最愛" || filter.name == "Favourites")
						{
							if (filter.size > 0)
							{
								infavourites = true;
								fe.list.filter_index = idx;
							}
							else
							{
								while( !fe.overlay.splash_message( "我的最愛裡並無遊戲\n\n請按取消鍵返回" )){};
							}
							break;
						}
						idx+=1;
					}
				}
				else
				{
					while( !fe.overlay.splash_message( "我的最愛裡並無遊戲\n\n請按取消鍵返回" )){};
				}
				break;
			default:
				break;
		}
		pressed_key = key_default
	}
	
	function gameregionmenu()
	{
		local dialog_options = [];
		local dialog_title = filters_gameregion;
		local dialog_index = get_filtermenu_selected_index("gameregion");

		foreach (data in filter_gameregion_infos[filters_gameregion_type])
		{
			if (data == filters_current_gameregion)
				dialog_options.push( "★ " + data + "  	" );
			else
				dialog_options.push( "  	" + data + "  	" );
		}
		local result = fe.overlay.list_dialog( dialog_options, dialog_title, 0, dialog_options.len())
		
		if (result < dialog_options.len())
		{
			local filters_prev_gameregion = filters_current_gameregion;
			filters_current_gameregion = filter_gameregion_infos[filters_gameregion_type][result];
			local filterIndex = get_filter_index();
			
			if (filterIndex >= 0)
			{
				if (fe.filters[filterIndex].size > 0)
				{
					if ( fe.filters.len() > filterIndex)
					{
						fe.list.filter_index = filterIndex;
					}
				}
				else
				{
					filters_current_gameregion = filters_prev_gameregion;
					while( !fe.overlay.splash_message( "目前所選擇的分類列表並無遊戲\n\n請按取消鍵返回" )){};
				}
			}
		}
		pressed_key = key_default
	}
	
	function gamecategorymenu()
	{
		local dialog_options = [];
		local dialog_title = filters_gamecategory;
		local dialog_index = get_filtermenu_selected_index("gamecategory");

		foreach (data in filter_gamecategory_infos[filters_gamecategory_type])
		{
			if (data == filters_current_gamecategory)
				dialog_options.push( "★ " + data + "  	" );
			else
				dialog_options.push( "  	" + data + "  	" );
		}
		local result = fe.overlay.list_dialog( dialog_options, dialog_title, 0, dialog_options.len())
		
		if (result < dialog_options.len())
		{
			local filters_prev_gamecategory = filters_current_gamecategory;
			filters_current_gamecategory = filter_gamecategory_infos[filters_gamecategory_type][result];
			local filterIndex = get_filter_index();
			
			if (filterIndex >= 0)
			{
				if (fe.filters[filterIndex].size > 0)
				{
					if ( fe.filters.len() > filterIndex)
					{
						fe.list.filter_index = filterIndex;
					}
				}
				else
				{
					filters_current_gamecategory = filters_prev_gamecategory;
					while( !fe.overlay.splash_message( "目前所選擇的分類列表並無遊戲\n\n請按取消鍵返回" )){};
				}
			}
		}
		pressed_key = key_default
	}

	function modern_dialogs_overlay_transition( ttype, var, ttime )
	{
		switch ( ttype )
		{
			case Transition.ShowOverlay:
				dialogAnimZoom.to = 1.0
				dialog.rows = dialog.list.list_size
				dialog.set(0)

				switch( pressed_key )
				{
					case key_add_favourite:
						local m = fe.game_info( Info.Favourite )

						if ( m == "1" )
							dialog.title.msg = title_remove_favourite
						else
							dialog.title.msg = title_add_favourite

						dialog.set(1)
						break

					case key_displays_menu:
						// Special case when exit is called from Displays menu
						if ( var == Overlay.Exit )
						{
							dialog.title.msg = title_displays_exit
							dialog.set(1)
						}
						else
						{
							dialog.title.msg = title_displays_menu
							dialog.set( fe.list.display_index )
						}
						break

					case key_filters_menu:
						dialog.title.msg = title_filters_menu
						dialog.set(0)
						break
						
					case key_add_tags:
						dialog.title.msg = title_add_tags
						break

					case key_exit:
						dialog.title.msg = title_exit
						dialog.set(0)
						break

					case key_custom2:
						dialog.title.msg = title_opts_menu
						dialog.set(0)
						break
				}
				break

			case Transition.HideOverlay:
				dialogAnimZoom.to = 0.0
				if ( dialogAnimZoom.from > 0.0 )
				{
					dialogAnimZoom.tick( ttime )
					return true
				}
				break

			case Transition.NewSelOverlay:
				dialog.move( var )
				break
		}
		return false;
	}

function sound_transition( ttype, var, ttime )
{
	switch ( ttype )
	{
		case Transition.ShowOverlay:
			soundMenuPopup.playing = true
			break

		case Transition.NewSelOverlay:
			soundMenuSelect.playing = true
			break

		case Transition.HideOverlay:
			soundMenuPress.playing = true
			break
	}
	return false
}

	function modern_dialogs_on_signal( sig )
	{
		switch ( sig )
		{
			case key_add_favourite:
				if (enable_add_favourite) {
					pressed_key = key_add_favourite
					return false
				} else {
					return true
				}

			case key_displays_menu:
				pressed_key = key_displays_menu
				return false

			case key_filters_menu:
				if (fe.list.display_index == -1) return true
				if (enable_filtersmenu) {
					pressed_key = key_filters_menu
					filtersmenu()
				}
				return true

			case key_add_tags:
				if (enable_add_tags) {
					pressed_key = key_add_tags
					return false
				} else {
					return true
				}

			case key_back:
				if (fe.list.filter_index != 0 && infavourites)
				{
					infavourites = false;
					fe.list.filter_index = 0;
					return true
				}
				return false

			case key_exit:
				pressed_key = key_exit
				powermenu()
				return true

			case key_custom2:
				pressed_key = key_custom2
				optmenu()
				return true

			default:
				return false
		}
	}

	function _set( idx, val )
	{
		switch (idx) {
			case "titlefont":
				dialog.title.font = val;
				break;
			case "listfont":
				dialog.list.font = val;
				break;
			default:
				break;
		}
	}
}


//get value index in a table
function get_tb_valueindex(tb, key, value){
    local i = -1;

    foreach( val in tb[key] ){
		i++;
        if(val == value) return i
    }
    return -1;
}

//get filter selected item index
function get_filtermenu_selected_index(filtermenu){
	local selectedIndex = 0;
	local filterName = fe.filters[fe.list.filter_index].name;
	
	local filterNameArray = split(filterName, "_");
	
	if (filterNameArray.len() > 1)
	{
		filters_current_gameregion = filterNameArray[1];
		filters_current_gamecategory = filterNameArray[0];
	}
	else
	{
		filters_current_gameregion = "全部";
		filters_current_gamecategory = filterNameArray[0];
	}
	
	if (filtermenu == "gameregion" )
	{
		selectedIndex = get_tb_valueindex(filter_gameregion_infos, filters_gameregion_type, filters_current_gameregion);
	}
	else if (filtermenu == "gamecategory" )
	{
		selectedIndex = get_tb_valueindex(filter_gamecategory_infos, filters_gamecategory_type, filters_current_gamecategory);
	}
	return selectedIndex;
}

//get filter index
function get_filter_index(){
	local filterIndex = -1;
	if (get_tb_valueindex(filter_gameregion_infos, filters_gameregion_type, filters_current_gameregion) >= 0)
	{
		
		local multipleValue = get_tb_valueindex(filter_gameregion_infos, filters_gameregion_type, filters_current_gameregion);
		
		local plusValue = filter_gamecategory_infos[filters_gamecategory_type].len();
		
		local gameCategoryIndex = get_tb_valueindex(filter_gamecategory_infos, filters_gamecategory_type, filters_current_gamecategory);
		
		if (multipleValue > 0)
		{
			filterIndex = gameCategoryIndex + (plusValue * multipleValue);
		}
		else
		{
			filterIndex = gameCategoryIndex;
		}
	}
	return filterIndex;
}
