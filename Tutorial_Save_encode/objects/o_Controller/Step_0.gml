/// @description Control system

// Create a random balloon
if (mouse_check_button_pressed(mb_left)) {
	instance_create_depth(mouse_x, mouse_y, -10, o_Balloon);
}

// Savegame
if (keyboard_check_pressed(ord("S"))) {
	//savegame_ini();
	savegame_json();
	show_message("Game saved!");
}

// Loadgame
if (keyboard_check_pressed(ord("L"))) {
	// Delete all balloons first
	with (o_Balloon) {
		instance_destroy();	
	}
	
	//loadgame_ini();
	loadgame_json();
}