function GetGameCategoryArcade( index_offset )
{
	local s = fe.game_info( Info.Category, index_offset );
	
	if ( s.find("Fighter / Versus") != null || s.find("Fighter / Versus Co-op") != null || s.find("Fighter / Multiplay") != null || s.find("Fighter / Compilation") != null ||
		 s.find("Fight / Versus-Fight") != null || s.find("Fight / 3D-Fight") != null)
	{
		return "[格鬥遊戲]";
	}
	else if ( s.find("Fighter") != null || s.find("Fight") != null || s.find("Beat'em Up") != null)
	{
			return "[動作打擊]";
	}
	else if ( s.find("Platform") != null )
	{
		return "[平台遊戲]";
	}
	else if ( s.find("Shooter / Flying") != null )
	{
		return "[空戰遊戲]";
	}
	else if ( s.find("Shooter / Gun") != null )
	{
		return "[光槍遊戲]";
	}
	else if ( s.find("Shooter") != null || s.find("Shoot'em Up") != null)
	{
		return "[射擊遊戲]";
	}
	else if ( s.find("Sports") != null )
	{
		return "[運動遊戲]";
	}
	else if ( s.find("Ball & Paddle") != null || s.find("Breakout") != null)
	{
		return "[敲磚遊戲]";
	}
	else if ( s.find("Casino") != null )
	{
		return "[博弈遊戲]";
	}
	else if ( s.find("Driving") != null || s.find("Biking") != null || s.find("Motorcycle") != null )
	{
		return "[競速遊戲]";
	}
	else if ( s.find("Mature") != null )
	{
		return "[成人遊戲]";
	}
	else if ( s.find("Maze") != null )
	{
		return "[解謎遊戲]";
	}
	else if ( s.find("Mini-Games") != null )
	{
		return "[迷你遊戲]";
	}
	else if ( s.find("Pinball") != null )
	{
		return "[彈珠台遊戲]";
	}
	else if ( s.find("Puzzle") != null )
	{
		return "[益智遊戲]";
	}
	else if ( s.find("Rhythm") != null )
	{
		return "[節奏遊戲]";
	}
	else if ( s.find("Tabletop") != null )
	{
		return "[桌上遊戲]";
	}
	else if ( s.find("Medal Game") != null )
	{
		return "[推幣遊戲]";
	}
	else if ( s.len() ==0 )
	{
		return "";
	}
	return "[" + s + "]";
}