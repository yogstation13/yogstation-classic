//This is my attempt to refactor the nukeops gamemode to be more generic. Not using this at the moment because I don't want to break nukeops, but if for some stupid reason we want to keep this gamemode, we should use the refactor for maintainability.

/datum/game_mode
	var/list/datum/mind/syndicates = list()
	var/list/operative_leader_titles = list("Czar", "Boss", "Commander", "Chief", "Kingpin", "Director", "Overlord")
	var/explosive_name = "nuclear"

/datum/game_mode/nuclear
	name = "nuclear emergency"
	config_tag = "nuclear"
	required_players = 20 // 20 players - 5 players to be the nuke ops = 15 players remaining
	required_enemies = 5
	recommended_enemies = 5
	antag_flag = BE_OPERATIVE
	enemy_minimum_age = 14

	var/const/agents_possible = 5 //If we ever need more syndicate agents.
	var/operative_titles = "nuclear operative"
	var/bomb_type = /obj/machinery/nuclearbomb

	var/nukes_left = 1 // Call 3714-PRAY right now and order more nukes! Limited offer!
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level

/datum/game_mode/nuclear/announce()
	world << "<B>The current game mode is - Nuclear Emergency!</B>"
	world << "<B>A [syndicate_name()] Strike Force is approaching [station_name()]!</B>"
	world << "A nuclear explosive was being transported by Nanotrasen to a military base. The transport ship mysteriously lost contact with Space Traffic Control (STC). About that time a strange disk was discovered around [station_name()]. It was identified by Nanotrasen as a nuclear auth. disk and now Syndicate Operatives have arrived to retake the disk and detonate SS13! Also, most likely Syndicate star ships are in the vicinity so take care not to lose the disk!\n<B>Syndicate</B>: Reclaim the disk and detonate the nuclear bomb anywhere on SS13.\n<B>Personnel</B>: Hold the disk and <B>escape with the disk</B> on the shuttle!"

/datum/game_mode/nuclear/pre_setup()
	var/agent_number = 0
	if(antag_candidates.len > agents_possible)
		agent_number = agents_possible
	else
		agent_number = antag_candidates.len

	var/n_players = num_players()
	if(agent_number > n_players)
		agent_number = n_players/2

	while(agent_number > 0)
		var/datum/mind/new_syndicate = pick(antag_candidates)
		syndicates += new_syndicate
		antag_candidates -= new_syndicate //So it doesn't pick the same guy each time.
		agent_number--

	for(var/datum/mind/synd_mind in syndicates)
		synd_mind.assigned_role = "Syndicate"
		synd_mind.special_role = "Syndicate"//So they actually have a special role/N
		log_game("[synd_mind.key] (ckey) has been selected as \a [operative_titles]")
	return 1


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_synd_icons_added(datum/mind/synd_mind)
	var/datum/atom_hud/antag/opshud = huds[ANTAG_HUD_OPS]
	opshud.join_hud(synd_mind.current)
	set_antag_hud(synd_mind.current, "synd")

/datum/game_mode/proc/update_synd_icons_removed(datum/mind/synd_mind)
	var/datum/atom_hud/antag/opshud = huds[ANTAG_HUD_OPS]
	opshud.leave_hud(synd_mind.current)
	set_antag_hud(synd_mind.current, null)

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/nuclear/post_setup()

	var/list/turf/synd_spawn = list()

	for(var/obj/effect/landmark/A in landmarks_list)
		if(A.name == "Syndicate-Spawn")
			synd_spawn += get_turf(A)
			continue

	var/obj/effect/landmark/uplinklocker = locate("landmark*Syndicate-Uplink")	//i will be rewriting this shortly //and he was never heard from again
	var/obj/effect/landmark/nuke_spawn = locate("landmark*Nuclear-Bomb")

	var/nuke_code = "[rand(10000, 99999)]"
	var/leader_selected = 0
	var/agent_number = 1
	var/spawnpos = 1

	for(var/datum/mind/synd_mind in syndicates)
		if(spawnpos > synd_spawn.len)
			spawnpos = 2
		synd_mind.current.loc = synd_spawn[spawnpos]

		handle_objectives(synd_mind)
		greet_syndicate(synd_mind)
		handle_equip(synd_mind.current)

		if (nuke_code)
			synd_mind.store_memory("<B>Syndicate [explosive_name] bomb code</B>: [nuke_code]", 0, 0)
			synd_mind.current << "The [explosive_name] authorization code is: <B>[nuke_code]</B>"

		if(!leader_selected)
			prepare_syndicate_leader(synd_mind, nuke_code)
			leader_selected = 1
		else
			synd_mind.current.real_name = "[syndicate_name()] Operative #[agent_number]"
			agent_number++
		spawnpos++
		update_synd_icons_added(synd_mind)

	if(uplinklocker)
		new /obj/structure/closet/syndicate/nuclear(uplinklocker.loc)
	if(nuke_spawn && synd_spawn.len > 0)
		var/obj/machinery/nuclearbomb/the_bomb = new bomb_type(nuke_spawn.loc)
		the_bomb.r_code = nuke_code

	return ..()

