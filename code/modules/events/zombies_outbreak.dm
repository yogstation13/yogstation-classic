/*/datum/round_event_control/alien_infestation
	name = "Alien Infestation"
	typepath = /datum/round_event/alien_infestation
	weight = 0
	max_occurrences = 0

/datum/round_event/alien_infestation
	announceWhen	= 400

	var/spawncount = 1
	var/successSpawn = 0	//So we don't make a command report if nothing gets spawned.


/datum/round_event/alien_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(1, 2)

/datum/round_event/alien_infestation/kill()
	if(!successSpawn && control)
		control.occurrences--
	return ..()

/datum/round_event/alien_infestation/announce()
	if(successSpawn)
		priority_announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", 'sound/AI/aliens.ogg')


/datum/round_event/alien_infestation/start()
	var/list/candidates = list()
	for(var/mob/dead/observer/G in player_list)
		if(G.mind && G.mind.current && G.mind.current.stat == CONCIOUS)
			if(!G.client.is_afk(afk_bracket) && (G.client.prefs.be_special & be_special_flag))
				candidates += G.client

	candidates
*/