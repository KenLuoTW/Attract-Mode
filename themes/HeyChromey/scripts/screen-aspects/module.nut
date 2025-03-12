class GetScreenAspects
{ 
	fe = ::fe;
	md_dir = FeConfigDirectory + "themes/HeyChromey/scripts/screen-aspects/";
	aspect_name = "";

	constructor()
	{
		//coordinates table for different screen aspects -- Start

		
		local aspect = fe.layout.width / fe.layout.height.tofloat();
		switch( aspect.tostring() )
		{
			case "1.77865":  //for 1366x768 screen
			case "1.77778":  //for any other 16x9 resolution
				aspect_name = "16x9";
				break;
			case "1.6":
				aspect_name = "16x10";
				break;
			case "1.33333":
				aspect_name = "4x3";
				break;
			case "1.25":
				aspect_name = "5x4";
				break;
			case "0.75":
				aspect_name = "3x4";
				break;
		}
		print("Attract-Mode Version: " + FeVersion + "\n" + "Screen aspect ratio: "+aspect_name+"\n" + "Resolution: "+ScreenWidth+"x"+ScreenHeight+"\n" + "Shader GLSL available: "+ShadersAvailable+"\n" + "OS: "+OS+"\n");
		
		fe.layout.width = Setting("aspectDepend", "res_x");
		fe.layout.height = Setting("aspectDepend", "res_y");
		local mask_factor = Setting("aspectDepend", "maskFactor");

		//coordinates table for different screen aspects -- End
	}
	
	function Setting( id, name )
	{
		local settings = {
			"default": { 
			//16x9 is default
				aspectDepend = { 
					res_x = 2133,
					res_y = 1200,
					maskFactor = 1.9}
			},
			"16x10": {
				aspectDepend = { 
					res_x = 1920,
					res_y = 1200,
					maskFactor = 1.9}
			},
			"16x9": {
				aspectDepend = { 
					res_x = 1920,
					res_y = 1080,
					maskFactor = 1.9}
			},
			"4x3": {
				aspectDepend = { 
					res_x = 1600,
					res_y = 1200,
					maskFactor = 1.6}
			}
			"5x4": {
				aspectDepend = { 
					res_x = 1500,
					res_y = 1200,
					maskFactor = 1.6}
			}
		}
		
		if ( aspect_name in settings && id in settings[aspect_name] && name in settings[aspect_name][id] )
		{
			::print("\tusing settings[" + aspect_name + "][" + id + "][" + name + "] : " + settings[aspect_name][id][name] + "\n" );
			return settings[aspect_name][id][name];
		} else if ( aspect_name in settings == false )
		{
			::print("\tsettings[" + aspect_name + "] does not exist\n");
		} else if ( name in settings[aspect_name][id] == false )
		{
			::print("\tsettings[" + aspect_name + "][" + id + "][" + name + "] does not exist\n");
		}
		::print("\tusing default value: " + settings["default"][id][name] + "\n" );
		return settings["default"][id][name];
	}
}
