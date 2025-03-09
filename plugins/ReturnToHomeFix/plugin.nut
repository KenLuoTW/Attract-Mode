//////////////////////////////////////////////////////////////
//
// Attract-Mode Frontend - ReturnToHomeFix
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
	_trigger = "displays_menu";
	_my_config = null;
	exclude_layouts = [];
	returnhome = null;

	constructor()
	{
		_my_config=fe.get_config();
		if (_my_config[ "exclude_layouts" ].len() > 0)
			exclude_layouts = split(_my_config[ "exclude_layouts" ], ";");
		
		returnhome = false;
		fe.add_signal_handler(this, "on_signal");
		fe.add_transition_callback(this, "transition");
	}

	function on_signal( signal )
	{
		switch (signal)
		{
			case _trigger:
				if (fe.list.display_index < 0 || fe.displays[fe.list.display_index].in_menu || exclude_layouts.find(fe.displays[fe.list.display_index].layout) != null)
				{
					return false;
				}
				
				returnhome = true;
				SaveStatus(returnhome);
				fe.signal("back");
				return true;
				break;
			default:
				return false;
				break;
			
		}
	}
	
	function transition( ttype, var, transition_time )
	{
		if( ttype == Transition.ToNewList )
		{
			if (File_Exist(my_dir + "returnhome.opt"))
			{
				LoadStatus();
				if (returnhome)
				{
					returnhome = false;
					SaveStatus(returnhome);
					fe.signal("displays_menu");
				}
			}
		}
		return false;
	}
	
	function LoadStatus(){
		local f = ReadTextFile( my_dir + "returnhome.opt" );
		while ( !f.eos() ) {
			local l = f.read_line();
			switch (l)
			{
				case "true":
					returnhome = true;
					break;
				default:
					returnhome = false;
					break;
			}
		}
	}

	function SaveStatus(isReturn){
		local f = file( my_dir + "returnhome.opt", "w" );
		local line = isReturn.tostring() + "\n";
		local b = blob( line.len() );
		for (local i=0; i<line.len(); i++) b.writen( line[i], 'b' );
		f.writeblob(b);
	}
	
	function File_Exist(path)
	{
	try { file(path, "r" ); return true; }
	catch( e ){ return false; }
	}
}

fe.plugin[ "ReturnToHomeFix" ] <- ReturnToHomeFix();
