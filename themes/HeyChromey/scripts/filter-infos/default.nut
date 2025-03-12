function GetGameCategoryDefault( index_offset )
{
	local s = fe.game_info( Info.Category, index_offset );
	
	if ( ( s.find("Action") != null || s.find("Platform") != null || s.find("Beat'em Up") != null) &&
		   s.find("Role-Playing Game") == null && s.find("Role playing games") == null && s.find("Shoot'em Up") == null && s.find("Action-Fight") == null &&
		   s.find("Fight-Action") == null)
	{
		return "[動作遊戲]";
	}
	else if ( s.find("Fighting Game") != null || s.find("Fight") != null)
	{
		return "[格鬥遊戲]";
	}
	else if ( s.find("Adventure") != null)
	{
		return "[冒險遊戲]";
	}
	else if ( s.find("Puzzle-Game") != null || s.find("Pinball") != null || s.find("Quiz") != null || s.find("Puzzle") != null || s.find("Maze") != null ||
			  s.find("Ball & Paddle") != null )
	{
		return "[益智遊戲]";
	}
	else if ( s.find("Race, Driving") != null || s.find("Driving / Race") != null)
	{
		return "[競速遊戲]";
	}
	else if ( ( s.find("Role-Playing Game") != null || s.find("Role playing games") != null) &&
			    s.find("Shoot'em Up") == null)
	{
		if ( s.find("Strategy Role-Playing Game") != null || s.find("Strategy-Role playing games") != null ) {
			return "[戰略角色扮演]";
		}
		else if ( s.find("Action Role-Playing Game") != null ) {
			return "[動作角色扮演]";
		}
		return "[角色扮演]";
	}
	else if ( s.find("Shooter") != null  || s.find("Shoot'em Up") != null )
	{
		if ( s.find("First-Person Shooter") != null ) {
			return "[第一人稱射擊遊戲]";
		}
		else if ( s.find("Third-Person Shooter") != null ) {
			return "[第三人稱射擊遊戲]";
		}
		else if ( s.find("Lightgun Shooter") != null ) {
			return "[光槍射擊遊戲]";
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
	else if ( s.find("Tabletop-Game") != null || s.find("Asiatic board game") != null || s.find("Board game") != null || s.find("Tabletop") != null)
	{
		return "[桌上遊戲]";
	}
	else if ( s.find("Casino") != null)
	{
		return "[博弈遊戲]";
	}
	else if ( s.find("Compilation") != null)
	{
		return "[合輯遊戲]";
	}
	else if ( s.find("Educational") != null)
	{
		return "[教育遊戲]";
	}
	else
	{
		return "[其它遊戲]";
	}
	return "[" + s + "]";
}