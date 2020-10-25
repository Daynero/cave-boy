 /// @description Controlling the player state

#region Set up controls for the player
right = keyboard_check(vk_right);
left = keyboard_check(vk_left);
up = keyboard_check(vk_up);
down = keyboard_check(vk_down);
up_release = keyboard_check_released(vk_up);	
#endregion

#region State Machine
switch (state) {
#region Move State
	case player.moving:
	if (xspeed == 0) {
		sprite_index = s_player_idle;	
	} else {
		sprite_index = s_player_walk;	
	}
	// Check if player on the ground
	if (!place_meeting(x, y + 1, o_solid)) {
		yspeed += gravity_acceleration;	
		
		// Player in the air
		sprite_index = s_player_jump;
		image_index = (yspeed > 0);
		
		//Controll the jump height
		if (up_release && yspeed < -6) {
			yspeed = -3;	
		}
		
	} else {
		yspeed = 0;	
		
		// Jumping code
		if (up) {
			audio_play_sound(a_jump, 5, false);
			yspeed = jump_height;	
		}
	}
	// Change direction sprite
	if (xspeed != 0) {
		image_xscale = sign(xspeed);	
	}
	// Check right or left moving
	if (right || left) {
		xspeed += (right - left) * acceleration;
		xspeed = clamp(xspeed, -max_speed, max_speed);
	} else {
		apply_friction(acceleration);	
	}
	if (place_meeting(x, y + yspeed + 1, o_solid) && yspeed > 0) {
		audio_play_sound(a_step, 6, false);	
	}
	
	move(o_solid);	
	
	// Check for ledge grab state
	var falling = y - yprevious > 0;
	var wasnt_wall = !position_meeting(x + grab_width * image_xscale, yprevious, o_solid);
	var is_wall = position_meeting(x  +grab_width * image_xscale, y, o_solid);
	
	if (falling && wasnt_wall && is_wall) {
		xspeed = 0;
		yspeed = 0;
		
		// Move against the ledge
		while (!place_meeting(x + image_xscale, y, o_solid)) {
			x += image_xscale;	
		}
		
		// Check vertical position 
		while (position_meeting(x + grab_width * image_xscale, y - 1, o_solid)) {
			y -= 1;	
		}
		
		// Change sprite and state
		sprite_index = s_player_ledge_grab;
		state = player.ledge_grab;
		
		audio_play_sound(a_step, 6, false);
	}
	
	break;
#endregion
#region Grab State
	case player.ledge_grab:
		if (down) {
			state = player.moving;	
		}
		if (up) {
			state = player.moving;
			yspeed = jump_height;
		}
	break;
#endregion
#region Door State
	case player.door:
		sprite_index = s_player_exit;
		// Fade out
		if (image_alpha > 0) {
			image_alpha -= 0.05;	
		} else {
			room_goto(r_two);
		}
		break;
#endregion
#region Hurt State
	case player.hurt:
		sprite_index = s_player_hurt;
		// Change direction as we fly around
		if (xspeed != 0) {
			image_xscale = sign(xspeed);
		}
		if (!place_meeting(x, y + 1, o_solid)) {
			yspeed += gravity_acceleration;	
		} else {
			yspeed = 0;
			apply_friction(acceleration); 
		}
		direction_move_bounce(o_solid);
		
		// Change back to another states
		if (xspeed == 0) && (yspeed == 0) {
			if (o_player_stats.hp == 0) {
				state = player.death;	
			} else {
				image_blend = c_white;
				state = player.moving;	
			}
		}
		break;
#endregion
#region Death State
	case player.death:
		with (o_player_stats) {
			hp = max_hp;
			saphires = 0;
		}
		
		room_restart();
	break;
#endregion
}
#endregion
