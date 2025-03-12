fe.load_module( "conveyor" );

local wheel_x;
local wheel_y;
local wheel_w;
local wheel_a;
local wheel_h;
local wheel_r;
local my_config;

class Wheel
{ 
	fe = ::fe
	md_dir = FeConfigDirectory + "layouts-common/scripts/wheel/";
	art_infos = null;
	wheel_art = null;
	pointer = null;
	flx = null;
	fly = null;
	flw = null;
	flh = null;
	wheel_art_alpha = null;
	wheel_count = null;
	conveyor = null;
	wheel_pulse_ani = null;
	_partially = null;
	_alpha = null;
	
	first_tick = null;
	stop_fading = null;
	wheel_fade_ms = null;

	constructor(_my_config, _infos, _wheel_art, _pointer)
	{
		my_config = _my_config;
		art_infos = _infos;
		flx = art_infos.layout_size[0];
		fly = art_infos.layout_size[1];
		flw = art_infos.layout_size[2];
		flh = art_infos.layout_size[3];
		wheel_art_alpha = art_infos.wheel_art_alpha;
		wheel_art = _wheel_art;
		pointer = _pointer;
		
		try { wheel_count = my_config["wheels"].tointeger(); } catch ( e ) { }
		
		_partially = 30;
		local num_arts;
		
		// Round wheel
		if ( my_config["wheel_type"] == "圓弧形" )
		{
			wheel_x = [ flx*0.80, flx*0.795, flx*0.756, flx*0.725, flx*0.70, flx*0.68, flx*0.63, flx*0.68, flx*0.70, flx*0.725, flx*0.756, flx*0.76, ]; 
			wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
			wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.28, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
		
			if ( my_config["wheel_semi_t"] == "是" )
				wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
			else
				wheel_a = [  255,  255,  255,  255,  255,  255, 255,  255,  255,  255,  255,  255, ];
			wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.168,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
			wheel_r = [  30,  25,  20,  15,  10,   5,   0, -10, -15, -20, -25, -30, ];
		}
		else // Vertical wheel
		{
			wheel_x = [ flx*0.72, flx*0.72, flx*0.72, flx*0.72, flx*0.72, flx*0.72, flx*0.685, flx*0.72, flx*0.72, flx*0.72, flx*0.72, flx*0.72, ]; 
			wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
			wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.25, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
			
			if ( my_config["wheel_semi_t"] == "是" )
				wheel_a = [  80,  80,  80,  80,  150,  150, 255,  150,  150,  80,  80,  80, ];
			else
				wheel_a = [  255,  255,  255,  255,  255,  255, 255,  255,  255,  255,  255,  255, ];
			wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.15,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
			wheel_r = [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ];
		}
		num_arts = wheel_count;
		
		local wheel_entries = [];
		for ( local i=0; i<num_arts/2; i++ )
			wheel_entries.push( WheelEntry() );
		
		local remaining = num_arts - wheel_entries.len();
		
		// we do it this way so that the last wheelentry created is the middle one showing the current
		// selection (putting it at the top of the draw order)
		for ( local i=0; i<remaining; i++ )
			wheel_entries.insert( num_arts/2, WheelEntry() );
		
		conveyor = Conveyor();
		conveyor.set_slots( wheel_entries );
		try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
		
		
		//Wheel fading code starts here
		if ( my_config["wheel_fadeout"] != "停用" )
		{
			first_tick = 0;
			stop_fading = true;
			wheel_fade_ms = 0;
			try {	wheel_fade_ms = my_config["wheel_fade_ms"].tointeger(); } catch ( e ) { }
			
			if ( wheel_fade_ms > 0 )
			{
				fe.add_transition_callback(this, "wheel_fade_transition" );
				fe.add_ticks_callback(this, "wheel_alpha" );
			}
		}


		/////////////////////////////////////////////////////////////////////////////////
		// pulse current wheel logo
		/////////////////////////////////////////////////////////////////////////////////
		if( my_config["wheel_pulse"] != "停用" )
		{
			local _loop = false;
			if( my_config["wheel_pulse"] == "循環")
				_loop = true;
		
			local art = wheel_entries[wheel_count/2].m_obj;
			local art_pulse = fe.add_artwork( "wheel", art.x,art.y,art.width,art.height );
			art.zorder = 1
			if( my_config["wheel_logo_aspect"] == "是" )
				art_pulse.preserve_aspect_ratio = true;
			
			local _time = 3000;
			
			local wheel_pulse_aniconfig = { interpolation = interpolations.linear, properties = { pulse = { start = 1.0, end = 1.2 }, alpha = { start = 150, end = 0 } }, loop = _loop };
			wheel_pulse_ani = SimpleAnimation(_time, art_pulse, wheel_pulse_aniconfig, true);
			wheel_pulse_ani.play();
			
			fe.add_transition_callback(this, "pulse_transition" );
			fe.add_ticks_callback(this, "stop_pulse" );
		}
	}
	
