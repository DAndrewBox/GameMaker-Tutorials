#macro	savefile	"savegame.ini"

/// @function	savegame_ini()
function savegame_ini() {
	// Open or create the ini file if does not exists
	ini_open(savefile);
	
	// Save our information	
	ini_write_real("OTHER", "SCORE", score);
	
	// Save balloons information
	var _balloons_qty = instance_number(o_Balloon);
	ini_write_real("OTHER", "BALLOON_COUNT", _balloons_qty);
	
	for (var i = 0; i < _balloons_qty; i++) {
		// Iterate on every balloon instance
		var _balloon = instance_find(o_Balloon, i);
		
		ini_write_real("BALLOON_" + string(i), "X", _balloon.x);
		ini_write_real("BALLOON_" + string(i), "Y", _balloon.y);
		ini_write_real("BALLOON_" + string(i), "DEPTH", _balloon.depth);
		ini_write_real("BALLOON_" + string(i), "INDEX", _balloon.image_index);
		ini_write_string("BALLOON_" + string(i), "TEXT", _balloon.text);
	}
	
	// Close ini file
	ini_close();
}

/// @function	loadgame_ini()
function loadgame_ini() {
	// Don't do anything if file is not found
	if !(file_exists(savefile)) {
		show_message("No file found.");
		exit;
	}
	
	// Open ini to read
	ini_open(savefile);
	
	// Load information
	score = ini_read_real("OTHER", "SCORE", 0);
	var _balloon_count = ini_read_real("OTHER", "BALLOON_COUNT", 0);
	
	for (var i = 0; i < _balloon_count; i++) {
		var _balloon = instance_create_depth(0, 0, -10, o_Balloon);
		
		_balloon.x = ini_read_real("BALLOON_" + string(i), "X", 0);
		_balloon.y = ini_read_real("BALLOON_" + string(i), "Y", 0);
		_balloon.depth = ini_read_real("BALLOON_" + string(i), "DEPTH", 0);
		_balloon.image_index = ini_read_real("BALLOON_" + string(i), "INDEX", 0);
		_balloon.text = ini_read_string("BALLOON_" + string(i), "TEXT", 0);
	}
	
	ini_close();
	
	show_message("Game loaded.");
}