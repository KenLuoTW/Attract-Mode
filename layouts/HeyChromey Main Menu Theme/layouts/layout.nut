////////////////////////////////////////////////////////////////////////////////////////////////////////
// HeyChromey Main Menu (Build 20250315)
//
// Design, Code by KenLuoTW
//
// 'coordinates table for different screen aspects' code adapted from nevato theme
////////////////////////////////////////////////////////////////////////////////////////////////////////  
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/common/module.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/filter-infos/module.nut" );


/////////////////////////////////////////////////////////////////////////////////
// settings
/////////////////////////////////////////////////////////////////////////////////
local default_gameregion_type = "None";
local default_gamecategory_type = "None";
local default_gameart_dir = FeConfigDirectory + "menu-art";


/////////////////////////////////////////////////////////////////////////////////
// Default Gameregion
/////////////////////////////////////////////////////////////////////////////////

local default_gameregion_opts = "停用";


/////////////////////////////////////////////////////////////////////////////////
// Default GameCategory
/////////////////////////////////////////////////////////////////////////////////

local default_gamecategory_opts = "停用";


/////////////////////////////////////////////////////////////////////////////////
// Config
/////////////////////////////////////////////////////////////////////////////////

local orderx = 0;
local label_topic = "      						"
local label_begin = "      						⦿ "
local label_end = "                                                                                                   "

class UserConfig {
	</ label=label_topic, help=" ", options = " ", order=orderx++ /> paramtt0 = " "
	</ label=label_topic + "畫面佈局" + label_end, help=" ", options = " ", order=orderx++ /> paramxx0 = " "
	</ label=label_begin + "啟用啟動動畫" + label_end, help="當畫面佈局啟動時啟用系統動畫", options="是,否", order=orderx++ /> enable_ini_anim="是";
	</ label=label_begin + "啟動動畫過渡時間" + label_end, 
		help="動畫過渡時間以毫秒為單位", 
		options="500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000",
		order=orderx++
		/>ini_anim_trans_ms="1000";
	</ label=label_begin + "選擇背景圖像" + label_end, help="選擇背景圖像", options="預設背景,平台捉圖,平台視訊,玩家自製插圖", order=orderx++ /> select_bg_img="預設背景";
	</ label=label_begin + "啟用背景掃描線" + label_end, help="在背景圖像上顯示掃描線效果", options="停用,淡,中,暗", order=orderx++ /> enable_scanline="中";
	</ label=label_begin + "啟用背景極光效果" + label_end, help="在背景圖像上顯示極光效果", options="停用,啟用", order=orderx++ /> enable_videooverlay="啟用";
	</ label=label_begin + "啟用背景音樂" + label_end, help="播放背景音樂", options="停用,啟用", order=orderx++ /> enable_bgmusic="啟用";
	
	</ label=label_topic, help=" ", options = " ", order=orderx++ /> paramtt1 = " "
	</ label=label_topic + "輪播清單" + label_end, help=" ", options = " ", order=orderx++ /> paramxx1 = " "
	</ label=label_begin + "保持輪播圖標外觀比例" + label_end, help="保持輪播圖標原始的外觀比例，在垂直形輪播模式下特別適合。", options="是,否", order=orderx++ /> wheel_logo_aspect="否";
	</ label=label_begin + "在輪播圖標啟用貼圖過濾" + label_end, help="貼圖過濾 (Mipmap) 能夠讓高解析輪播圖標減少鋸齒失真", options="是,否", order=orderx++ /> wheel_logo_mipmap="否";
	</ label=label_begin + "啟用半透明輪播圖標" + label_end, help="選擇半透明或不透明效果在輪播圖標", options="是,否", order=orderx++ /> wheel_semi_t="是";
	</ label=label_begin + "輪播清單過渡時間" + label_end, 
		help="輪播項目時間 (以毫秒為單位)", 
		options="1,25,50,75,100,125,150,175,200",
		order=orderx++
		/>transition_ms="25";
	</ 	label			= label_begin + "輪播清單延遲時間" + label_end,
		help			= "延遲輪播清單及指標出現的時間 (以毫秒為單位)",
		options			= "500,750,1000,1250,1500,1750,2000,2250,2500,2750,3000",
		order			= orderx++
	/> 	set_ms_delay	= "1250";
	</ label=label_begin + "啟用輪播清單波動效果" + label_end, help="波動效果會套用在目前項目的輪播圖標 (輪播清單淡出效果啟用時將僅會波動一次)", options="停用,一次,循環", order=orderx++ /> wheel_pulse="循環";

