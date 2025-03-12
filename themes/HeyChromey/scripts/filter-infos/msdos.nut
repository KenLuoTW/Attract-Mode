function GetGameCategoryMSDOS( index_offset )
{
	local s = fe.game_info( Info.Category, index_offset );

	if ( (s.find("Action") != null || s.find("Platform") != null) && s.find("Role-Playing Game") == null )
	{
		return "[動作遊戲]";
	}
	else if ( s.find("Fighting Game") != null )
	{
		return "[格鬥遊戲]";
	}
	else if ( s.find("Adventure") != null)
	{
		if ( s.find("Fighter / Asian 3D") == null && s.find("Fighter / Compilation") == null && s.find("Fighter / Multiplay") == null && s.find("Fighter / Versus") == null && s.find("Fighter / Versus Co-op") == null )
			return "[冒險遊戲]";
	}
	else if ( s.find("Puzzle-Game") != null  || s.find("Pinball") != null )
	{
		return "[益智遊戲]";
	}
	else if ( s.find("Racing-Game") != null  || s.find("Race, Driving") != null || s.find("Racing") != null)
	{
		return "[競速遊戲]";
	}
	else if ( s.find("Role-Playing Game") != null )
	{
		if ( s.find("Strategy Role-Playing Game") != null ) {
			return "[戰略角色扮演]";
		}
		else if ( s.find("Action Role-Playing Game") != null ) {
			return "[動作角色扮演]";
		}
		return "[角色扮演]";
	}
	else if ( s.find("Shooter") != null  || s.find("Shoot'em Up") != null  || s.find("Lightgun Shooter") != null )
	{
		if ( s.find("First-Person Shooter") != null ) {
			return "[第一人稱射擊遊戲]";
		}
		else if ( s.find("Third-Person Shooter") != null ) {
			return "[第三人稱射擊遊戲]";
		}
		return "[射擊遊戲]";
	}
	else if ( s.find("Simulation") != null )
	{
		return "[模擬經營]";
	}
	else if ( s.find("Strategy") != null )
	{
		if ( s.find("Real-time Strategy") != null ) {
			return "[即時戰略]";
		}
		return "[戰略模擬]";
	}
	else if ( s.find("Sports") != null )
	{
		return "[運動遊戲]";
	}
	else if ( s.find("Tabletop-Game") != null )
	{
		return "[桌上遊戲]";
	}
	else
	{
		return "[其它遊戲]";
	}
	return "[" + s + "]";
}