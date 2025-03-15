class Common
{
	constructor()
	{
		if (!fe.nv.rawin("GameCount"))
		{
			fe.nv["GameCount"] <- {
				"街機平台" : {},
				"家用機平台" : {},
				"掌機平台" : {},
				"電腦平台" : {},
				"遊戲合集" : {},
				"多媒體" : {}
			};
		}
		
	}
}


///////////////////////////////////////////////////////////////////////////////////////
// Get Region List
///////////////////////////////////////////////////////////////////////////////////////

function GetRegionList(filters_gameregion_type) {

	return filter_gameregion_infos[filters_gameregion_type];
}


///////////////////////////////////////////////////////////////////////////////////////
// Get Category List
///////////////////////////////////////////////////////////////////////////////////////

function GetCategoryList(filters_gamecategory_type) {
	return filter_gamecategory_infos[filters_gamecategory_type];
}

///////////////////////////////////////////////////////////////////////////////////////
// Get Filter Index
///////////////////////////////////////////////////////////////////////////////////////

function GetFilterIndex(filters_gameregion_type, filters_current_gameregion, filters_gamecategory_type, filters_current_gamecategory) {
	local filterIndex = -1;
	if (get_tb_valueindex(filter_gameregion_infos, filters_gameregion_type, filters_current_gameregion) >= 0)
	{
		local multipleValue = get_tb_valueindex(filter_gameregion_infos, filters_gameregion_type, filters_current_gameregion);
		local plusValue = filter_gamecategory_infos[filters_gamecategory_type].len();
		
		local gameCategoryIndex = get_tb_valueindex(filter_gamecategory_infos, filters_gamecategory_type, filters_current_gamecategory);
		
		if (multipleValue > 0)
		{
			filterIndex = gameCategoryIndex + (plusValue * multipleValue);
		}
		else
		{
			filterIndex = gameCategoryIndex;
		}
	}
	return filterIndex;
}


//get value index in a table
function get_tb_valueindex(tb, key, value){
	local i = -1;

	foreach( val in tb[key] ){
		i++;
		if(val == value) return i
	}
	return -1;
}


// return directory listing
function get_dir_lists(path)
{
	local files = {};
	local temp = DirectoryListing( path, false );
	foreach ( t in temp.results )
	{
		local temp = strip_ext( t );
		files[temp] <- path + "/" + t;
	}
	return files;
}

//Check if file exist
function file_exist(path)
{
	try { file(path, "r" ); return true; }
	catch( e ){ return false; }
}

//Check if directory exist
function directory_exist(path)
{
	return fe.path_test(path, PathTest.IsDirectory);
}

//make directory
function mk_dir_callback(tt)
{
	print( "Running command: mkdir\n" );
}

function mk_dir(path)
{
	fe.plugin_command("cmd", " /c md " + path, mk_dir_callback)
}

//Round Number as decimal
function round(nbr, dec){
	local f = pow(10, dec) * 1.0;
	local newNbr = nbr * f;
	newNbr = floor(newNbr + 0.5)
	newNbr = (newNbr * 1.0) / f;
	return newNbr;
}

//Generate a pseudo-random integer between 0 and max
function rndint(max) {
	local roll = 1.0 * max * rand() / RAND_MAX;
	return roll.tointeger();
}

//get random index in a table
function get_random_table(tb){
	local i=0;
	local sel = rand()%tb.len();
	foreach( key, val in tb ){
		if(i == sel) return val
		i++;
	}
	return "";
}

//Select Random file in a folder
function get_random_file(dir){
	local fname = "";
	local tmp = zip_get_dir( dir );
	if( tmp.len() > 0 ) fname = dir + "/" + tmp[ rand()%tmp.len() ];
	return fname;
}

//Replace text in a string
function replace (string, original, replacement)
{
  local expression = regexp(original);
  local result = "";
  local position = 0;
  local captures = expression.capture(string);
  while (captures != null)
  {
	foreach (i, capture in captures)
	{
	  result += string.slice(position, capture.begin);
	  result += replacement;
	  position = capture.end;
	}
	captures = expression.capture(string, position);
  }
  result += string.slice(position);
  return result;
}

//Return file ext
function ext( name )
{
	local s = split( name, "." );
	if ( s.len() <= 1 )
		return "";
	else
		return s[s.len()-1];
}

//Return filename without ext
function strip_ext( name )
{
	local s = split( name, "." );
	if ( s.len() == 1 )
		return name;
	else
	{
		local retval;
		retval = s[0];
		for ( local i=1; i<s.len()-1; i++ ) retval = retval + "." + s[i];
		return retval;
	}
}

// return full font path
function get_font_path(fontname)
{
	local path = FeConfigDirectory + "fonts/" + fontname + ".otf";
	
	if (file_exist(path))
	{
		return path;
	}
	else
	{
		path = FeConfigDirectory + "fonts/" + fontname + ".ttf";
		if (file_exist(path)) return path;
	}
	return fontname;
}