/datum/game_mode/nuclear/proc/handle_prepare_syndicate_leader(datum/mind/synd_mind, nuke_code)
	prepare_syndicate_leader(synd_mind, nuke_code)

/datum/game_mode/proc/prepare_syndicate_leader(datum/mind/synd_mind, nuke_code)
	var/leader_title = pick(operative_leader_titles)
	spawn(1)
		NukeNameAssign(nukelastname(synd_mind.current),syndicates) //allows time for the rest of the syndies to be chosen
	synd_mind.current.real_name = "[syndicate_name()] [leader_title]"
	synd_mind.current << "<B>You are the Syndicate [leader_title] for this mission. You are responsible for the distribution of telecrystals and your ID is the only one who can open the launch bay doors.</B>"
	synd_mind.current << "<B>If you feel you are not up to this task, give your ID to another operative.</B>"
	synd_mind.current << "<B>In your hand you will find a special item capable of triggering a greater challenge for your team. Examine it carefully and consult with your fellow operatives before activating it.</B>"

	var/obj/item/device/nuclear_challenge/challenge = new /obj/item/device/nuclear_challenge
	synd_mind.current.equip_to_slot_or_del(challenge, slot_r_hand)

	var/list/foundIDs = synd_mind.current.search_contents_for(/obj/item/weapon/card/id)
	if(foundIDs.len)
		for(var/obj/item/weapon/card/id/ID in foundIDs)
			ID.name = "lead agent card"
			ID.access += access_syndicate_leader
	else
		message_admins("Warning: Nuke Ops spawned without access to leave their spawn area!")

	if (nuke_code)
		var/obj/item/weapon/paper/P = new
		P.info = "The nuclear authorization code is: <b>[nuke_code]</b>"
		P.name = "nuclear bomb code"
		var/mob/living/carbon/human/H = synd_mind.current
		P.loc = H.loc
		H.equip_to_slot_or_del(P, slot_l_hand, 0)
		H.update_icons()
	else
		nuke_code = "code will be provided later"
	return


/datum/game_mode/nuclear/proc/handle_objectives(datum/mind/syndicate)
	forge_syndicate_objectives(syndicate)

/datum/game_mode/proc/forge_syndicate_objectives(datum/mind/syndicate)
	var/datum/objective/nuclear/syndobj = new
	syndobj.owner = syndicate
	syndicate.objectives += syndobj


/datum/game_mode/proc/greet_syndicate(datum/mind/syndicate, you_are=1)
	if (you_are)
		syndicate.current << "<span class='notice'>You are a [syndicate_name()] agent!</span>"
	var/obj_count = 1
	for(var/datum/objective/objective in syndicate.objectives)
		syndicate.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return


/datum/game_mode/proc/random_radio_frequency()
	return 1337 // WHY??? -- Doohl

/datum/game_mode/nuclear/proc/handle_equip(mob/living/carbon/human/synd_mob)
	equip_syndicate(synd_mob)

/datum/game_mode/proc/equip_syndicate(mob/living/carbon/human/synd_mob)
	var/radio_freq = SYND_FREQ

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(synd_mob)
	R.set_frequency(radio_freq)
	R.freqlock = 1
	synd_mob.equip_to_slot_or_del(R, slot_ears)

	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(synd_mob), slot_shoes)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate(synd_mob), slot_wear_id)
	if(synd_mob.backbag == 1) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(synd_mob), slot_back)
	if(synd_mob.backbag == 2) synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(synd_mob), slot_back)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol(synd_mob), slot_belt)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)

	var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(synd_mob)
	U.hidden_uplink.uplink_owner="[synd_mob.key]"
	U.hidden_uplink.uses = 20
	synd_mob.equip_to_slot_or_del(U, slot_in_backpack)

	var/obj/item/weapon/implant/weapons_auth/W = new/obj/item/weapon/implant/weapons_auth(synd_mob)
	W.implant(synd_mob)
	var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
	E.implant(synd_mob)
	synd_mob.faction |= "syndicate"
	synd_mob.update_icons()
	return 1


