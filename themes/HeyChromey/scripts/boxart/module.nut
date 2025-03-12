fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/shadow-glow/module.nut" );

class Boxart
{ 
	fe = ::fe
	md_dir = FeConfigDirectory + "themes/HeyChromey/scripts/boxart/";
	my_config = null;
	art_infos = null;
	flx = null;
	fly = null;
	flw = null;
	flh = null;
	boxart_surface = null;
	boxart_surface_aniconfig = null;
	boxart_surface_ani = null;
	boxart = null;
	boxart_layout_started = false;
	from_side = null;
	move_direction = null;
	boxart_shadow_vertical_surface = null;
	boxart_shadow_horizontal_surface = null;

	constructor(_my_config, _infos)
	{
		my_config = _my_config;
		art_infos = _infos;
		flx = art_infos.layout_size[0];
		fly = art_infos.layout_size[1];
		flw = art_infos.layout_size[2];
		flh = art_infos.layout_size[3];
		
		boxart_surface = fe.add_surface( flw, flh );
		boxart_surface.trigger = Transition.EndNavigation;
		boxart_surface.zorder = art_infos.zorder;
		
		boxart = boxart_surface.add_artwork("boxart", art_infos.boxart[0], art_infos.boxart[1], art_infos.boxart[2], art_infos.boxart[3] );
		boxart.trigger = Transition.EndNavigation;
		boxart.preserve_aspect_ratio = true;
		
		getBoxartSize(0);
		
		if ( my_config["enable_gboxart_shadow"] == "是" )
		{
			makeBoxartShadow(0);
		}

		switch (move_direction)
		{
			case "x":
				boxart_surface_aniconfig = { interpolation = interpolations.linear, properties = { x = { start = flx*from_side, end = boxart_surface.x } } };
				break;
			case "y":
				boxart_surface_aniconfig = { interpolation = interpolations.linear, properties = { y = { start = fly*from_side, end = boxart_surface.y } } };
				break;
		}
		boxart_surface_ani = SimpleAnimation(my_delay + 200, boxart_surface, boxart_surface_aniconfig, true);
		boxart_surface_ani.play();
		fe.add_transition_callback( this, "boxart_surface_transition" );
	}
	
	function getBoxartSize( index_offset ) {
		local tag = fe.game_info( Info.Tags, index_offset );
		
		switch (move_direction)
		{
			case "x":
				boxart_surface.x = 0;
				break;
			case "y":
				boxart_surface.y = 0;
				break;
		}
		
		if ( my_config["wheel_fadeout"] != "停用" ) {
			if ( tag.find("box3d_vertical") == null ) {
				move_direction = art_infos.boxart_horizontal_fade[6];
				from_side = art_infos.boxart_horizontal_fade[5];
				if ( my_config["enable_gcartart"] == "是" ) {
					boxart.set_pos( art_infos.boxart_horizontal_fade[0], art_infos.boxart_horizontal_fade[1], art_infos.boxart_horizontal_fade[2], art_infos.boxart_horizontal_fade[3]);
				}
				else {
					boxart.set_pos( art_infos.boxart_horizontal_fade[4], art_infos.boxart_horizontal_fade[1], art_infos.boxart_horizontal_fade[2], art_infos.boxart_horizontal_fade[3]);
				}
			}
			else {
				move_direction = art_infos.boxart_vertical_fade[6];
				from_side = art_infos.boxart_vertical_fade[5];
				if ( my_config["enable_gcartart"] == "是" ) {
					boxart.set_pos( art_infos.boxart_vertical_fade[0], art_infos.boxart_vertical_fade[1], art_infos.boxart_vertical_fade[2], art_infos.boxart_vertical_fade[3]);
				}
				else {
					boxart.set_pos( art_infos.boxart_vertical_fade[4], art_infos.boxart_vertical_fade[1], art_infos.boxart_vertical_fade[2], art_infos.boxart_vertical_fade[3]);
				}
			}
		}
		else {
			if ( tag.find("box3d_vertical") == null ) {
				move_direction = art_infos.boxart_horizontal[6];
				from_side = art_infos.boxart_horizontal[5];
				if ( my_config["enable_gcartart"] == "是" ) {
					boxart.set_pos( art_infos.boxart_horizontal[0], art_infos.boxart_horizontal[1], art_infos.boxart_horizontal[2], art_infos.boxart_horizontal[3]);
				}
				else {
					boxart.set_pos( art_infos.boxart_horizontal[4], art_infos.boxart_horizontal[1], art_infos.boxart_horizontal[2], art_infos.boxart_horizontal[3]);
				}
			}
			else {
				move_direction = art_infos.boxart_vertical[6];
				from_side = art_infos.boxart_vertical[5];
				if ( my_config["enable_gcartart"] == "是" ) {
					boxart.set_pos( art_infos.boxart_vertical[0], art_infos.boxart_vertical[1], art_infos.boxart_vertical[2], art_infos.boxart_vertical[3]);
				}
				else {
					boxart.set_pos( art_infos.boxart_vertical[4], art_infos.boxart_vertical[1], art_infos.boxart_vertical[2], art_infos.boxart_vertical[3]);
				}
			}
		}
	}
	
