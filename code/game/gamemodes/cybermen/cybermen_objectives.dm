/datum/cyberman_network
	var/list/cybermen_analyze_targets = list(/obj/item/weapon/gun/energy/laser/captain = "the captain's antique laser gun", //stolen from objective_items.dm. Could just use the objective datums instead.
								/obj/item/weapon/gun/energy/gun/hos = "the head of security's personal laser gun",
								/obj/item/weapon/hand_tele = "a hand teleporter",
								/obj/item/clothing/shoes/magboots/advance = "the chief engineer's advanced magnetic boots",
								/obj/item/weapon/reagent_containers/hypospray/CMO = "the hypospray",
								/obj/item/weapon/disk/nuclear = "the nuclear authentication disk", //lucky if you also get the "nuke station" objective
								/obj/item/weapon/pinpointer = "a pinpointer", //also lucky, but less so.
								/obj/item/clothing/suit/armor/laserproof = "an ablative armor vest",
								/obj/item/weapon/gun/energy/ionrifle = "the ion rifle",//because irony
								/obj/item/clothing/suit/armor/reactive = "the reactive teleport armor",
								/obj/item/areaeditor/blueprints = "the station blueprints")
	var/list/cybermen_hack_targets = list(/obj/machinery/computer/communications/ = "a communications console",//seriously need to add things to this
							/obj/machinery/power/apc/ = "an APC",
							/obj/machinery/alarm/ = "an air alarm",
							/obj/machinery/computer/card/ = "an identification console",
							/obj/machinery/r_n_d/server/ = "the station's RnD server",//might already be hacked due to a previous objective
							/obj/machinery/telecomms/hub/ = "a telecomminications hub",//hopefully these haven't all been deconstructed yet
							// /mob/living/silicon/robot/ = "a cyborg"//needs a check in is_valid(). Removed because of overlap with hacking the AI
							)


/datum/objective/cybermen
	var/phase
	dangerrating = 10 //seems like a good number

/datum/objective/cybermen/proc/is_valid()//ensure the objective is completeable.
	return 1

/datum/objective/cybermen/proc/make_valid()//some objectives can be made valid by reducing the number or changing the targets - this method should warn cybermen and return 1 if it succeeds.
	return 0

/datum/objective/cybermen/check_completion()
	return ..()

//////////////////////////////
//////////EXPLORE/////////////
//////////////////////////////
/datum/objective/cybermen/explore
	phase = "Explore"

//GET RESEARCH LEVELS
/datum/objective/cybermen/explore/get_research_levels
	var/target_research_levels

/datum/objective/cybermen/explore/get_research_levels/New()
	..()
	target_research_levels = rand(8, 10)
	explanation_text = "Download [target_research_levels] research level\s by hacking the station's RnD server, the server controller, or technology disks."

/datum/objective/cybermen/explore/get_research_levels/check_completion()//yes, I copy-pasted from ninjacode.
	if(..())
		return 1
	var/current_amount = 0
	for(var/datum/tech/current_data in cyberman_network.cybermen_research_downloaded)
		if(current_data.level)
			current_amount += (current_data.level-1)//can't let that level 1 junk give us points
	return current_amount >= target_research_levels

//GET SECRET DOCUMENTS
/datum/objective/cybermen/explore/get_secret_documents//how can you hack pieces of paper? Nanomachines or something.
	explanation_text = "Aquire the NT secret documents located in the vault, and upload them to the cybermen network by hacking them."

/datum/objective/cybermen/explore/get_secret_documents/check_completion()
	if(..())
		return 1
	for(var/obj/item/documents/nanotrasen/D in cyberman_network.cybermen_hacked_objects)
		return 1
	return 0

//GET ACCESS
/datum/objective/cybermen/explore/get_access
	explanation_text = "Aquire an ID with Captain-level access upload it to the cybermen network by hacking it."

/datum/objective/cybermen/explore/get_access/check_completion()
	if(..())
		return 1
	return (access_captain in cyberman_network.cybermen_access_downloaded)

//////////////////////////////
//////////EXPAND//////////////
//////////////////////////////
/datum/objective/cybermen/expand
	phase = "Expand"

//RECRUIT CYBERMEN
/datum/objective/cybermen/expand/convert_crewmembers
	var/target_cybermen_num

/datum/objective/cybermen/expand/convert_crewmembers/New()
	..()
	target_cybermen_num = rand(6, 8)
	explanation_text = "Convert crewmembers until there are [target_cybermen_num] living cybermen on the station."

/datum/objective/cybermen/expand/convert_crewmembers/is_valid()
	var/humans_on_station = 0
	for(var/mob/living/carbon/human/survivor in living_mob_list)
		if(survivor.loc.z == ZLEVEL_STATION && !survivor.client.is_afk())
			humans_on_station++
	return target_cybermen_num <= humans_on_station

