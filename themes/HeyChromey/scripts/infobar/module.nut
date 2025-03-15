/////////////////////////////////////////////////////////////////////////////////
// info bar
/////////////////////////////////////////////////////////////////////////////////
class infobar
{ 
	fe = ::fe
	md_dir = FeConfigDirectory + "themes/HeyChromey/scripts/infobar/";
	my_config = null;
	infobar_infos = null;
	flx = null;
	fly = null;
	flw = null;
	flh = null;
	ini_anim_time = null;
	default_gamecategory_type = null;
	
	gameinfo_surface = null;
	controllerinfo_surface = null;
	curr_infobar = null;
	
	title = null;
	titleType = null;
	year = null;
	filter = null;
	favicon = null;
	faviconframe = null;
	itemcount = null;
	joystick_lr_text = null;
	joystick_ud_text = null;
	joystick_a_text = null;
	joystick_b_text = null;
	joystick_x_text = null;
	joystick_y_text = null;
	joystick_start_text = null;

	constructor(_my_config, _infos)
	{
		my_config = _my_config;
		infobar_infos = _infos;
		flx = infobar_infos.layout_size[0];
		fly = infobar_infos.layout_size[1];
		flw = infobar_infos.layout_size[2];
		flh = infobar_infos.layout_size[3];
		ini_anim_time = infobar_infos.ini_anim_time;
		default_gamecategory_type = infobar_infos.default_gamecategory_type;
		curr_infobar = my_config["enable_infobar"];
	
		/////////////////////////////////////////////////////////////////////////////////
		// Game info Surface
		/////////////////////////////////////////////////////////////////////////////////
		gameinfo_surface = fe.add_surface( flw, flh );
		gameinfo_surface.visible = false;
		
		local gameinfo_frame = gameinfo_surface.add_image( FeConfigDirectory+"themes/HeyChromey/art/frame.png", 0, fly*0.88, flw, flh*0.13 );
		gameinfo_frame.alpha = 180;

		local x_title = flx*0.001;
		local x_year = flx*0.001;
		local x_favicon = flx*0.96
		local x_filter = flx*0.7;
		
		local r = 255;
		local g = 255;
		local b = 255;
		
		local title_font_size = flh*0.048;
		local default_font_size = flh*0.024;
		
		// Title
		local titleText = "[Title]";
		titleType = Info.Title;
		if ( my_config["use_alttitle"] == "是" )
		{
			titleText = "[AltTitle]";
			titleType = Info.AltTitle;
		}
		
		title = gameinfo_surface.add_text(gamename(0, 0), x_title, fly*0.899, flw*0.7, flh*0.062);
		title.align = Align.Left;
		title.charsize = title_font_size;
		title.outline = 4;
		title.set_rgb(r, g, b);
		
		// Year and Manufacturer
		year = gameinfo_surface.add_text("© [Year]    [Manufacturer]    " + GetGameCategory(0, default_gamecategory_type) + gamename(0, 1) + gamelang(0), x_year, fly*0.962, flw*0.7, flh*0.026);
		year.align = Align.Left;
		year.charsize = default_font_size;
		year.outline = 3;
		year.set_rgb(r, g, b);
		year.alpha = 150;
			
			
		// favorite
		faviconframe = gameinfo_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/favorite_frame.png", x_favicon, fly*0.899, flh*0.050, flh*0.050);
		faviconframe.alpha = 255;
		favicon = gameinfo_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/favorite.png", x_favicon, fly*0.899, flh*0.050, flh*0.050);
		favicon.alpha = 255;
		gamefavourite(0);
		
		fe.add_transition_callback(this, "text_transitions");
			
			
		// Current game info
		filter = gameinfo_surface.add_text( "已玩次數: [PlayedCount]        目前項目: [ListEntry] / [ListSize]", x_filter, fly*0.962, flw*0.3, flh*0.026);
		filter.align = Align.Right;
		filter.charsize = default_font_size;
		filter.outline = 3;
		filter.alpha = 220;
			
			
		// Random color for info text
		if ( my_config["enable_colors"] == "是" )
		{
			// Color Transitions
			fe.add_transition_callback(this, "gameinfo_color_transitions");
		}
			
		switch ( my_config["enable_ini_anim"] ) {
			case "否":
				// fade in game info if the startup animation is disabled
				// fade in year
				local alpha_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255,	time = (ini_anim_time*2)}
				animation.add( PropertyAnimation( year, alpha_cfg ) );
				
				// fade in title
				local alpha_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255,	time = (ini_anim_time*2)}
				animation.add( PropertyAnimation( title, alpha_cfg ) );
				
