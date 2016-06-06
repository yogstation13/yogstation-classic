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
	var/used = 0

/obj/item/device/nuclear_challenge/attack_self(mob/living/user)
	if(!doChecks(user))
		return

	var/are_you_sure = alert(user, "Are you sure you want to alert the enemy crew? You will receive [round(CHALLENGE_TC_PER_PLAYER*player_list.len)] bonus Telecrystals for declaring War.", "Declare war?", "Yes", "No")

	if(are_you_sure == "Yes")
		if(!doChecks(user))
			return
		declare_nuclear_war(user)
		used = 1
	else
		user << "On second thought, the element of surprise isn't so bad after all."

/obj/item/device/nuclear_challenge/proc/doChecks(mob/living/user)
	if(loc != user)
		return 0
	if(used)
		user << "You have already voted."
		return 0
	if(player_list.len < CHALLENGE_MIN_PLAYERS)
		user << "The enemy crew is too small to be worth declaring war on."
		return 0
	if(user.z != ZLEVEL_CENTCOM)
		user << "You have to be at your base to use this."
		return 0

	if(world.time > CHALLENGE_TIME_LIMIT)
		user << "It's too late to declare hostilities. Your benefactors are already busy with other schemes. You'll have to make  do with what you have on hand."
		return 0

	return 1

//The voting version

/obj/item/device/nuclear_challenge/vote
	name = "Declaration of War (Challenge Mode) Voter"
	icon_state = "gangtool-yellow"
	item_state = "walkietalkie"
	desc = "Use to cast your vote for sending a declaration of hostilities to the target, delaying your shuttle departure for 20 minutes while they prepare for your assault.  \
			Such a brazen move will attract the attention of powerful benefactors within the Syndicate, who will supply your team with a massive amount of bonus telecrystals.  \
			Must be used within five minutes, or your benefactors will lose interest."
	var/global/yesVotes = 0
	var/global/noVotes = 0
	var/global/votesNeeded = 3

/obj/item/device/nuclear_challenge/vote/attack_self(mob/living/user)
	if(!doChecks(user))
		return

	var/are_you_sure = alert(user, "Are you sure you want to vote to alert the enemy crew? You will receive [round(CHALLENGE_TC_PER_PLAYER*player_list.len)] bonus Telecrystals for declaring War. You cannot change your vote if you select Yes or No.", "Declare war?", "Yes", "No", "Cancel Vote")

	if(!doChecks(user))
		return

	if(are_you_sure == "Yes")
		used = 1
		yesVotes++
		announce("[usr.real_name] has voted YES for war. There are [yesVotes] for war and [noVotes] against war.")
		if(yesVotes >= votesNeeded)
			declare_nuclear_war(user)
	else if(are_you_sure == "No")
		used = 1
		noVotes++
		announce("[usr.real_name] has voted NO for war. There are [yesVotes] for war and [noVotes] against war.")
	else
		user << "You decide to think it over more."

/obj/item/device/nuclear_challenge/vote/doChecks(mob/living/user)
	if(!..())
		return 0

	if(yesVotes >= votesNeeded)
		user << "Your vote no longer matters, your comrades have decided for you."
		return 0

	return 1

/obj/item/device/nuclear_challenge/vote/proc/announce(var/annoucement)
	for(var/obj/item/device/nuclear_challenge/vote/V in world)
		var/mob/living/mob = get(V.loc,/mob/living)
		if(mob)
			mob.show_message("\icon[V] [annoucement]", 2)


/proc/declare_nuclear_war(mob/living/user)
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