/datum/game_mode/nuclear/check_win()
	if (nukes_left == 0)
		return 1
	return ..()


/datum/game_mode/proc/are_operatives_dead()
	for(var/datum/mind/operative_mind in syndicates)
		if (istype(operative_mind.current,/mob/living/carbon/human) && (operative_mind.current.stat!=2))
			return 0
	return 1

/datum/game_mode/nuclear/check_finished() //to be called by ticker
	if(replacementmode && round_converted == 2)
		return replacementmode.check_finished()
	if(SSshuttle.emergency.mode >= SHUTTLE_ENDGAME || station_was_nuked)
		return 1
	if(are_operatives_dead())
		if(bomb_set) //snaaaaaaaaaake! It's not over yet!
			return 0
	..()

/datum/game_mode/nuclear/declare_completion()
	var/disk_rescued = 1
	for(var/obj/item/device/pda/clown/D in world)
		if(!D.onCentcom())
			disk_rescued = 0
			break
	var/crew_evacuated = (SSshuttle.emergency.mode >= SHUTTLE_ENDGAME)
	//var/operatives_are_dead = is_operatives_are_dead()


	//nukes_left
	//station_was_nuked
	//derp //Used for tracking if the syndies actually haul the nuke to the station	//no
	//herp //Used for tracking if the syndies got the shuttle off of the z-level	//NO, DON'T FUCKING NAME VARS LIKE THIS

	if(!disk_rescued &&  station_was_nuked && !syndies_didnt_escape)
		feedback_set_details("round_end_result","win - syndicate nuke")
		world << "<FONT size = 3><B>Syndicate Major Victory!</B></FONT>"
		world << "<B>[syndicate_name()] operatives have destroyed [station_name()]!</B>"

	else if (!disk_rescued &&  station_was_nuked && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - syndicate nuke - did not evacuate in time")
		world << "<FONT size = 3><B>Total Annihilation</B></FONT>"
		world << "<B>[syndicate_name()] operatives destroyed [station_name()] but did not leave the area in time and got caught in the explosion.</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !station_was_nuked && nuke_off_station && !syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station")
		world << "<FONT size = 3><B>Crew Minor Victory</B></FONT>"
		world << "<B>[syndicate_name()] operatives secured the authentication disk but blew up something that wasn't [station_name()].</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !station_was_nuked && nuke_off_station && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station - did not evacuate in time")
		world << "<FONT size = 3><B>[syndicate_name()] operatives have earned Darwin Award!</B></FONT>"
		world << "<B>[syndicate_name()] operatives blew up something that wasn't [station_name()] and got caught in the explosion.</B> Next time, don't lose the disk!"

	else if ((disk_rescued || SSshuttle.emergency.mode < SHUTTLE_ENDGAME) && are_operatives_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk secured - syndi team dead")
		world << "<FONT size = 3><B>Crew Major Victory!</B></FONT>"
		world << "<B>The Research Staff has saved the disc and killed the [syndicate_name()] Operatives</B>"

	else if ( disk_rescued )
		feedback_set_details("round_end_result","loss - evacuation - disk secured")
		world << "<FONT size = 3><B>Crew Major Victory</B></FONT>"
		world << "<B>The Research Staff has saved the disc and stopped the [syndicate_name()] Operatives!</B>"

	else if (!disk_rescued && are_operatives_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk not secured")
		world << "<FONT size = 3><B>Syndicate Minor Victory!</B></FONT>"
		world << "<B>The Research Staff failed to secure the authentication disk but did manage to kill most of the [syndicate_name()] Operatives!</B>"

	else if (!disk_rescued &&  crew_evacuated)
		feedback_set_details("round_end_result","halfwin - detonation averted")
		world << "<FONT size = 3><B>Syndicate Minor Victory!</B></FONT>"
		world << "<B>[syndicate_name()] operatives recovered the abandoned authentication disk but detonation of [station_name()] was averted.</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !crew_evacuated)
		feedback_set_details("round_end_result","halfwin - interrupted")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>Round was mysteriously interrupted!</B>"

	..()
	return


/datum/game_mode/proc/auto_declare_completion_nuclear()
	if( syndicates.len || (ticker && istype(ticker.mode,/datum/game_mode/nuclear)) )
		var/text = "<br><FONT size=3><B>The syndicate operatives were:</B></FONT>"

		var/purchases = ""
		var/TC_uses = 0

		for(var/datum/mind/syndicate in syndicates)

			text += "<br><b>[syndicate.key]</b> was <b>[syndicate.name]</b> ("
			if(syndicate.current)
				if(syndicate.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(syndicate.current.real_name != syndicate.name)
					text += " as <b>[syndicate.current.real_name]</b>"
			else
				text += "body destroyed"
			text += ")"

			for(var/obj/item/device/uplink/H in world_uplinks)
				if(H && H.uplink_owner && H.uplink_owner==syndicate.key)
					TC_uses += H.used_TC
					purchases += H.purchase_log

		text += "<br>"

		text += "(Syndicates used [TC_uses] TC) [purchases]"

		if(TC_uses==0 && station_was_nuked && !are_operatives_dead())
			text += "<BIG><IMG CLASS=icon SRC=\ref['icons/BadAss.dmi'] ICONSTATE='badass'></BIG>"

		world << text
	return 1


/datum/game_mode/proc/nukelastname(mob/M) //--All praise goes to NEO|Phyte, all blame goes to DH, and it was Cindi-Kate's idea. Also praise Urist for copypasta ho.
	var/randomname = pick(last_names)
	var/newname = copytext(sanitize(input(M,"You are the nuke operative [pick(operative_leader_titles)]. Please choose a last name for your family.", "Name change",randomname)),1,MAX_NAME_LEN)

	if (!newname)
		newname = randomname

	else
		if (newname == "Unknown" || newname == "floor" || newname == "wall" || newname == "rwall" || newname == "_")
			M << "That name is reserved."
			return nukelastname(M)

	return capitalize(newname)

/datum/game_mode/proc/NukeNameAssign(lastname,list/syndicates)
	for(var/datum/mind/synd_mind in syndicates)
		var/mob/living/carbon/human/H = synd_mind.current
		synd_mind.name = H.dna.species.random_name(H.gender,0,lastname)
		synd_mind.current.real_name = synd_mind.name
	return


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//////////////CLOWN OPS AFTER THE REFACTOR//////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////


/datum/game_mode/nuclear/clown_ops
	name = "clown ops"
	config_tag = "clown ops"

	operative_titles = "clown op"
	bomb_type = /obj/machinery/nuclearbomb/bananium

	required_players = 1 // remove these after debug
	required_enemies = 1

/datum/game_mode/nuclear/clown_ops/New()
	operative_leader_titles = list("Honkmaster", "Head Honker", "Slipbringer", "Mimeslayer")
	explosive_name = "bananium"

/datum/game_mode/nuclear/clown_ops/announce()
	world << "<B>The current game mode is - Clown Ops!</B>"
	world << "<B>A Syndicate Clown Strike Force is approaching [station_name()]!</B>"
	world << "\A [explosive_name] explosive was being transported by the Clown Federation to the clown planet. The transport ship mysteriously lost contact with Space Traffic Control (STC). About that time a strange disk was discovered around [station_name()]. It seemed quite unimportant at the time, so it was given to the clown. Now [syndicate_name()] Operatives have arrived to retake the disk and detonate SS13! Also, most likely [syndicate_name()] star ships are in the vicinity so take care not to lose the disk!\n<B>Clown Syndicate</B>: Reclaim the disk and detonate the bananium bomb anywhere on SS13.\n<B>Personnel</B>: Hold the disk and <B>escape with it</B> on the shuttle!"

/datum/game_mode/nuclear/clown_ops/handle_prepare_syndicate_leader(datum/mind/synd_mind, nuke_code)
	prepare_clown_syndicate_leader(synd_mind, nuke_code)

/datum/game_mode/proc/prepare_clown_syndicate_leader(datum/mind/synd_mind, nuke_code)
	var/leader_title = pick(operative_leader_titles)
	spawn(1)
		NukeNameAssign(nukelastname(synd_mind.current),syndicates) //allows time for the rest of the syndies to be chosen
	synd_mind.current.real_name = "[syndicate_name()] [leader_title]"
	synd_mind.current << "<B>HONK! You are the Clown Syndicate [leader_title] for this mission. You are responsible for the distribution of telecrystals and your ID is the only one that can open the launch bay doors.</B>"
	synd_mind.current << "<B>If you feel you are not up to this task, give your ID to another operative.</B>"
	synd_mind.current << "<B>In your hand you will find a special item capable of triggering a greater challenge for your team. Examine it carefully and consult with your fellow operatives before activating it.</B>"

	var/obj/item/device/nuclear_challenge/challenge = new /obj/item/device/nuclear_challenge
	synd_mind.current.equip_to_slot_or_del(challenge, slot_r_hand)

	var/list/foundIDs = synd_mind.current.search_contents_for(/obj/item/weapon/card/id)
	if(foundIDs.len)
		for(var/obj/item/weapon/card/id/ID in foundIDs)
			ID.name = "lead agent card"
			ID.access += access_syndicate_leader
	else
		message_admins("Warning: Clown Ops spawned without access to leave their spawn area!")

	if (nuke_code)
		var/obj/item/weapon/paper/P = new
		P.info = "The [explosive_name] authorization code is: <b>[nuke_code]</b>"
		P.name = "[explosive_name] bomb code"
		var/mob/living/carbon/human/H = synd_mind.current
		P.loc = H.loc
		H.equip_to_slot_or_del(P, slot_r_hand, 0)
		H.update_icons()
	else
		nuke_code = "code will be provided later"
	return

/*
/datum/game_mode/nuclear/clown_ops/handle_objectives(datum/mind/syndicate)
	forge_clown_syndicate_objectives(syndicate)

/datum/game_mode/proc/forge_clown_syndicate_objectives(datum/mind/syndicate)
	var/datum/objective/nuclear/syndobj = new
	syndobj.owner = syndicate
	syndicate.objectives += syndobj
*/

/datum/game_mode/nuclear/clown_ops/handle_equip(mob/living/carbon/human/synd_mob)
	equip_clown_syndicate(synd_mob)

/datum/game_mode/proc/equip_clown_syndicate(mob/living/carbon/human/synd_mob)
	var/radio_freq = SYND_FREQ

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(synd_mob)
	R.set_frequency(radio_freq)
	R.freqlock = 1
	synd_mob.equip_to_slot_or_del(R, slot_ears)

	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(synd_mob), slot_w_uniform)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(synd_mob), slot_shoes)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(synd_mob), slot_wear_mask)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/bikehorn(synd_mob), slot_l_store)
	synd_mob.equip_to_slot_or_del(new /obj/item/toy/crayon/rainbow(synd_mob), slot_r_store)
	synd_mob.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(synd_mob), slot_gloves)

	var/obj/item/weapon/card/id/syndicate/ID = new /obj/item/weapon/card/id/syndicate(synd_mob)
	ID.access += access_theatre
	synd_mob.equip_to_slot_or_del(ID, slot_wear_id)

	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/clown(synd_mob), slot_back)

	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/toy/pistol/riot(synd_mob), slot_belt)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(synd_mob.back), slot_in_backpack)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(synd_mob, 100/*super potency*/), slot_in_backpack)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/stamp/clown(synd_mob), slot_in_backpack)
	synd_mob.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/spray/waterflower(synd_mob), slot_in_backpack)

	synd_mob.dna.add_mutation(CLOWNMUT)//can't be a clown without being clumsy :).

	var/obj/item/device/radio/uplink/U = new /obj/item/device/radio/uplink(synd_mob)
	U.hidden_uplink.uplink_owner="[synd_mob.key]"
	U.hidden_uplink.uses = 20
	synd_mob.equip_to_slot_or_del(U, slot_in_backpack)

	var/obj/item/weapon/implant/weapons_auth/W = new/obj/item/weapon/implant/weapons_auth(synd_mob)
	W.implant(synd_mob)
	var/obj/item/weapon/implant/explosive/E = new/obj/item/weapon/implant/explosive(synd_mob)
	E.implant(synd_mob)
	synd_mob.faction |= "syndicate"
	synd_mob.update_icons()
	return 1