				// favorite
				local alpha_cfg = { when = Transition.StartLayout, property = "alpha", start = 0, end = 255, time = (ini_anim_time*2) }
				animation.add( PropertyAnimation( favicon, alpha_cfg ) );
				animation.add( PropertyAnimation( faviconframe, alpha_cfg ) );
		
				// fade in filter
				local alpha_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255, time = (ini_anim_time*2)}
				animation.add( PropertyAnimation( filter, alpha_cfg ) );
				break;
			case "是":
				// animate year
				local move_transition_year = {when = Transition.StartLayout, property = "x", start = flx*-2, end = x_year, time = (ini_anim_time+350)}
				animation.add( PropertyAnimation( year, move_transition_year ) );
		
				// animate title
				local move_transition_title = {when = Transition.StartLayout, property = "x", start = flx*-2, end = x_title, time = (ini_anim_time+350)}
				animation.add( PropertyAnimation( title, move_transition_title ) );
				
				// favorite
				local move_transition_favorite = {	when = Transition.StartLayout, property = "x", start = flx*2, end = x_favicon, time = (ini_anim_time+350) }
				animation.add( PropertyAnimation( favicon, move_transition_favorite ) );
				animation.add( PropertyAnimation( faviconframe, move_transition_favorite ) );
		
				// fade in filter
				local move_transition_filter = {when = Transition.StartLayout, property = "x", start = flx*2, end = x_filter, time = (ini_anim_time+350)}
				animation.add( PropertyAnimation( filter, move_transition_filter ) );
				break;
		}


		/////////////////////////////////////////////////////////////////////////////////
		// Controller info Surface
		/////////////////////////////////////////////////////////////////////////////////
		controllerinfo_surface = fe.add_surface( flw, flh );
		controllerinfo_surface.visible = false;
		
		local controllerinfo_frame = controllerinfo_surface.add_image( FeConfigDirectory+"themes/HeyChromey/art/frame.png", 0, fly*0.92, flw, flh*0.09 );
		controllerinfo_frame.alpha = 180;
		
		local joystick_surface = controllerinfo_surface.add_surface( flw, flh );
		local joystick_lr = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/joystick_ud.png", flx/2-(flh*0.05*10), fly*0.94, flh*0.05, flh*0.05);
		joystick_lr_text = joystick_surface.add_text("選擇", joystick_lr.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
		joystick_lr_text.align = Align.Left;
		joystick_lr_text.charsize = default_font_size;
		joystick_lr_text.outline = 3;
		
		
		local joystick_ud = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/joystick_lr.png", flx/2-(flh*0.05*7), fly*0.94, flh*0.05, flh*0.05);
		joystick_ud_text = joystick_surface.add_text("翻頁", joystick_ud.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
		joystick_ud_text.align = Align.Left;
		joystick_ud_text.charsize = default_font_size;
		joystick_ud_text.outline = 3;
		
		local joystick_a = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_a.png", flx/2-(flh*0.05*4), fly*0.94, flh*0.05, flh*0.05);
		joystick_a_text = joystick_surface.add_text("確定", joystick_a.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
		joystick_a_text.align = Align.Left;
		joystick_a_text.charsize = default_font_size;
		joystick_a_text.outline = 3;
		
		local joystick_b = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_b.png", flx/2-(flh*0.05*1), fly*0.94, flh*0.05, flh*0.05);
		joystick_b_text = joystick_surface.add_text("返回", joystick_b.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
		joystick_b_text.align = Align.Left;
		joystick_b_text.charsize = default_font_size;
		joystick_b_text.outline = 3;
		
		local joystick_x = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_x.png", flx/2+(flh*0.05*2), fly*0.94, flh*0.05, flh*0.05);
		joystick_x_text = joystick_surface.add_text("收藏", joystick_x.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
		joystick_x_text.align = Align.Left;
		joystick_x_text.charsize = default_font_size;
		joystick_x_text.outline = 3;
		
		local joystick_y = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_y.png", flx/2+(flh*0.05*5), fly*0.94, flh*0.05, flh*0.05);
		joystick_y_text = joystick_surface.add_text("篩選", joystick_y.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
		joystick_y_text.align = Align.Left;
		joystick_y_text.charsize = default_font_size;
		joystick_y_text.outline = 3;
		
		local joystick_start = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_start.png", flx/2+(flh*0.05*8), fly*0.94, flh*0.05, flh*0.05);
		joystick_start_text = joystick_surface.add_text("選單", joystick_start.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
		joystick_start_text.align = Align.Left;
		joystick_start_text.charsize = default_font_size;
		joystick_start_text.outline = 3;
		
		local x_itemcount = flx*0.7;
		itemcount = controllerinfo_surface.add_text("項目: [ListEntry] / [ListSize]", x_itemcount, fly*0.94, flw*0.3, flh*0.05);
		itemcount.align = Align.Right;
		itemcount.charsize = default_font_size;
		itemcount.outline = 3;
		itemcount.alpha = 220;
		
		local animation_cfg;
		switch (my_config["enable_ini_anim"])
		{
			case "否":
				animation_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255, time = (ini_anim_time*2)}
				animation.add( PropertyAnimation( itemcount, animation_cfg ) );
				break;
			case "是":
				animation_cfg = {when = Transition.StartLayout, property = "x", start = flx*2, end = x_itemcount, time = (ini_anim_time+350)}
				animation.add( PropertyAnimation( itemcount, animation_cfg ) );
				animation_cfg = {when = Transition.StartLayout, property = "y", start = fly*1.5, end = 0, time = (ini_anim_time*1.1)}
				break;
		}
		
		animation.add( PropertyAnimation( joystick_surface, animation_cfg ) );

		
		// Random color for info text
		if ( my_config["enable_colors"] == "是" )
		{
			// Color Transitions
			fe.add_transition_callback(this, "controllerinfo_color_transitions");

		}
		
		
		/////////////////////////////////////////////////////////////////////////////////
		// Info Bar Frame
		/////////////////////////////////////////////////////////////////////////////////
		if ( my_config["enable_frame"] == "是")
		{
			switch (my_config["enable_infobar"])
			{
				case "遊戲資訊":
					gameinfo_frame.visible = true;
				
					if ( my_config["enable_ini_anim"] == "是" )
					{
						animation_cfg = {when = Transition.StartLayout, property = "y", start = fly*1.5, end = fly*0.88, time = (ini_anim_time*1.1)}
						animation.add( PropertyAnimation( gameinfo_frame, animation_cfg ) );
					}
					else
					{
						animation_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255, time = (ini_anim_time*2)}
						animation.add( PropertyAnimation( gameinfo_frame, animation_cfg ) );
					}
					break;
				case "操作資訊":
					controllerinfo_frame.visible = true;
					
					if ( my_config["enable_ini_anim"] == "是" )
					{
						animation_cfg = {when = Transition.StartLayout, property = "y", start = fly*1.5, end = fly*0.92, time = (ini_anim_time*1.1)}
						animation.add( PropertyAnimation( controllerinfo_frame, animation_cfg ) );
					}
					else
					{
						animation_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255, time = (ini_anim_time*2)}
						animation.add( PropertyAnimation( controllerinfo_frame, animation_cfg ) );
					}
					break;
			}
		}
		else
		{
			gameinfo_frame.visible = false;
			controllerinfo_frame.visible = false;
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////
		// Info Bar Type
		/////////////////////////////////////////////////////////////////////////////////
		switch (my_config["enable_infobar"])
		{
			/////////////////////////////////////////////////////////////////////////////////
			// Game info
			/////////////////////////////////////////////////////////////////////////////////
			case "遊戲資訊":
				controllerinfo_surface.visible = false;
				gameinfo_surface.visible = true;
				break;
			/////////////////////////////////////////////////////////////////////////////////
			// Controller info
			/////////////////////////////////////////////////////////////////////////////////
			case "操作資訊":
				gameinfo_surface.visible = false;
				controllerinfo_surface.visible = true;
				break;
		}
		
		fe.add_signal_handler(this, "infobar_on_signal" )
	}
	
	
	function gamename( index_offset, return_index )
	{
		if ( my_config["hide_brackets"] == "是" )
		{
			local s = split( fe.game_info( titleType, index_offset ), "([])" );
			if (return_index == 1)
			{
				if (s.len() > 2)
				{
					local cats = "    (" + s[return_index] + ")";
					foreach ( text in s )
					{
						if ( text != " " && text != s[0] && text != s[1])
							cats = cats + " (" + text + ")"
					}
					return cats;
				}
				else if ( s.len() > 1 ) return "    (" + s[return_index] + ")";
			}
			else
			{
				if ( s.len() > 0 ) return s[0];
			}
			return "";
		}
		else
		{
			if (return_index == 1)
			{
				return "";
			}
			else
			{
				return fe.game_info( titleType, index_offset );
			}
		}
	}
	
	function gamelang( index_offset )
	{
		local s = fe.game_info( Info.Language, index_offset )
		if ( s.len() > 0 ) return "    (" + s + ")";
		return "";
	}
	
	function gamefavourite ( index_offset )
	{
		if (fe.game_info( Info.Favourite , index_offset) == "1") 
		{
			faviconframe.visible = false;
			favicon.visible = true;
		} else {
			favicon.visible = false;
			faviconframe.visible = true;
		}
	}
	
	
	function brightrand() {
		return 255-(rand()/255);
	}
	
	
	function text_transitions( ttype, var, ttime )
	{
		switch ( ttype )
		{
			case Transition.ToNewList:
			case Transition.ToNewSelection:
				local idx = var;
				if (ttype == Transition.ToNewList) idx = 0;
				title.msg = gamename ( idx, 0 );
				year.msg = "© [Year]    [Manufacturer]    " + GetGameCategory(idx, default_gamecategory_type) + gamename(idx, 1) + gamelang(idx);
				gamefavourite(idx);
				break;
		}
		return false;
	}
	
	
	function gameinfo_color_transitions( ttype, var, ttime ) {
		switch ( ttype )
		{
			case Transition.StartLayout:
			case Transition.ToNewSelection:
				local red = brightrand();
				local green = brightrand();
				local blue = brightrand();
				if(year!="")
					year.set_rgb(red,green,blue);
				if(title!="")
					title.set_rgb(red,green,blue);
				if(filter!="")
					filter.set_rgb(red,green,blue);
				break;
		}
		return false;
	}
	
	
	function controllerinfo_color_transitions( ttype, var, ttime ) {
		switch ( ttype )
		{
			case Transition.StartLayout:
			case Transition.ToNewSelection:
				local red = brightrand();
				local green = brightrand();
				local blue = brightrand();
				if(itemcount!="")
					itemcount.set_rgb(red,green,blue);
				if(joystick_lr_text!="")
					joystick_lr_text.set_rgb(red,green,blue);
				if(joystick_ud_text!="")
					joystick_ud_text.set_rgb(red,green,blue);
				if(joystick_a_text!="")
					joystick_a_text.set_rgb(red,green,blue);
				if(joystick_b_text!="")
					joystick_b_text.set_rgb(red,green,blue);
				if(joystick_x_text!="")
					joystick_x_text.set_rgb(red,green,blue);
				if(joystick_y_text!="")
					joystick_y_text.set_rgb(red,green,blue);
				if(joystick_start_text!="")
					joystick_start_text.set_rgb(red,green,blue);
				break;
		}
		return false;
	}
	
	
	function infobar_on_signal( sig )
	{
		switch ( sig )
		{
			case my_config["infobar_key"]:
				switch (curr_infobar)
				{
					case "遊戲資訊":
						curr_infobar = "操作資訊";
						gameinfo_surface.visible = false;
						controllerinfo_surface.visible = true;
						break;
					case "操作資訊":
						curr_infobar = "遊戲資訊";
						controllerinfo_surface.visible = false;
						gameinfo_surface.visible = true;
						break;
				}
				return true
	
			default:
				return false
		}
	}
	
}


