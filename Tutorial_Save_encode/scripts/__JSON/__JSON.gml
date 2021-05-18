#macro	savefile_json	"savegame.json"

/// @function	savegame_json()
function savegame_json() {
	// Open or create the json file if does not exists
	var _file = file_text_open_write(savefile_json);
	
	// Create a ds_map to save the game
	var _map = ds_map_create();
	
	// Save our information	
	_map[? "SCORE"] = score;
	
	// Save balloons information
	var _balloons_qty = instance_number(o_Balloon);
	var _map_balloons = ds_map_create();
	
	for (var i = 0; i < _balloons_qty; i++) {
		// Iterate on every balloon instance
		var _balloon = instance_find(o_Balloon, i);
		
		_map_balloons[? string(_balloon.id)] = {
			x : _balloon.x,
			y : _balloon.y,
			depth : _balloon.depth,
			image_index : _balloon.image_index,
			text : _balloon.text
		}
	}
	
	ds_map_add_map(_map, "BALLOONS", _map_balloons);
	
	// Encode map to string
	var _json_str = json_encode(_map);
	
	// Encode string to base64
	var _b64_str = base64_encode(_json_str);
	
	// Write & close jsonfile
	file_text_write_string(_file, _b64_str);
	file_text_close(_file);
}

/// @function	loadgame_json()
function loadgame_json() {
	// Don't do anything if file is not found
	if !(file_exists(savefile_json)) {
		show_message("No file found.");
		exit;
	}
	
	// Open json to read
	var _file = file_text_open_read(savefile_json);
	
	// Decode file into a string
	var _b64_str = file_text_read_string(_file);
	var _json_str = base64_decode(_b64_str);
	var _map = json_decode(_json_str);
	
	// Load information
	score = _map[? "SCORE"];
	
	var _map_balloons = _map[? "BALLOONS"];
	var _balloon_count = ds_map_size(_map_balloons);
	var _key = ds_map_find_first(_map_balloons);
	var _this_balloon = _map_balloons[? _key];
	
	for (var i = 0; i < _balloon_count; i++) {
		var _balloon = instance_create_depth(0, 0, -10, o_Balloon);
		
		_balloon.x = _this_balloon[? "x"];
		_balloon.y = _this_balloon[? "y"];
		_balloon.depth = _this_balloon[? "depth"];
		_balloon.image_index = _this_balloon[? "image_index"];
		_balloon.text = _this_balloon[? "text"];
		
		// Serach for next key
		_key = ds_map_find_next(_map_balloons, _key);
		_this_balloon = _map_balloons[? _key];
	}
	
	// Close File
	file_text_close(_file);
	
	show_message("Game loaded.");
}