	</ label=label_topic, help=" ", options = " ", order=orderx++ /> paramtt5 = " "
	</ label=label_topic + "資訊列" + label_end, help=" ", options = " ", order=orderx++ /> paramxx5 = " "
	</ label=label_begin + "介面字型" + label_end, help="選擇顯示介面所使用的字型", options="SourceHanSansTC-Regular,SourceHanSansTC-Medium,SourceHanSansTC-Bold", order=orderx++ /> layout_font="SourceHanSansTC-Regular";
	</ label=label_begin + "選單字型" + label_end, help="選擇快捷選單所使用的字型", options="SourceHanSansTC-Regular,SourceHanSansTC-Medium,SourceHanSansTC-Bold", order=orderx++ /> menu_font="SourceHanSansTC-Regular";
	</ label=label_begin + "啟用隨機文字顏色" + label_end, help="啟用後顯示介面裡的文字會隨機變換顏色", options="是,否", order=orderx++ /> enable_colors="否";
	</ label=label_topic, help=" ", options = " ", order=orderx++ /> paramtt6 = " "
}


local my_config = fe.get_config();
fe.layout.font = get_font_path(my_config["layout_font"]);


/////////////////////////////////////////////////////////////////////////////////
// modules
/////////////////////////////////////////////////////////////////////////////////
fe.load_module( "animate" );
fe.load_module( "conveyor" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/screen-aspects/module.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/fade-bg/module.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/pan-and-scan/module.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/modern-dialogs/module.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/simple-animate/module.nut" );


local ini_anim_time;
try { ini_anim_time =  my_config["ini_anim_trans_ms"].tointeger(); } catch ( e ) { }

// initialize wheel delay time
my_delay <- 0;
try {my_delay = my_config["set_ms_delay"].tointeger();} catch(e) {}
my_play <- my_delay;

Common();

GetScreenAspects();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;


/////////////////////////////////////////////////////////////////////////////////
// Signal Handler
/////////////////////////////////////////////////////////////////////////////////
local hsignalhandler = false;
local vsignalhandler = false;
fe.add_signal_handler( this, "on_signal" )
function on_signal( sig )
{
	switch ( sig )
	{
		case "left":
			if ( vsignalhandler == true) {
				vsignalhandler = false;
				return false;
			}
			else {
				hsignalhandler = true;
				fe.signal( "up" );
				return true;
			}
		case "right":
			if ( vsignalhandler == true) {
				vsignalhandler = false;
				return false;
			}
			else {
				hsignalhandler = true;
				fe.signal( "down" );
				return true;
			}
		case "up":
			if ( hsignalhandler == true) {
				hsignalhandler = false;
				return false;
			}
			else {
				vsignalhandler = true;
				fe.signal( "left" );
				return true;
			}
		case "down":
			if ( hsignalhandler == true) {
				hsignalhandler = false;
				return false;
			}
			else {
				vsignalhandler = true;
				fe.signal( "right" );
				return true;
			}
		default:
			return false;
	}
}


/////////////////////////////////////////////////////////////////////////////////
// load background art
/////////////////////////////////////////////////////////////////////////////////
local bg_img;

if ( my_config["select_bg_img"] == "預設背景")
	bg_img = "bg";
else if ( my_config["select_bg_img"] == "平台捉圖")
	bg_img = "screenshot";
else if ( my_config["select_bg_img"] == "平台視訊")
	bg_img = "snap";
else if ( my_config["select_bg_img"] == "玩家自製插圖")
	bg_img = "fanart";

local bg = FadeBG( bg_img, 0, 0, flw, flh, default_gameart_dir );
bg.trigger = Transition.EndNavigation;
bg.zorder = -15;

//scanline effect overlay for background art
local bg_scanline;
if ( my_config["enable_scanline"] != "停用" )
{
	local scanlines = FeConfigDirectory+"themes/HeyChromey/art/scanlines_1920.png"
	if (ScreenWidth < 1920)
		scanlines = FeConfigDirectory+"themes/HeyChromey/art/scanlines_720.png"
		
	bg_scanline = fe.add_image( scanlines, 0, 0, flw, flh );
	bg_scanline.trigger = Transition.EndNavigation;
	bg_scanline.preserve_aspect_ratio = false;

	if ( my_config["enable_scanline"] == "淡" )
		bg_scanline.alpha = 20;
	else if ( my_config["enable_scanline"] == "中" )
		bg_scanline.alpha = 80;
	else if ( my_config["enable_scanline"] == "暗" )
		bg_scanline.alpha = 150;

	bg_scanline.zorder = -14;
}

//video overlay for background art
local video_overlay;
if ( my_config["enable_videooverlay"] != "停用" )
{
	local videooverlay = FeConfigDirectory+"themes/HeyChromey/videos/bg_Aurora.mp4"
	video_overlay = fe.add_image( videooverlay, 0, 0, flw, flh );
	video_overlay.trigger = Transition.StartLayout;
	video_overlay.preserve_aspect_ratio = false;
	video_overlay.alpha = 50;
	video_overlay.zorder = -14;
}


/////////////////////////////////////////////////////////////////////////////////
// Play Background Music
/////////////////////////////////////////////////////////////////////////////////
local music = null;

function playMusic( path, loop=false ) 
{
	if (file_exist(path))
	{
		music = fe.add_sound(path);
		music.loop = loop;
		music.playing = true;
	}
	fe.add_ticks_callback( this, "music_on_tick" );
}

function music_on_tick( ttime )
{
	if ( music.playing == false )
		music.playing = true;
}

if ( my_config["enable_bgmusic"] != "停用" )
{
	playMusic(FeConfigDirectory+"themes/HeyChromey/sounds/bg.flac", false);
}



/////////////////////////////////////////////////////////////////////////////////
// art images
/////////////////////////////////////////////////////////////////////////////////
local logo_y = fly*-1.5;
local charart_x = flx*1.1;
if ( my_config["enable_ini_anim"] == "否" )
{
	logo_y = 0;
	charart_x = 0;
}

local logo = fe.add_image( "logo.png", 0, logo_y, flw, flh );
logo.zorder = -9;
if ( my_config["enable_ini_anim"] == "是" )
{
	local start_transition1 = {when = Transition.StartLayout, property = "y", start = fly*-2, end = fly*0, tween = "circle", time = ini_anim_time+800}
	animation.add( PropertyAnimation( logo, start_transition1 ) );
}


/////////////////////////////////////////////////////////////////////////////////
// Wheels background
/////////////////////////////////////////////////////////////////////////////////
local wheel_art = FadeBG( "wheel_art", 0, 0, flw, flh, default_gameart_dir );
wheel_art.trigger = Transition.EndNavigation;


/////////////////////////////////////////////////////////////////////////////////
// Wheels
/////////////////////////////////////////////////////////////////////////////////

local wheel_count = 10;
local _partially = 30;
local _alpha;
local wheel_x;
local wheel_y;
local wheel_w;
local wheel_a;
local wheel_h;
local wheel_r;
local num_arts;

#			1			2			3			4			5			6			<7>			8			9			10			11			12
wheel_x = [ -flx*0.2,	-flx*0.2,	-flx*0.2,	-flx*0.2,	flx*0.012,	flx*0.182,	flx*0.370,	flx*0.638,	flx*0.808,	flx*1.2,	flx*1.2,	flx*1.2, ]; 
wheel_y = [ fly*0.360,	fly*0.360,	fly*0.360,	fly*0.360,	fly*0.360,	fly*0.360,	fly*0.296,	fly*0.360,	fly*0.360,	fly*0.360,	fly*0.360,	fly*0.360, ];
wheel_w = [ flw*0.18,	flw*0.18,	flw*0.18,	flw*0.18,	flw*0.18,	flw*0.18,	flw*0.26,	flw*0.18,	flw*0.18,	flw*0.18,	flw*0.18,	flw*0.18, ];
wheel_h = [ flh*0.32,	flh*0.32,	flh*0.32,	flh*0.32,	flh*0.32,	flh*0.32,	flh*0.46,	flh*0.32,	flh*0.32,	flh*0.32,	flh*0.32,	flh*0.32, ];
wheel_r = [ 0,			0,			0,			0,			0,			0,			0,			0,			0,			0,			0,			0, ];

if ( my_config["wheel_semi_t"] == "是" )
#				1		2		3		4		5		<6>		7		8		9		10		11		12
	wheel_a = [ 80,		80,		80,		150,	150,	255,	150,	150,	150,	80,		80,		80, ];
else
	wheel_a = [ 255,	255,	255,	255,	255,	255,	255,	255,	255,	255,	255,	255, ];

num_arts = wheel_count;

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
};

