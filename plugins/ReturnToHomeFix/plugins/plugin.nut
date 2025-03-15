//////////////////////////////////////////////////////////////
//
// Attract-Mode Frontend - ReturnToHomeFix (Build 20250315)
// Code by KenLuoTW
//
//////////////////////////////////////////////////////////////
//
class UserConfig </ help="修正在第二層選單的 romlist 使用捷徑方式創建第三層選單後，從第三層選單返回主選單時，無法返回主選單正確位置的問題。" /> {
	</ label="排除畫面佈局", help="設定所要排除的畫面佈局 (多個畫面佈局可用分號間隔)", order=1 />
	exclude_layouts="HeyChromey Main Menu Theme;HeyChromey System Theme";
}

local my_dir = fe.script_dir;

class ReturnToHomeFix
{
	_my_config = null;
	exclude_layouts = [];
	key_displays_menu = "displays_menu";
	key_back = "back";

	constructor()
	{
		_my_config=fe.get_config();
		if (_my_config[ "exclude_layouts" ].len() > 0)
			exclude_layouts = split(_my_config[ "exclude_layouts" ], ";");
		
		fe.add_signal_handler(this, "on_signal");
		fe.add_transition_callback(this, "transition");
	}

	function on_signal( signal )
	{
		switch (signal)
		{
			case key_displays_menu:
				if (fe.list.display_index < 0 || fe.displays[fe.list.display_index].in_menu || exclude_layouts.find(fe.displays[fe.list.display_index].layout) != null)
				{
					return false;
				}
								
				if (fe.nv["ReturnToHome"])
				{
					fe.nv["ReturnToHome"] <- false;
					fe.set_display(fe.nv["LastSubMenu"]);
					return true;
				}
				
				fe.nv["ReturnToHome"] <- true;
				fe.signal("back");
				return true;
			default:
				return false;
			
		}
	}
	
	function transition( ttype, var, transition_time )
	{
		if( ttype == Transition.ToNewList )
		{
			local idx=0;
			if (fe.list.display_index >= 0 && fe.displays[fe.list.display_index].in_menu)
			{
				fe.nv["LastSubMenu"] <- fe.list.display_index;
			}
			
			if (fe.nv["ReturnToHome"])
			{
				fe.nv["ReturnToHome"] <- false;
				fe.signal("displays_menu");
			}
		}
		return false;
	}
}

fe.plugin[ "ReturnToHomeFix" ] <- ReturnToHomeFix();