/datum/objective/cybermen/expand/convert_crewmembers/make_valid()
	var/humans_on_station = 0
	for(var/mob/living/carbon/human/survivor in living_mob_list)
		if(survivor.loc.z == ZLEVEL_STATION && !survivor.client.is_afk())
			humans_on_station++
	if(humans_on_station > 3)//needs a somewhat sane lozer limit
		target_cybermen_num = humans_on_station
		cyberman_network.message_all_cybermen("<span class='notice'>Too few humans detected aboard the station. Number of required cybermen reduced to [target_cybermen_num].</span>")
		explanation_text = "Convert crewmembers until there are [target_cybermen_num] living cybermen on the station."
		return 1
	else
		return 0

/datum/objective/cybermen/expand/convert_crewmembers/check_completion()
	if(..())
		return 1
	var/living_cybermen = 0
	for(var/datum/mind/M in cyberman_network.cybermen)
		if(M.current && !(M.current.stat | DEAD))
			living_cybermen++
	return living_cybermen >= target_cybermen_num

//HACK AI
/datum/objective/cybermen/expand/hack_ai
	var/mob/living/silicon/ai/targetAI

/datum/objective/cybermen/expand/hack_ai/New()
	..()
	for(var/mob/living/silicon/ai/new_ai in ai_list)
		if(targetAI && targetAI.current != null && !qdeleted(targetAI.current) && targetAI.key && targetAI.client)
			targetAI = new_ai
			explanation_text = "Hack [targetAI.current.name], the AI."

/datum/objective/cybermen/expand/hack_ai/is_valid()
	return targetAI && targetAI.current != null && !qdeleted(targetAI.current) && targetAI.key && targetAI.client

/datum/objective/cybermen/expand/hack_ai/make_valid()
	targetAI = null
	for(var/mob/living/silicon/ai/new_ai in ai_list)
		if(targetAI && targetAI.current != null && !qdeleted(targetAI.current) && targetAI.key && targetAI.client)
			targetAI = new_ai
			explanation_text = "Hack [targetAI.current.name], the AI."
			cyberman_network.message_all_cybermen("Cybermen AI hack target changed. New AI hack target is [targetAI.current.name].")
			return 1
	return 0

/datum/objective/cybermen/expand/hack_ai/check_completion()
	if(..())
		return 1
	return targetAI in cyberman_network.cybermen_hacked_objects

//CONVERT HEADS
/datum/objective/cybermen/expand/convert_heads
	var/target_heads_num

/datum/objective/cybermen/expand/convert_heads/New()
	..()
	target_heads_num = pick(2, 3)
	explanation_text = "Place [target_heads_num] cybermen into command positions, either by having a cyberman promoted or converting a current head."

/datum/objective/cybermen/expand/convert_heads/is_valid()
	return 1//could check how many heads there are, but cybermen could just get head IDs, so no real need to.

