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
	move(o_solid);													
	
	break;
#endregion
#region Grab State
	case player.ledge_grab:
	
	break;
#endregion
#region Door State
	case player.door:
	
	break;
#endregion
#region Hurt State
	case player.hurt:
	
	break;
#endregion
#region Death State
	case player.death:
	
	break;
#endregion
}
#endregion