local wheel_entries = [];
for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

local conveyor = Conveyor();
conveyor.set_slots( wheel_entries );
try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }


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
	local wheel_pulse_ani = SimpleAnimation(_time, art_pulse, wheel_pulse_aniconfig, true);
	wheel_pulse_ani.play();
	
	function pulse_transition( ttype, var, ttime )
	{
		if( ttype == Transition.ToNewSelection )
		{
			// reset pulse animation when ToNewSelection begins
			art_pulse.alpha = 0;
			wheel_pulse_ani.play();
		}
		return false;
	}
	fe.add_transition_callback( "pulse_transition" );
	
	function stop_pulse( ttime )
	{
		// if there is fadeout, pulse once only
		if( conveyor.m_objs[wheel_count/2].m_obj.alpha == 0 || conveyor.m_objs[wheel_count/2].m_obj.alpha == _partially )
		{
			wheel_pulse_ani.loop = false;
		}
	}
	fe.add_ticks_callback( "stop_pulse" );
}


/////////////////////////////////////////////////////////////////////////////////
// System games count
/////////////////////////////////////////////////////////////////////////////////
function get_platform_count(index_offset)
{
	local plat = fe.game_info( Info.Name, index_offset );
	local count = 0;
	
	if (fe.nv.GameCount.rawin(plat))
	{
		if (fe.nv.GameCount[plat].len() > 0)
		{
			foreach (key, value in fe.nv.GameCount[plat])
			{
				count = count + value;
			}
		}
	}

	local suffix = "";
	switch (plat)
	{
		case "多媒體":
			suffix = " 系統";
			break;
		default:
			suffix = " 遊戲";
			break;
	}

	if (count > 0) return count + suffix;
	return "";
}