/datum/objective/cybermen/expand/convert_heads/check_completion()
	if(..())
		return 1
	var/num
	for(var/datum/data/record/t in data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		if(rank in command_positions)
			for(var/datum/mind/M in cyberman_network.cybermen)
				if(M.current.real_name == name)//possible issues with duplicate names
					num++
					break

	return num >= target_heads_num

//////////////////////////////
//////////EXPLOIT/////////////
//////////////////////////////
/datum/objective/cybermen/exploit
	phase = "Exploit"

//ANALYZE AND HACK SOME RANDOM THINGS
/datum/objective/cybermen/exploit/analyze_and_hack
	var/list/targets = list()//these two lists must remain in synch.
	var/descriptions = list()
	var/num_analyze_targets = 2//change explanation_text if you change either of these
	var/num_hack_targets = 1

/datum/objective/cybermen/exploit/analyze_and_hack/New()
	..()
	var/list/analyze_target_candidates = cyberman_network.cybermen_analyze_targets.Copy()
	var/list/hack_target_candidates = cyberman_network.cybermen_hack_targets.Copy()
	var/remaining = num_analyze_targets
	while(remaining)
		var/candidate = pick(analyze_target_candidates)
		if(candidate)
			descriptions += analyze_target_candidates[candidate]
			analyze_target_candidates -= candidate
			targets += candidate
		remaining--
	remaining = num_hack_targets
	while(remaining)
		var/candidate = pick(hack_target_candidates)
		if(candidate)
			descriptions += hack_target_candidates[candidate]
			hack_target_candidates -= candidate
			targets += candidate
		remaining--
	check_completion()//takes care of explanation text.

/datum/objective/cybermen/exploit/analyze_and_hack/is_valid()
	//everything on the analyze list is a high-risk item, so we'll assume they haven't been spaced or destroyed.
	//everything on the hack list is constructable, even the cyborg, so we'll call it valid even if they don't exist at the moment.
	return 1

/datum/objective/cybermen/exploit/analyze_and_hack/make_valid()
	return 1

/datum/objective/cybermen/exploit/analyze_and_hack/check_completion()
	if(..())
		return 1
	var/list/targets_copy = targets.Copy()
	var/list/done_indicators = list()
	for(var/current2 in targets_copy)
		var/done_indicator = "(<font color='red'>Not Completed</font>)"
		for(var/current in cyberman_network.cybermen_hacked_objects)
			if(istype(current, current2))
				targets_copy -= current2
				done_indicator = "(<font color='green'>Completed</font>)"
				break
		done_indicators += done_indicator

	explanation_text = "Obtain and analyze [descriptions[1]][done_indicators[1]] and [descriptions[2]][done_indicators[2]], and hack [descriptions[3]][done_indicators[3]]."
	return targets_copy.len == 0


/*
//ANALYZE SOME RANDOM THINGS
//commented out for now because analyze and hack is essentially the same thing.
//maybe you could load some materials on the supply shuttle and hack the supply console, sending them to some cyberman HQ?
/datum/objective/cybermen/exploit/analyze_materials

/datum/objective/cybermen/exploit/analyze_materials/New()
	//generate dem lists
	explanation_text = "Obtain and analyze "

/datum/objective/cybermen/exploit/analyze_materials/check_completion()
	//???
	..()
*/

//////////////////////////////
/////////EXTERMINATE//////////
//////////////////////////////
/datum/objective/cybermen/exterminate
	phase = "Exterminate"

/datum/objective/cybermen/exterminate/is_valid()
	return 1//probably should not touch this becuase it is a game-ending objective. Don't ever want it to change.

/datum/objective/cybermen/exterminate/make_valid()
	return 1//probably should not touch this becuase it is a game-ending objective. Don't ever want it to change.


//GET DAT FUKKIN DISK
/datum/objective/cybermen/exterminate/nuke_station
	explanation_text = "Destroy the station with the nuclear device in the vault. Hack the nuclear core to bypass the Centcom password lock. The nuclear authentication disk is still required. Do not allow the escape shuttle to leave the station."

/datum/objective/cybermen/exterminate/nuke_station/check_completion()
	if(..())
		return 1
	return ticker.mode.station_was_nuked && SSshuttle.emergency.mode < SHUTTLE_ESCAPE

//HIJACK SHUTTLE
/datum/objective/cybermen/exterminate/hijack_shuttle
	var/required_escaped_cybermen

/datum/objective/cybermen/exterminate/hijack_shuttle/New()
	..()
	required_escaped_cybermen = min(6, cyberman_network.cybermen.len)
	explanation_text = "Hijack the escape shuttle, ensuring that no non-cybermen escape on it. At least [required_escaped_cybermen] Cybermen must escape on the shuttle. The escape pods may be ignored."

/datum/objective/cybermen/exterminate/hijack_shuttle/check_completion()//some copy-pasting from objective.dm
	if(..())
		return 1
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0
	var/area/A = SSshuttle.emergency.areaInstance
	for(var/mob/living/player in player_list)
		if(player.mind && player.stat != DEAD && !istype(player, /mob/living/silicon) && get_area(player) == A)
			if(player.mind && !ticker.mode.is_cyberman(player.mind))
				return 0
 	return 1


//KILL NON-CYBERMEN
/datum/objective/cybermen/exterminate/eliminate_humans
	var/target_percent

/datum/objective/cybermen/exterminate/eliminate_humans/New()
	..()
	target_percent = 60
	explanation_text = "Ensure [target_percent]% of the humanoid population of the station is comprised of cybermen, by either killing, converting, or exiling non-cybermen. Do not allow the escape shuttle to leave the station."

/datum/objective/cybermen/exterminate/eliminate_humans/check_completion()//I mean, you COULD just cart all those pesky non-cybermen off to mining. But that's no fun. The alternative is the possibility that the cybermen have to search the asteroid and deep space for the non-cybermen, and that's even less fun.
	if(..())
		return 1
	if(SSshuttle.emergency.mode >= SHUTTLE_ESCAPE)
		return 0
	var/cybermen_num = 0
	var/non_cybermen_num = 0
	for(var/mob/living/carbon/human/survivor in living_mob_list)
		if(survivor.loc.z == ZLEVEL_STATION && !survivor.client.is_afk())//don't care about sentient animals, silicones, AFKs, or people off the z-level
			if(ticker.mode.is_cyberman(survivor.mind))
				cybermen_num++
			else
				non_cybermen_num++
	return (cybermen_num + non_cybermen_num > 0) && (cybermen_num / (cybermen_num + non_cybermen_num))*100 >= target_percent