/datum/round_event_control/zombies_outbreak
	name = "Zombie Outbreak"
	typepath = /datum/round_event/zombies_outbreak
	weight = 6
	max_occurrences = 1

/datum/round_event/zombies_outbreak
	announceWhen	= 30

	var/spawncount = 1
	var/successSpawn = 0	//So we don't make a command report if nothing gets spawned.


/datum/round_event/zombies_outbreak/setup()
	announceWhen = rand(announceWhen, announceWhen + 60)
	spawncount = rand(1, 3)

/datum/round_event/zombies_outbreak/kill()
	if(!successSpawn && control)
		control.occurrences--
	return ..()

/datum/round_event/zombies_outbreak/announce()
	if(successSpawn)
		priority_announce("Confirmed outbreak of level 9 viral biohazard aboard [station_name()]. Quarantine measures in effect. All personnel must contain the outbreak by all means necessary.", "Quarantine Alert", 'sound/AI/outbreak7.ogg')


/datum/round_event/zombies_outbreak/start()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/G in player_list)
		if(G.mind && G.mind.current && G.mind.current.stat == CONSCIOUS)
			if(G.client.mob && !G.client.is_afk(1200) && (G.client.prefs.hasSpecialRole(BE_ZOMBIE)))
				candidates += G.client.mob

	while(spawncount > 0 && candidates.len)
		var/mob/living/carbon/human/H = pick_n_take(candidates)
		H.ForceContractDisease(new /datum/disease/transformation/rage_virus)
		log_admin("Zombie outbreak event infected [key_name(H)].")

		spawncount--
		successSpawn = 1
