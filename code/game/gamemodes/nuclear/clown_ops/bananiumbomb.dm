/obj/machinery/nuclearbomb/bananium
	name = "bananium fission explosive"
	desc = "You're not sure how dangerous this actually is, but you probably shouldn't risk finding out."
	icon = 'icons/obj/machines/nuke.dmi'
	icon_state = "bananiumbomb_base"
	icon_state_timing = "bananiumbomb_timing"
	icon_state_exploding = "bananiumbomb_exploding"

/obj/machinery/nuclearbomb/bananium/explode()
	if (safety)
		timing = 0
		return

	timing = -1
	yes_code = 0
	safety = 1
	update_icon()
	for(var/mob/M in player_list)
		M << 'sound/machines/Alarm.ogg'
	if (ticker && ticker.mode)
		ticker.mode.explosion_in_progress = 1
	sleep(100)

	if(!core)
		ticker.station_explosion_cinematic(3,"no_core")
		ticker.mode.explosion_in_progress = 0
		return

	enter_allowed = 0

	var/off_station = 0
	var/turf/bomb_location = get_turf(src)
	if( bomb_location && (bomb_location.z == ZLEVEL_STATION) )
		if( (bomb_location.x < (128-NUKERANGE)) || (bomb_location.x > (128+NUKERANGE)) || (bomb_location.y < (128-NUKERANGE)) || (bomb_location.y > (128+NUKERANGE)) )
			off_station = 1
	else
		off_station = 2

	if(ticker.mode && istype(ticker.mode, /datum/game_mode/clown_ops))
		var/obj/docking_port/mobile/Shuttle = SSshuttle.getShuttle("syndicate")
		ticker.mode:syndies_didnt_escape = (Shuttle && Shuttle.z == ZLEVEL_CENTCOM) ? 0 : 1
		ticker.mode:nuke_off_station = off_station
	ticker.station_explosion_cinematic(off_station, "HONK")
	for(var/V in mob_list)
		//TODO: Limit this to the bomb's Z-level
		var/mob.M = V
		M.Stun(5)
		M.Weaken(5)
		var/mob/living/carbon/human/H = M
		if(istype(H) && (!H.mind || !(H.mind.assigned_role == "Clown" || H.mind.assigned_role == "Clown Operative" || H.mind.assigned_role == "Mime")) )//Damn mimes!
			//make 'em clowns.
			var/obj/item/clothing/C
			H.unEquip(H.w_uniform, 1)
			C = new /obj/item/clothing/under/rank/clown(H)
			C.flags |= NODROP //mwahaha
			H.equip_to_slot_or_del(C, slot_w_uniform)

			H.unEquip(H.shoes, 1)
			C = new /obj/item/clothing/shoes/clown_shoes(H)
			C.flags |= NODROP
			H.equip_to_slot_or_del(C, slot_shoes)

			H.unEquip(H.wear_mask, 1)
			C = new /obj/item/clothing/mask/gas/clown_hat(H)
			C.flags |= NODROP
			H.equip_to_slot_or_del(C, slot_wear_mask)

			H.dna.add_mutation(CLOWNMUT)
	if(ticker.mode)
		ticker.mode.explosion_in_progress = 0
		if(istype(ticker.mode, /datum/game_mode/clown_ops))
			var/datum/game_mode/clown_ops/GM = ticker.mode
			GM.nukes_left --
		else
			world << "<B>The station was honked by the bananium blast!</B>"
		ticker.mode.station_was_nuked = (off_station<2)	//offstation==1 is a draw. the station becomes irradiated and needs to be evacuated.
														//kinda shit but I couldn't  get permission to do what I wanted to do.
		if(!ticker.mode.check_finished())//If the mode does not deal with the nuke going off so just reboot because everyone is stuck as is
			world.Reboot("Station honked by Bananium Bomb.", "end_error", "clown nuke - unhandled ending")
			return
	return