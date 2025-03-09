//////////////////////////////////////////////////////////////
//
// Attract-Mode Frontend - KeyboardSearch plugin (DBCS)
// Modify by KenLuoTW
//
//////////////////////////////////////////////////////////////
//
class UserConfig </ help="一個簡單的鍵盤輸入搜尋外掛" /> {

	</ label="觸發鍵",
		help="設定觸發搜尋功能的自訂鍵，自訂鍵可以在 Attract-Mode 的 '輸入控制' 裡設定所要映射的按鍵",
		options="Custom1,Custom2,Custom3,Custom4,Custom5,Custom6",
		order=1 />
	trigger="Custom1";

	</ label="搜尋結果",
		help="設定如何處理搜尋結果",
		options="移至下一個比對結果,顯示搜尋結果列表",
		order=2 />
	results_mode="顯示搜尋結果列表";
	
	</ label="搜尋目標",
		help="",
		options="標題,替代標題",
		order=2 />
	search_target="替代標題";
}

class KeyboardSearchDBCS
{
	_last_search="";
	_trigger="custom1";
	_my_config=null;
	_target="";

	constructor()
	{
		_my_config=fe.get_config();
		_trigger=_my_config["trigger"].tolower();
		_target=_my_config["search_target"].tolower();
		fe.add_signal_handler( this, "on_signal" )
	}

	function command_callback( tt )
	{
		::print( "Running command: mkdir\n" );
	};

	function save_results(slist)
	{
		local f2;
		try { f2 = file( FeConfigDirectory + "romlists/" + fe.displays[fe.list.display_index].romlist + "/search_results.tag", "w" ) }
		catch(e) {
			fe.plugin_command("cmd", " /c md " + FeConfigDirectory + "romlists\\" + fe.displays[fe.list.display_index].romlist, command_callback)
			f2 = file( FeConfigDirectory + "romlists/" + fe.displays[fe.list.display_index].romlist + "/search_results.tag", "w" )
		}

		foreach(s in slist){
			local line = s + "\n";
			local b = blob( line.len() );
			for (local i=0; i<line.len(); i++) b.writen( line[i], 'b' );
			f2.writeblob(b);
		}
	}

	function _select( emu, game )
	{
		for ( local i=0; i<fe.list.size; i++ )
		{
			if (( fe.game_info( Info.Emulator, i ) == emu )
					&& ( fe.game_info( Info.Name, i ) == game ))
			{
				fe.list.index += i;
				return true;
			}
		}
		return false;
	}

	function on_signal( signal )
	{
		if ( signal == _trigger )
		{
			_last_search = fe.overlay.edit_dialog(
				"請輸入搜尋字串:",
				_last_search );
				
			if ( _my_config["results_mode"] == "顯示搜尋結果列表" )
			{
				local search_results = [];
				local sel_emu = fe.game_info( Info.Emulator );
				local sel_game = fe.game_info( Info.Name );
				local temp = _last_search.tolower();
				local s = fe.filters[fe.list.filter_index].size;
				
				if ( _last_search.len() < 1 )
					fe.list.search_rule = "";
				else
				{
					fe.list.search_rule = "";
					for ( local i=0; i<s; i++ )
					{
						local name = fe.game_info((_target=="標題") ? Info.Title : Info.AltTitle,i).tolower();
						local romname = fe.game_info(Info.Name,i);
						
						if ( name.len() < temp.len() )
							continue;
							
						// find() doesn't seem to work if the searched for
						// text happens at the very front of the string (?)
						if (( name.slice(0,temp.len())==temp ) || (name.find( temp ) ))
						{
							search_results.push(romname);
						}
					}
					
					if (search_results.len() > 0)
					{
						save_results(search_results);
						fe.set_display( fe.list.display_index, true )
						
						fe.list.search_rule = "Tags contains "
							+ "search_results";
	
						_select( sel_emu, sel_game );
					}
				}
				return true;
			}

			// "Jump to Next Result" mode
			//
			local temp = _last_search.tolower();
			local s = fe.filters[fe.list.filter_index].size;

			for ( local i=1; i<s; i++ )
			{
				local name = fe.game_info((_target=="標題") ? Info.Title : Info.AltTitle,i).tolower();

				if ( name.len() < temp.len() )
					continue;

				// find() doesn't seem to work if the searched for
				// text happens at the very front of the string (?)
				if (( name.slice(0,temp.len())==temp ) || (name.find( temp ) ))
				{
					// found match
					fe.list.index = (fe.list.index+i)%s;
					break;
				}
			}
			return true;
		}
		else if (( fe.list.search_rule.len() > 0 )
				&& ( signal == "back" ))
		{
			//
			// Clear the search rule when user selects "back"
			//
			// Keep the currently selected game from the search as the selection when
			// we back out
			//
			local sel_emu = fe.game_info( Info.Emulator );
			local sel_game = fe.game_info( Info.Name );

			fe.list.search_rule = "";

			_select( sel_emu, sel_game );
			return true;
		}
		return false;
	}
}

fe.plugin[ "KeyboardSearchDBCS" ] <- KeyboardSearchDBCS();
