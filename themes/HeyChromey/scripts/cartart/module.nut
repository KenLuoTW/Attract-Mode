fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/shadow-glow/module.nut" );

class Cartart
{ 
	fe = ::fe
	md_dir = FeConfigDirectory + "themes/HeyChromey/scripts/cartart/";
	my_config = null;
	art_infos = null;
	flx = null;
	fly = null;
	flw = null;
	flh = null;
	cartart_surface = null;
	cartart_surface_aniconfig = null;
	cartart_surface_ani = null;
	cartart = null;
	cartart_layout_started = false;
	from_side = null;
	move_direction = null;
	cartart_shadow_vertical_surface = null;
	cartart_shadow_horizontal_surface = null;

	constructor(_my_config, _infos)
	{
		my_config = _my_config;
		art_infos = _infos;
		flx = art_infos.layout_size[0];
		fly = art_infos.layout_size[1];
		flw = art_infos.layout_size[2];
		flh = art_infos.layout_size[3];
		
		cartart_surface = fe.add_surface( flw, flh );
		cartart_surface.trigger = Transition.EndNavigation;
		cartart_surface.zorder = art_infos.zorder;
		
		cartart = cartart_surface.add_artwork("cartart", art_infos.cartart[0], art_infos.cartart[1], art_infos.cartart[2], art_infos.cartart[3] );
		cartart.trigger = Transition.EndNavigation;
		cartart.preserve_aspect_ratio = true;
		
		getCartartSize(0);
		
		if ( my_config["enable_gcartart_shadow"] == "是" )
		{
			makeCartartShadow(0);
		}
	
		switch (move_direction)
		{
			case "x":
				cartart_surface_aniconfig = { interpolation = interpolations.linear, properties = { x = { start = flx*from_side, end = cartart_surface.x } } };
				break;
			case "y":
				cartart_surface_aniconfig = { interpolation = interpolations.linear, properties = { y = { start = fly*from_side, end = cartart_surface.y } } };
				break;
		}
		cartart_surface_ani = SimpleAnimation(my_delay + 200, cartart_surface, cartart_surface_aniconfig, true);
		cartart_surface_ani.play();
		fe.add_transition_callback( this, "cartart_surface_transition" );
	}
	
	function getCartartSize( index_offset ) {
		local tag = fe.game_info( Info.Tags, index_offset );
		
		switch (move_direction)
		{
			case "x":
				cartart_surface.x = 0;
				break;
			case "y":
				cartart_surface.y = 0;
				break;
		}
		
		if ( my_config["wheel_fadeout"] != "停用" ) {
			if ( tag.find("support_vertical") == null ) {
				move_direction = art_infos.cartart_horizontal_fade[6];
				from_side = art_infos.cartart_horizontal_fade[5];
				if ( my_config["enable_gboxart"] == "是" ) {
					cartart.set_pos( art_infos.cartart_horizontal_fade[0], art_infos.cartart_horizontal_fade[1], art_infos.cartart_horizontal_fade[2], art_infos.cartart_horizontal_fade[3]);
				}
				else {
					cartart.set_pos( art_infos.cartart_horizontal_fade[4], art_infos.cartart_horizontal_fade[1], art_infos.cartart_horizontal_fade[2], art_infos.cartart_horizontal_fade[3]);
				}
			}
			else {
				move_direction = art_infos.cartart_vertical_fade[6];
				from_side = art_infos.cartart_vertical_fade[5];
				if ( my_config["enable_gboxart"] == "是" ) {
					cartart.set_pos( art_infos.cartart_vertical_fade[0], art_infos.cartart_vertical_fade[1], art_infos.cartart_vertical_fade[2], art_infos.cartart_vertical_fade[3]);
				}
				else {
					cartart.set_pos( art_infos.cartart_vertical_fade[4], art_infos.cartart_vertical_fade[1], art_infos.cartart_vertical_fade[2], art_infos.cartart_vertical_fade[3]);
				}
			}
		}
		else {
			if ( tag.find("support_vertical") == null ) {
				move_direction = art_infos.cartart_horizontal[6];
				from_side = art_infos.cartart_horizontal[5];
				if ( my_config["enable_gboxart"] == "是" ) {
					cartart.set_pos( art_infos.cartart_horizontal[0], art_infos.cartart_horizontal[1], art_infos.cartart_horizontal[2], art_infos.cartart_horizontal[3]);
				}
				else {
					cartart.set_pos( art_infos.cartart_horizontal[4], art_infos.cartart_horizontal[1], art_infos.cartart_horizontal[2], art_infos.cartart_horizontal[3]);
				}
			}
			else {
				move_direction = art_infos.cartart_vertical[6];
				from_side = art_infos.cartart_vertical[5];
				if ( my_config["enable_gboxart"] == "是" ) {
					cartart.set_pos( art_infos.cartart_vertical[0], art_infos.cartart_vertical[1], art_infos.cartart_vertical[2], art_infos.cartart_vertical[3]);
				}
				else {
					cartart.set_pos( art_infos.cartart_vertical[4], art_infos.cartart_vertical[1], art_infos.cartart_vertical[2], art_infos.cartart_vertical[3]);
				}
			}
		}
	}
	