/datum/game_mode/nuclear/clown_ops/declare_completion()
	var/disk_rescued = 1
	for(var/obj/item/weapon/disk/nuclear/D in world)
		if(!D.onCentcom())
			disk_rescued = 0
			break
	var/crew_evacuated = (SSshuttle.emergency.mode >= SHUTTLE_ENDGAME)

	if(!disk_rescued &&  station_was_nuked && !syndies_didnt_escape)
		feedback_set_details("round_end_result","win - clown syndicate nuke")
		world << "<FONT size = 3><B>Syndicate Major Victory!</B></FONT>"
		world << "<B>[syndicate_name()] operatives have honked [station_name()]!</B>"

	else if (!disk_rescued &&  station_was_nuked && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - clown syndicate nuke - did not evacuate in time")
		world << "<FONT size = 3><B>Total Annihilation</B></FONT>"
		world << "<B>[syndicate_name()] operatives honked [station_name()] but did not leave the area in time and got caught in the honk.</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !station_was_nuked && nuke_off_station && !syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station")
		world << "<FONT size = 3><B>Crew Minor Victory</B></FONT>"
		world << "<B>[syndicate_name()] operatives secured the authentication disk but blew up something that wasn't [station_name()].</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !station_was_nuked && nuke_off_station && syndies_didnt_escape)
		feedback_set_details("round_end_result","halfwin - blew wrong station - did not evacuate in time")
		world << "<FONT size = 3><B>[syndicate_name()] operatives have earned Darwin Award!</B></FONT>"
		world << "<B>[syndicate_name()] operatives blew up something that wasn't [station_name()] and got caught in the explosion.</B> Next time, don't lose the disk!"

	else if ((disk_rescued || SSshuttle.emergency.mode < SHUTTLE_ENDGAME) && are_operatives_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk secured - clown syndi team dead")
		world << "<FONT size = 3><B>Crew Major Victory!</B></FONT>"
		world << "<B>The Research Staff has saved the disk and killed the [syndicate_name()] Operatives</B>"

	else if ( disk_rescued )
		feedback_set_details("round_end_result","loss - evacuation - disk secured")
		world << "<FONT size = 3><B>Crew Major Victory</B></FONT>"
		world << "<B>The Research Staff has saved the disk and stopped the [syndicate_name()] Operatives!</B>"

	else if (!disk_rescued && are_operatives_dead())
		feedback_set_details("round_end_result","loss - evacuation - disk not secured")
		world << "<FONT size = 3><B>Clown Syndicate Minor Victory!</B></FONT>"
		world << "<B>The Research Staff failed to secure the clown disk but did manage to kill most of the [syndicate_name()] Operatives!</B>"

	else if (!disk_rescued &&  crew_evacuated)
		feedback_set_details("round_end_result","halfwin - detonation averted")
		world << "<FONT size = 3><B>Clown Syndicate Minor Victory!</B></FONT>"
		world << "<B>[syndicate_name()] operatives recovered the abandoned clown disk but detonation of [station_name()] was averted.</B> Next time, don't lose the disk!"

	else if (!disk_rescued && !crew_evacuated)
		feedback_set_details("round_end_result","halfwin - interrupted")
		world << "<FONT size = 3><B>Neutral Victory</B></FONT>"
		world << "<B>Round was mysteriously interrupted!</B>"

	..()
	return


/datum/game_mode/proc/auto_declare_completion_clown_ops()
	if( syndicates.len || (ticker && istype(ticker.mode,/datum/game_mode/nuclear)) )
		var/text = "<br><FONT size=3><B>The clown syndicate operatives were:</B></FONT>"

		var/purchases = ""
		var/TC_uses = 0

		for(var/datum/mind/syndicate in syndicates)

			text += "<br><b>[syndicate.key]</b> was <b>[syndicate.name]</b> ("
			if(syndicate.current)
				if(syndicate.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(syndicate.current.real_name != syndicate.name)
					text += " as <b>[syndicate.current.real_name]</b>"
			else
				text += "body destroyed"
			text += ")"

			for(var/obj/item/device/uplink/H in world_uplinks)
				if(H && H.uplink_owner && H.uplink_owner==syndicate.key)
					TC_uses += H.used_TC
					purchases += H.purchase_log

		text += "<br>"

		text += "(Clown Syndicates used [TC_uses] TC) [purchases]"

		if(TC_uses==0 && station_was_nuked && !are_operatives_dead())
			text += "<BIG><IMG CLASS=icon SRC=\ref['icons/BadAss.dmi'] ICONSTATE='badass'></BIG>"

		world << text
	return 1