	function makeBoxartShadow( index_offset ) {
		local tag = fe.game_info( Info.Tags, index_offset );
		if ( tag.find("box3d_vertical") != null) {
			if (boxart_shadow_horizontal_surface) boxart_shadow_horizontal_surface.visible = false;
			if (boxart_shadow_vertical_surface) boxart_shadow_vertical_surface.visible = true;
			
			if ( boxart_shadow_vertical_surface == null )
			{
				boxart_shadow_vertical_surface = boxart_surface.add_surface(flw, flh);
				boxart_shadow_vertical_surface.trigger = Transition.EndNavigation;
				boxart_shadow_vertical_surface.zorder = boxart.zorder -1;
				DropShadow(boxart, art_infos.shadow_config[0], art_infos.shadow_config[1], art_infos.shadow_config[2], art_infos.shadow_config[3], art_infos.shadow_config[4], boxart_shadow_vertical_surface)
			}
		}
		else if ( tag.find("box3d_vertical") == null) {
			if (boxart_shadow_horizontal_surface) boxart_shadow_horizontal_surface.visible = true;
			if (boxart_shadow_vertical_surface) boxart_shadow_vertical_surface.visible = false;
			if ( boxart_shadow_horizontal_surface == null )
			{
				boxart_shadow_horizontal_surface = boxart_surface.add_surface(flw, flh);
				boxart_shadow_horizontal_surface.trigger = Transition.EndNavigation;
				boxart_shadow_horizontal_surface.zorder = boxart.zorder -1;
				DropShadow(boxart, art_infos.shadow_config[0], art_infos.shadow_config[1], art_infos.shadow_config[2], art_infos.shadow_config[3], art_infos.shadow_config[4], boxart_shadow_horizontal_surface)
			}
		}
	}
	
	function boxart_surface_transition( ttype, var, ttime )
	{
		switch(ttype)
		{
			case Transition.ToNewList:
				if ( boxart_layout_started == true ) {
					getBoxartSize(var);
					if ( my_config["enable_gboxart_shadow"] == "是" ) makeBoxartShadow(var);
					switch (move_direction)
					{
						case "x":
							boxart_surface_aniconfig = { interpolation = interpolations.linear, properties = { x = { start = flx*from_side, end = boxart_surface.x } } };
							break;
						case "y":
							boxart_surface_aniconfig = { interpolation = interpolations.linear, properties = { y = { start = fly*from_side, end = boxart_surface.y } } };
							break;
					}
					boxart_surface_ani = SimpleAnimation(800, boxart_surface, boxart_surface_aniconfig, true);
					boxart_surface_ani.play();
				}
				else {
					boxart_layout_started = true;
				}
				break;
			case Transition.EndNavigation:
				getBoxartSize(var);
				if ( my_config["enable_gboxart_shadow"] == "是" ) makeBoxartShadow(var);
				switch (move_direction)
				{
					case "x":
						boxart_surface_aniconfig = { interpolation = interpolations.linear, properties = { x = { start = flx*from_side, end = boxart_surface.x } } };
						break;
					case "y":
						boxart_surface_aniconfig = { interpolation = interpolations.linear, properties = { y = { start = fly*from_side, end = boxart_surface.y } } };
						break;
				}
				boxart_surface_ani = SimpleAnimation(800, boxart_surface, boxart_surface_aniconfig, true);
				boxart_surface_ani.play();
				break;
			case Transition.ToNewSelection:
				switch (move_direction)
				{
					case "x":
						boxart_surface.x = flx * from_side;
						break;
					case "y":
						boxart_surface.y = fly * from_side;
						break;
				}
				break;
		}
		return false;
	}
	
}