	function makeCartartShadow( index_offset ) {
		local tag = fe.game_info( Info.Tags, index_offset );
		if ( tag.find("support_vertical") != null) {
			if (cartart_shadow_horizontal_surface) cartart_shadow_horizontal_surface.visible = false;
			if (cartart_shadow_vertical_surface) cartart_shadow_vertical_surface.visible = true;
			
			if ( cartart_shadow_vertical_surface == null )
			{
				cartart_shadow_vertical_surface = cartart_surface.add_surface(flw, flh);
				cartart_shadow_vertical_surface.trigger = Transition.EndNavigation;
				cartart_shadow_vertical_surface.zorder = cartart.zorder -1;
				DropShadow(cartart, art_infos.shadow_config[0], art_infos.shadow_config[1], art_infos.shadow_config[2], art_infos.shadow_config[3], art_infos.shadow_config[4], cartart_shadow_vertical_surface)
			}
		}
		else if ( tag.find("support_vertical") == null) {
			if (cartart_shadow_horizontal_surface) cartart_shadow_horizontal_surface.visible = true;
			if (cartart_shadow_vertical_surface) cartart_shadow_vertical_surface.visible = false;
			if ( cartart_shadow_horizontal_surface == null )
			{
				cartart_shadow_horizontal_surface = cartart_surface.add_surface(flw, flh);
				cartart_shadow_horizontal_surface.trigger = Transition.EndNavigation;
				cartart_shadow_horizontal_surface.zorder = cartart.zorder -1;
				DropShadow(cartart, art_infos.shadow_config[0], art_infos.shadow_config[1], art_infos.shadow_config[2], art_infos.shadow_config[3], art_infos.shadow_config[4], cartart_shadow_horizontal_surface)
			}
		}
	}
	
	function cartart_surface_transition( ttype, var, ttime )
	{
		switch(ttype)
		{
			case Transition.ToNewList:
				if ( cartart_layout_started == true ) {
					getCartartSize(var);
					if ( my_config["enable_gcartart_shadow"] == "是" ) makeCartartShadow(var);
					switch (move_direction)
					{
						case "x":
							cartart_surface_aniconfig = { interpolation = interpolations.linear, properties = { x = { start = flx*from_side, end = cartart_surface.x } } };
							break;
						case "y":
							cartart_surface_aniconfig = { interpolation = interpolations.linear, properties = { y = { start = fly*from_side, end = cartart_surface.y } } };
							break;
					}
					cartart_surface_ani = SimpleAnimation(800, cartart_surface, cartart_surface_aniconfig, true);
					cartart_surface_ani.play();
				}
				else {
					cartart_layout_started = true;
				}
				break;
			case Transition.EndNavigation:
				getCartartSize(var);
				if ( my_config["enable_gcartart_shadow"] == "是" ) makeCartartShadow(var);
				switch (move_direction)
				{
					case "x":
						cartart_surface_aniconfig = { interpolation = interpolations.linear, properties = { x = { start = flx*from_side, end = cartart_surface.x } } };
						break;
					case "y":
						cartart_surface_aniconfig = { interpolation = interpolations.linear, properties = { y = { start = fly*from_side, end = cartart_surface.y } } };
						break;
				}
				cartart_surface_ani = SimpleAnimation(800, cartart_surface, cartart_surface_aniconfig, true);
				cartart_surface_ani.play();
				break;
			case Transition.ToNewSelection:
				switch (move_direction)
				{
					case "x":
						cartart_surface.x = flx*from_side;
						break;
					case "y":
						cartart_surface.y = fly*from_side;
						break;
				}
				break;
		}
		return false;
	}
	
}


