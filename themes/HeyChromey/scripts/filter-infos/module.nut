filter_gameregion_infos <-
{
	["Default"] = ["全部", "日版", "美版", "歐版", "其它", "日版/美版"],
	["Single"] = ["全部"],
	["JapOnly"] = ["全部"],
	["JAPExclude"] = ["全部", "美版", "歐版", "其它"],
	["MAME"] = ["全部", "主遊戲", "衍生遊戲"],
};


filter_gamecategory_infos <-
{
	["Default"] = ["全部遊戲", "動作遊戲", "冒險遊戲", "益智遊戲", "競速遊戲", "角色扮演", "射擊遊戲", "戰略模擬", "運動遊戲", "其它遊戲"],
	["AllGamesOnly"] = ["全部遊戲"],
	["MS-DOS"] = ["全部遊戲", "動作遊戲", "格鬥遊戲", "冒險遊戲", "益智遊戲", "競速遊戲", "角色扮演", "射擊遊戲", "槍戰射擊", "戰略模擬", "模擬經營", "即時戰略", "運動遊戲", "桌上遊戲", "其它遊戲"],
	["Windows"] = ["全部遊戲", "動作遊戲", "格鬥遊戲", "冒險遊戲", "益智遊戲", "競速遊戲", "角色扮演", "射擊遊戲", "槍戰射擊", "戰略模擬", "模擬經營", "即時戰略", "運動遊戲", "桌上遊戲", "其它遊戲"],
	["MAME"] = ["全部遊戲", "格鬥遊戲", "動作打擊", "平台遊戲", "空戰遊戲", "光槍遊戲", "射擊遊戲", "運動遊戲", "敲磚遊戲", "博弈遊戲", "競速遊戲", "成人遊戲", "解謎遊戲", "迷你遊戲", "彈珠台遊戲", "益智遊戲", "節奏遊戲", "桌上遊戲", "推幣遊戲", "其它遊戲"],
};


///////////////////////////////////////////////////////////////////////////////////////
// Get Game Category
///////////////////////////////////////////////////////////////////////////////////////
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/filter-infos/default.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/filter-infos/msdos.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/filter-infos/windows.nut" );
fe.do_nut( FeConfigDirectory + "themes/HeyChromey/scripts/filter-infos/arcade.nut" );


function GetGameCategory(index_offset, filters_gamecategory_type) {
	local result = ""
	switch ( filters_gamecategory_type )
	{
		case "MS-DOS":
			result = GetGameCategoryMSDOS(index_offset);
			break;
		case "Windows":
			result = GetGameCategoryWindows(index_offset);
			break;
		case "MAME":
			result = GetGameCategoryArcade(index_offset);
			break;
		default:
			result = GetGameCategoryDefault(index_offset);
			break
	}
	return result;
}