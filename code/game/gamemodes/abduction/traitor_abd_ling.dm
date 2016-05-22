/datum/game_mode/traitor/abduction/changeling
	name = "traitor+abductor+changeling" //MADNESS
	config_tag = "traitorabdchan"
	traitors_possible = 2 //hard limit on traitors if scaling is turned off
	restricted_jobs = list("AI", "Cyborg")
	required_players = 25
	required_enemies = 2	// how many of each type are required
	recommended_enemies = 3 //Only affects traitor spawning
	reroll_friendly = 1
	yogstat_name = "tlabductor"

	var/list/possible_changelings = list()
	var/const/changeling_amount = 1 //hard limit on changelings if scaling is turned off

/datum/game_mode/traitor/abduction/changeling/announce()
	world << "<B>The current game mode is - Traitor+Abductor+Changeling!</B>"
	world << "<B>There are three types of enemies on the station!  Ensure that none of them get you killed!</B>"
	world << "<B>Abductors: Abduct crew members and replace their organs with experimental ones!</B>"
	world << "<B>Traitors: Accomplish your objectives at any cost!</B>"
	world << "<B>Changelings: Absorb the DNA of crew members and disguise yourself as them!</B>"
	world << "<B>Crew: Escape the station alive!</B>"

/datum/game_mode/traitor/abduction/changeling/can_start()
	if(!..())
		return 0
	possible_changelings = get_players_for_role(BE_CHANGELING)
	if(possible_changelings.len < required_enemies)
		return 0
	return 1

/datum/game_mode/traitor/abduction/changeling/pre_setup()
	if(!..())
		return 0
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	var/list/datum/mind/possible_changelings = get_players_for_role(BE_CHANGELING)
	for(var/datum/mind/cling in possible_changelings)
		if(cling.special_role == "abductor scientist" || cling.special_role == "abductor_agent")
			possible_changelings -= cling

	var/num_changelings = 1

	if(config.changeling_scaling_coeff)
		num_changelings = max(1, min( round(num_players()/(config.changeling_scaling_coeff*4))+2, round(num_players()/(config.changeling_scaling_coeff*2)) ))
	else
		num_changelings = max(1, min(num_players(), changeling_amount/2))

	if(possible_changelings.len>0)
		for(var/j = 0, j < num_changelings, j++)
			if(!possible_changelings.len) break
			var/datum/mind/changeling = pick(possible_changelings)
			possible_changelings -= changeling
			changelings += changeling
			modePlayer += changelings
			changeling.restricted_roles = restricted_jobs
		return 1
	else
		return 0

/datum/game_mode/traitor/abduction/changeling/post_setup()
	for(var/datum/mind/changeling in changelings)
		changeling.current.make_changeling(changeling.current)
		changeling.special_role = "Changeling"
		forge_changeling_objectives(changeling)
		greet_changeling(changeling)
	..()
	return

/datum/game_mode/traitor/abduction/changeling/make_antag_chance(mob/living/carbon/human/character) //Assigns changeling to latejoiners
	var/changelingcap = min( round(joined_player_list.len/(config.changeling_scaling_coeff*4))+2, round(joined_player_list.len/(config.changeling_scaling_coeff*2)) )
	if(ticker.mode.changelings.len >= changelingcap) //Caps number of latejoin antagonists
		..()
		return
	if(ticker.mode.changelings.len <= (changelingcap - 2) || prob(100 / (config.changeling_scaling_coeff * 4)))
		if(character.client.prefs.hasSpecialRole(BE_CHANGELING))
			var/list/bans = jobban_list_for_mob(character.client)
			if(!jobban_job_in_list(bans, "changeling") && !jobban_job_in_list(bans, "Syndicate"))
				if(age_check(character.client))
					if(!(character.job in restricted_jobs))
						character.mind.make_Changling()
	..()
