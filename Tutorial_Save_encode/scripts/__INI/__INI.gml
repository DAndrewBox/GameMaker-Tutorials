#macro	savefile_ini	"savegame.ini"

/// @function	savegame_ini()
function savegame_ini() {
	// Open or create the ini file if does not exists
	ini_open(savefile_ini);
	
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
	
	// Encode ini to base 64
	encode_ini();
}

/// @function	loadgame_ini()
function loadgame_ini() {
	// Don't do anything if file is not found
	if !(file_exists(savefile_ini)) {
		show_message("No file found.");
		exit;
	}
	
	// Decode the file first
	decode_ini();
	
	// Open ini to read
	ini_open(savefile_ini);
	
	// Load information
	score = ini_read_real("OTHER", "SCORE", 0);
	var _balloon_count = ini_read_real("OTHER", "BALLOON_COUNT", 0);
	
	for (var i = 0; i < _balloon_count; i++) {
		var _balloon = instance_create_depth(0, 0, -10, o_Balloon);
		
		_balloon.x = ini_read_real("BALLOON_" + string(i), "X", 0);
		_balloon.y = ini_read_real("BALLOON_" + string(i), "Y", 0);
		_balloon.depth = ini_read_real("BALLOON_" + string(i), "DEPTH", 0);
		_balloon.image_index = ini_read_real("BALLOON_" + string(i), "INDEX", 0);
		_balloon.text = ini_read_string("BALLOON_" + string(i), "TEXT", "");
	}
	
	ini_close();
	
	// OPTIONAL: Encode file again to prevent people looking variables after loading file
	encode_ini();
	
	show_message("Game loaded.");
}
	
/// @function encode_ini()
function encode_ini() {
	// Open file to read
	var _file = file_text_open_read(savefile_ini);
	var _ini_str = "";
	
	// Read first line
	var _next_str = file_text_readln(_file);
	
	// While there's some sort of line below, add data to encode later
	while (string_length(_next_str) > 1) {
		_ini_str += _next_str;
		_next_str = file_text_readln(_file);
	}
	
	// Close the file
	file_text_close(_file);
	
	// Encode string to base64
	var _b64_str = base64_encode(_ini_str);
	
	// Open file to write
	_file = file_text_open_write(savefile_ini);
	file_text_write_string(_file, _b64_str);
	
	// Close the file again
	file_text_close(_file);
}
	
/// @function decode_ini()
function decode_ini() {
	// Open file to read and decode
	var _file = file_text_open_read(savefile_ini);
	var _b64_str = file_text_read_string(_file);
	var _ini_str = base64_decode(_b64_str);
	
	// Close file to open write
	file_text_close(_file);
	
	// Open file to write ini string
	_file = file_text_open_write(savefile_ini);
	file_text_write_string(_file, _ini_str);
	
	// Close the file
	file_text_close(_file);
}