#define CHALLENGE_TC_PER_PLAYER 5.6
#define CHALLENGE_TIME_LIMIT 4800 //8 minutes, which equates to 5 minutes after round start since round starts at 12:03 to actually give nukeops 5 minutes
#define CHALLENGE_MIN_PLAYERS 25
#define CHALLENGE_SHUTTLE_DELAY 15000 // 25 minutes, so the ops have at least 5 minutes before the shuttle is callable.

/obj/item/device/nuclear_challenge
	name = "Declaration of War (Challenge Mode)"
	icon_state = "gangtool-red"
	item_state = "walkietalkie"
	desc = "Use to send a declaration of hostilities to the target, delaying your shuttle departure for 20 minutes while they prepare for your assault.  \
			Such a brazen move will attract the attention of powerful benefactors within the Syndicate, who will supply your team with a massive amount of bonus telecrystals.  \
			Must be used within five minutes, or your benefactors will lose interest."

/obj/item/device/nuclear_challenge/attack_self(mob/living/user)
	if(player_list.len < CHALLENGE_MIN_PLAYERS)
		user << "The enemy crew is too small to be worth declaring war on."
		return
	if(user.z != ZLEVEL_CENTCOM)
		user << "You have to be at your base to use this."
		return

	if(world.time > CHALLENGE_TIME_LIMIT)
		user << "It's too late to declare hostilities. Your benefactors are already busy with other schemes. You'll have to make  do with what you have on hand."
		return

	var/are_you_sure = alert(user, "Consult your team carefully before you declare war on [station_name()]]. Are you sure you want to alert the enemy crew? You will receive [round(CHALLENGE_TC_PER_PLAYER*player_list.len)] bonus Telecrystals for declaring War.", "Declare war?", "Yes", "No")
	if(are_you_sure == "No")
		user << "On second thought, the element of surprise isn't so bad after all."
		return

	var/war_declaration = "[user.real_name] has declared his intent to utterly destroy [station_name()] with a nuclear device, and dares the crew to try and stop them."
	priority_announce(war_declaration, title = "Declaration of War", sound = 'sound/machines/Alarm.ogg')
	user << "You've attracted the attention of powerful forces within the syndicate. A bonus bundle of telecrystals has been granted to your team. Great things await you if you complete the mission."

	for(var/obj/machinery/computer/shuttle/syndicate/S in machines)
		S.challenge = TRUE
		S.challenge_time = world.time
//	for(var/obj/machinery/gun_turret/syndicate/S in machines)  //// Un-comment this to make gun_turret/syndicate only activated during Nuclear_Challenge
//		S.enabled = 1

	var/obj/item/device/radio/uplink/U = new(get_turf(user))
	U.hidden_uplink.uplink_owner = "[user.key]"
	U.hidden_uplink.uses = round(CHALLENGE_TC_PER_PLAYER*player_list.len)
	config.shuttle_refuel_delay = max(config.shuttle_refuel_delay, CHALLENGE_SHUTTLE_DELAY+world.time) //Adds delay when item used
	qdel(src)


#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_TIME_LIMIT
#undef CHALLENGE_MIN_PLAYERS
#undef CHALLENGE_SHUTTLE_DELAY
