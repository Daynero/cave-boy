/// @description Begin the game
if (room == r_title) && (keyboard_check(vk_space)) {
	room_goto(r_one);
	audio_stop_sound(a_title);
	audio_play_sound(a_cave, 10, true);
}


//Change music if on the main screen for too long
if (!audio_is_playing(a_title)) && (!audio_is_playing(a_cave)) {
	audio_play_sound(a_cave, 10, true);	
}