/////////////////////////////////////////////////////////////////////////////////
// info bar
/////////////////////////////////////////////////////////////////////////////////
local title_font_size = flh*0.048;
local default_font_size = flh*0.024;
local x_title = flx*0.001;
local x_itemcount = flx*0.7;
local r = 255;
local g = 255;
local b = 255;

function get_platform_title(index_offset)
{
	return fe.game_info( Info.Name, index_offset );;
}

// system title
local title = fe.add_text(get_platform_title(0), x_title, fly*0.80, flw, flh*0.062);
title.align = Align.Centre;
title.charsize = title_font_size;
title.outline = 4;

// game count
local gamecount = fe.add_text(get_platform_count(0), x_title, fly*0.85, flw, flh*0.062);
gamecount.align = Align.Centre;
gamecount.charsize = default_font_size;
gamecount.outline = 3;
gamecount.set_rgb(255,255,0);

// Info Transitions
function text_transitions( ttype, var, ttime ) {
	switch ( ttype )
	{
		case Transition.ToNewSelection:
			title.msg = get_platform_title(var);
			gamecount.msg = get_platform_count(var);
			break;
	}
	return false;
}
fe.add_transition_callback( "text_transitions" );


/////////////////////////////////////////////////////////////////////////////////
// Controller info Surface
/////////////////////////////////////////////////////////////////////////////////
local controllerinfo_surface = fe.add_surface( flw, flh );

local controllerinfo_frame = controllerinfo_surface.add_image( FeConfigDirectory+"themes/HeyChromey/art/frame.png", 0, fly*0.92, flw, flh*0.09 );
controllerinfo_frame.alpha = 180;

