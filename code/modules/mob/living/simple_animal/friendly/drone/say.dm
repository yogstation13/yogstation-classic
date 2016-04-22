
/////////////
//DRONE SAY//
/////////////
//Drone speach
//Drone hearing


/mob/living/simple_animal/drone/say(message)
	return ..(message, "R")


/mob/living/simple_animal/drone/handle_inherent_channels(message, message_mode)
	if(message_mode == MODE_BINARY)
		drone_chat(message)
		return ITALICS | REDUCE_RANGE
	else
		..()


/mob/living/simple_animal/drone/proc/alert_drones(msg, dead_can_hear = 0)
	for(var/mob/M in player_list)
		var/send_msg = 0

		if(istype(M, /mob/living/simple_animal/drone) && M.stat != DEAD)
			for(var/F in src.faction)
				if(F in M.faction)
					send_msg = 1
					break
		else if(dead_can_hear && (M in dead_mob_list))
			send_msg = 1

		if(send_msg)
			M << msg


/mob/living/simple_animal/drone/proc/drone_chat(msg)
	log_say("[key_name(src)] : [msg]")
	say_log_silent += "Drone Chat: [msg]"
	var/rendered = "<i><span class='game say'>DRONE CHAT: <span class='name'>[name]</span>: [msg]</span></i>"
	alert_drones(rendered, 1)