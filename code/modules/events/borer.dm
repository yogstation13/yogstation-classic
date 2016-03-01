/datum/round_event_control/borer
	name = "Borer"
	typepath = /datum/round_event/borer
	weight = 5
	max_occurrences = 1

	earliest_start = 12000 // 20 Minutes

/datum/round_event/borer
	announceWhen = 3000 //Borers get 5 minutes till the crew tries to murder them.
	var/spawned = 0

/datum/round_event/alien_infestation/announce()
	if(spawned)
		priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/AI/aliens.ogg') //Borers seem like normal xenomorphs.


/datum/round_event/borer/start()

	var/list/spawn_locs = list()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(isturf(L.loc))
			switch(L.name)
				if("borer_start")
					spawn_locs += L.loc

	if(!spawn_locs.len)
		return

	var/spawn_loc = pick(spawn_locs)

	if(!spawn_loc)
		return

	var/list/candidates = get_candidates(BE_ALIEN, ALIEN_AFK_BRACKET)
	if(!candidates.len)
		return
	var/client/C = pick(candidates)

	var/mob/living/simple_animal/borer/borer = new(spawn_loc)
	borer.transfer_personality(C)
	spawned = 1