local joystick_surface = controllerinfo_surface.add_surface( flw, flh );
local joystick_lr = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/joystick_lr.png", flx/2-(flh*0.05*7), fly*0.94, flh*0.05, flh*0.05);
local joystick_lr_text = joystick_surface.add_text("選擇", joystick_lr.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
joystick_lr_text.align = Align.Left;
joystick_lr_text.charsize = default_font_size;
joystick_lr_text.outline = 3;

local joystick_ud = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/joystick_ud.png", flx/2-(flh*0.05*4), fly*0.94, flh*0.05, flh*0.05);
local joystick_ud_text = joystick_surface.add_text("翻頁", joystick_ud.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
joystick_ud_text.align = Align.Left;
joystick_ud_text.charsize = default_font_size;
joystick_ud_text.outline = 3;

local joystick_a = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_a.png", flx/2-(flh*0.05*1), fly*0.94, flh*0.05, flh*0.05);
local joystick_a_text = joystick_surface.add_text("確定", joystick_a.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
joystick_a_text.align = Align.Left;
joystick_a_text.charsize = default_font_size;
joystick_a_text.outline = 3;

local joystick_b = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_b.png", flx/2+(flh*0.05*2), fly*0.94, flh*0.05, flh*0.05);
local joystick_b_text = joystick_surface.add_text("返回", joystick_b.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
joystick_b_text.align = Align.Left;
joystick_b_text.charsize = default_font_size;
joystick_b_text.outline = 3;

local joystick_start = joystick_surface.add_image(FeConfigDirectory + "themes/HeyChromey/art/joystick/button_start.png", flx/2+(flh*0.05*5), fly*0.94, flh*0.05, flh*0.05);
local joystick_start_text = joystick_surface.add_text("選單", joystick_start.x+flh*0.05, fly*0.94, flw*0.046, flh*0.05);
joystick_start_text.align = Align.Left;
joystick_start_text.charsize = default_font_size;
joystick_start_text.outline = 3;

local itemcount = controllerinfo_surface.add_text( "項目: [ListEntry] / [ListSize]", x_itemcount, fly*0.94, flw*0.3, flh*0.05 );
itemcount.align = Align.Right;
itemcount.charsize = default_font_size;
itemcount.outline = 3;
itemcount.alpha = 220;

local animation_cfg;
switch (my_config["enable_ini_anim"])
{
	case "否":
		animation_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255, time = (ini_anim_time*2)}
		animation.add( PropertyAnimation( title, animation_cfg ) );
		animation.add( PropertyAnimation( gamecount, animation_cfg ) );
		animation.add( PropertyAnimation( itemcount, animation_cfg ) );
		animation.add( PropertyAnimation( controllerinfo_frame, animation_cfg ) );
		break;
	case "是":
		animation_cfg = {when = Transition.StartLayout, property = "alpha", start = 0, end = 255, time = (ini_anim_time*2)}
		animation.add( PropertyAnimation( title, animation_cfg ) );
		animation.add( PropertyAnimation( gamecount, animation_cfg ) );
		animation_cfg = {when = Transition.StartLayout, property = "x", start = flx*2, end = x_itemcount, time = (ini_anim_time+350)}
		animation.add( PropertyAnimation( itemcount, animation_cfg ) );
		animation_cfg = {when = Transition.StartLayout, property = "y", start = fly*1.5, end = fly*0.92, time = (ini_anim_time*1.1)}
		animation.add( PropertyAnimation( controllerinfo_frame, animation_cfg ) );
		animation_cfg = {when = Transition.StartLayout, property = "y", start = fly*1.5, end = 0, time = (ini_anim_time*1.1)}
		break;
}

animation.add( PropertyAnimation( joystick_surface, animation_cfg ) );


// Random color for info text
if ( my_config["enable_colors"] == "是" )
{
	function brightrand() {
		return 255-(rand()/255);
	}

	local red = brightrand();
	local green = brightrand();
	local blue = brightrand();

	// Color Transitions
	fe.add_transition_callback( "color_transitions" );
	function color_transitions( ttype, var, ttime ) {
		switch ( ttype )
		{
			case Transition.StartLayout:
			case Transition.ToNewSelection:
				red = brightrand();
				green = brightrand();
				blue = brightrand();
				if(title!="")
					title.set_rgb(red,green,blue);
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
				if(joystick_start_text!="")
					joystick_start_text.set_rgb(red,green,blue);
				break;
		}
		return false;
	}
}


/////////////////////////////////////////////////////////////////////////////////
// Modern Dialogs
/////////////////////////////////////////////////////////////////////////////////
local md = ModernDialogs();
md.titlefont = get_font_path(my_config["layout_font"]);
md.listfont = get_font_path(my_config["menu_font"]);

md.enable_add_favourite = false;
md.enable_add_tags = false

md.title_add_favourite = "加入最愛";
md.title_remove_favourite = "移除最愛";
md.title_displays_menu = "顯示介面";
md.title_displays_exit = "離開 ATTRACT-MODE?";
md.title_filters_menu = "遊戲分類";
md.title_add_tags = "分類標籤";
md.title_exit = "電源選項";
md.title_opts_menu = "快捷選單";
md.opt_configure = "程式設定";
md.opt_layout_options = "畫面佈局設定";
md.opt_exit_to_desktop = "離開程式";
md.opt_back = "返回";
md.opt_exit = "離開 Attract-Mode";
md.enable_filtersmenu = false;
md.filters_gameregion_type = default_gameregion_type;
md.filters_gamecategory_type = default_gamecategory_type;
md.filters_gameregion = "遊戲區域";
md.filters_gamecategory = "遊戲類型";
md.filters_favourite = "我的最愛";