	function wheel_fade_transition( ttype, var, ttime )
	{
		if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
		{
				first_tick = -1;
				my_delay = fe.layout.time;
				if ( my_config["enable_pointer"] != "否") 
					pointer.alpha = 255;
				if (my_config["enable_wl_bg"] != "否")
					wheel_art.alpha = wheel_art_alpha;
		}
		return false;	 
	}
	
	function wheel_alpha( ttime )
	{
		local search_result = fe.list.search_rule;
		local _elapsed = 0;
		
		if (first_tick == -1)
			stop_fading = false;
	
		// Handle wheel fading after keyboard search
		// -----------------------------------------
		if (first_tick > 0)
			_elapsed = ttime - first_tick;
		
		if (_elapsed < wheel_fade_ms)
		{
			local count = conveyor.m_objs.len();
	
			for (local i=0; i < count; i++)
			{
				if (i == count/2)
					conveyor.m_objs[i].alpha = 255;
				else
				{
					if ( my_config["wheel_semi_t"] == "是" )
						conveyor.m_objs[i].alpha = 80;
					else
						conveyor.m_objs[i].alpha = 255;
				}	
			}
		}
		// -----------------------------------------
	
		// Wheel fading
		if ( !stop_fading && ttime - my_delay >= my_play )
		{
			local elapsed = 0;
	
			if (first_tick > 0)
				elapsed = ttime - first_tick;
	
			local count = conveyor.m_objs.len();
			
			for (local i=0; i < count; i++)
			{
				if ( elapsed > wheel_fade_ms)
				{
					if ( my_config["wheel_fadeout"] == "部份淡出" )
						conveyor.m_objs[i].alpha = _partially;
					else
						conveyor.m_objs[i].alpha = 0;
				}
				else
				{
					if (i == count/2)
					{
						_alpha = (255 * (wheel_fade_ms - elapsed)) / wheel_fade_ms;
						if (_alpha < _partially && my_config["wheel_fadeout"] == "部份淡出")
							_alpha = _partially;
						conveyor.m_objs[i].alpha = _alpha;
					}
					else
					{
						local _start_alpha = 79;
						if ( my_config["wheel_semi_t"] == "否" )
							_start_alpha = 254;
						_alpha = (_start_alpha * (wheel_fade_ms - elapsed)) / wheel_fade_ms;
						if (_alpha < _partially && my_config["wheel_fadeout"] == "部份淡出")
							_alpha = _partially;
						conveyor.m_objs[i].alpha = _alpha;
					}
					
					if ( my_config["enable_pointer"] != "否") 
					{
						_alpha =  (255 * (wheel_fade_ms - elapsed)) / wheel_fade_ms;
						if (_alpha < _partially && my_config["wheel_fadeout"] == "部份淡出")
							_alpha = _partially;
						pointer.alpha = _alpha;
					}
					
					if (my_config["enable_wl_bg"] != "否")
					{
						_alpha = (wheel_art_alpha * (wheel_fade_ms - elapsed)) / wheel_fade_ms;
						if (_alpha < _partially && my_config["wheel_fadeout"] == "部份淡出")
							_alpha = _partially;
						wheel_art.alpha = _alpha;
					}
				}
			}
	
			if ( elapsed > wheel_fade_ms)
			{
				//So we don't keep doing the loop above when all values have 0 alpha
				stop_fading = true;
			}
		
			if (first_tick == -1)
				first_tick = ttime;
		}
	}
	
	function pulse_transition( ttype, var, ttime )
	{
		if( ttype == Transition.ToNewSelection )
		{
			// reset pulse animation when ToNewSelection begins
			wheel_pulse_ani.play();
		}
		return false;
	}
	
	function stop_pulse( ttime )
	{
		// if there is fadeout, pulse once only
		if( conveyor.m_objs[wheel_count/2].m_obj.alpha == 0 || conveyor.m_objs[wheel_count/2].m_obj.alpha == _partially )
		{
			wheel_pulse_ani.loop = false;
		}
	}
	
}


class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( "wheel" ) );
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
		if ( my_config["wheel_logo_mipmap"] == "是" )
			m_obj.mipmap = true;
		if ( my_config["wheel_logo_aspect"] == "是" )
			m_obj.preserve_aspect_ratio=true;
	}
}