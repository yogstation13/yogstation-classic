/datum/game_mode/traitor/abduction
	name = "traitor+abductor"
	config_tag = "traitorabd"
	traitors_possible = 3 //hard limit on traitors if scaling is turned off
	restricted_jobs = list("AI", "Cyborg")
	required_players = 20
	required_enemies = 2	// Tries to spawn two of each at a minimum
	recommended_enemies = 3 // Only actually effects traitor spawning, will ignore quiet mode if not this many candidates.
	reroll_friendly = 1

	var/list/possible_abductors = list()
	var/max_teams = 4
	abductor_teams = 1
	var/list/datum/mind/scientists = list()
	var/list/datum/mind/agents = list()
	var/list/datum/objective/team_objectives = list()
	var/list/team_names = list()
	var/finished = 0
	yogstat_name = "tabductor"

/datum/game_mode/traitor/abduction/announce()
	world << "<B>The current game mode is - Traitor+Abductor!</B>"
	world << "<B>There are alien creatures on the station along with some syndicate operatives out for their own gain! Do not let the abductors or the traitors succeed!</B>"

/datum/game_mode/traitor/abduction/can_start()
	if(!..())
		//message_admins("<B>Not enough traitor candidates to start Traitor+Abductor.</B>")
		return 0
	possible_abductors = get_players_for_role(BE_ABDUCTOR)
	if(possible_abductors.len < required_enemies)
		//message_admins("<B>Could not start mode Traitor+Abductor: Only [possible_abductors.len] abductor candidates, while [required_enemies] are needed.</B>")
		return 0
	return 1

/datum/game_mode/traitor/abduction/pre_setup()
	if(!..())
		return 0
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	possible_abductors = get_players_for_role(BE_ABDUCTOR)
	for(var/datum/mind/M in possible_abductors)
		if(M.special_role)
			possible_abductors -= M

	abductor_teams = max(1, min(max_teams,round(num_players()/config.abductor_scaling_coeff)))
	var/possible_teams = max(1,round(possible_abductors.len / 2))
	abductor_teams = min(abductor_teams,possible_teams)

	var/availible_subjects = round(num_players() - (abductor_teams * 2))

	if(possible_abductors.len > 1)

		abductors.len = 2*abductor_teams
		scientists.len = abductor_teams
		agents.len = abductor_teams
		team_objectives.len = abductor_teams
		team_names.len = abductor_teams
		for(var/i=1,i<=abductor_teams,i++)
			if(availible_subjects < 6)
				//message_admins("Less abductor teams than expected were created because there were not enough test subjects.")
				return 1 //Run out of valid abductors
			availible_subjects -= 6 // Number to abduct
			if(!make_abductor_team(i))
				//message_admins("<B>Could not start mode Traitor+Abductor: Not enough players to form an abductor team.  You should never see this.</B>")
				return 0
		return 1
	else
		//message_admins("<B>Could not start mode Traitor+Abductor: Not enough players with BE_ABDUCTOR.</B>")
		return 0

/datum/game_mode/traitor/abduction/proc/make_abductor_team(team_number,preset_agent=null,preset_scientist=null)
	//Team Name
	var/list/possible_abd_team_names = list("Alpha","Beta","Delta","Gamma","Epsilon","Phi")
	var/tname = pick(possible_abd_team_names)
	possible_abd_team_names -= tname
	team_names[team_number] = "Mothership [tname]"
	//Team Objective
	var/datum/objective/experiment/team_objective = new
	team_objective.team = team_number
	team_objectives[team_number] = team_objective
	//Team Members

	if(!preset_agent || !preset_scientist)
		if(possible_abductors.len <=2)
			return 0

	var/datum/mind/scientist
	var/datum/mind/agent

	if(!preset_scientist)
		scientist = pick(possible_abductors)
		possible_abductors -= scientist
	else
		scientist = preset_scientist

	if(!preset_agent)
		agent = pick(possible_abductors)
		possible_abductors -= agent
	else
		agent = preset_agent


	scientist.assigned_role = "abductor scientist"
	scientist.special_role = "abductor scientist"
	log_game("[scientist.key] (ckey) has been selected as an abductor team [team_number] scientist.")

	agent.assigned_role = "abductor agent"
	agent.special_role = "abductor agent"
	log_game("[agent.key] (ckey) has been selected as an abductor team [team_number] agent.")

	abductors |= agent
	abductors |= scientist
	scientists[team_number] = scientist
	agents[team_number] = agent
	return 1

/datum/game_mode/traitor/abduction/post_setup()
	//Spawn Team
	var/list/obj/effect/landmark/abductor/agent_landmarks = new
	var/list/obj/effect/landmark/abductor/scientist_landmarks = new
	agent_landmarks.len = max_teams
	scientist_landmarks.len = max_teams
	for(var/obj/effect/landmark/abductor/A in landmarks_list)
		if(istype(A,/obj/effect/landmark/abductor/agent))
			agent_landmarks[text2num(A.team)] = A
		else if(istype(A,/obj/effect/landmark/abductor/scientist))
			scientist_landmarks[text2num(A.team)] = A

	var/datum/mind/agent
	var/obj/effect/landmark/L
	var/datum/mind/scientist
	var/team_name
	var/mob/living/carbon/human/H
	var/datum/species/abductor/S
	for(var/team_number=1,team_number<=abductor_teams,team_number++)
		team_name = team_names[team_number]
		agent = agents[team_number]
		H = agent.current
		L = agent_landmarks[team_number]
		H.loc = L.loc
		hardset_dna(H, null, null, null, null, /datum/species/abductor)
		S = H.dna.species
		S.agent = 1
		S.team = team_number
		H.real_name = team_name + " Agent"
		equip_common(H,team_number)
		equip_agent(H,team_number)
		greet_agent(agent,team_number)
		H.regenerate_icons()

		scientist = scientists[team_number]
		H = scientist.current
		L = scientist_landmarks[team_number]
		H.loc = L.loc
		hardset_dna(H, null, null, null, null, /datum/species/abductor)
		S = H.dna.species
		S.scientist = 1
		S.team = team_number
		H.real_name = team_name + " Scientist"
		equip_common(H,team_number)
		equip_scientist(H,team_number)
		greet_scientist(scientist,team_number)
		H.regenerate_icons()
	return ..()

/datum/game_mode/traitor/abduction/proc/get_team_console(team)
	var/obj/machinery/abductor/console/console
	for(var/obj/machinery/abductor/console/c in machines)
		if(c.team == team)
			console = c
			break
	return console

/datum/game_mode/traitor/abduction/proc/greet_agent(datum/mind/abductor,team_number)
	abductor.objectives += team_objectives[team_number]
	var/team_name = team_names[team_number]

	abductor.current << "<span class='notice'>You are an agent of [team_name]!</span>"
	abductor.current << "<span class='notice'>With the help of your teammate, kidnap and experiment on station crew members!</span>"
	abductor.current << "<span class='notice'>Use your stealth technology and equipment to incapacitate humans for your scientist to retrieve.</span>"

	var/obj_count = 1
	for(var/datum/objective/objective in abductor.objectives)
		abductor.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/traitor/abduction/proc/greet_scientist(datum/mind/abductor,team_number)
	abductor.objectives += team_objectives[team_number]
	var/team_name = team_names[team_number]

	abductor.current << "<span class='notice'>You are a scientist of [team_name]!</span>"
	abductor.current << "<span class='notice'>With the help of your teammate, kidnap and experiment on station crew members!</span>"
	abductor.current << "<span class='notice'>Use your tool and ship consoles to support the agent and retrieve human specimens.</span>"

	var/obj_count = 1
	for(var/datum/objective/objective in abductor.objectives)
		abductor.current << "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
		obj_count++
	return

/datum/game_mode/traitor/abduction/proc/equip_common(mob/living/carbon/human/agent,team_number)
	var/radio_freq = SYND_FREQ

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate/alt(agent)
	R.set_frequency(radio_freq)
	agent.equip_to_slot_or_del(R, slot_ears)
	agent.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(agent), slot_shoes)
	agent.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(agent), slot_w_uniform) //they're greys gettit
	agent.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(agent), slot_back)

/datum/game_mode/traitor/abduction/proc/equip_agent(mob/living/carbon/human/agent,team_number)
	if(!team_number)
		var/datum/species/abductor/S = agent.dna.species
		team_number = S.team

	var/obj/machinery/abductor/console/console = get_team_console(team_number)
	var/obj/item/clothing/suit/armor/abductor/vest/V = new /obj/item/clothing/suit/armor/abductor/vest(agent)
	if(console!=null)
		console.vest = V
		V.flags |= NODROP
	agent.equip_to_slot_or_del(V, slot_wear_suit)
	agent.equip_to_slot_or_del(new /obj/item/weapon/abductor_baton(agent), slot_in_backpack)
	agent.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/alien(agent), slot_belt)
	agent.equip_to_slot_or_del(new /obj/item/device/abductor/silencer(agent), slot_in_backpack)
	agent.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/abductor(agent), slot_head)
	agent.equip_to_slot_or_del(new /obj/item/weapon/card/id/syndicate/abductor(agent), slot_wear_id)

/datum/game_mode/traitor/abduction/proc/equip_scientist(var/mob/living/carbon/human/scientist,var/team_number)
	if(!team_number)
		var/datum/species/abductor/S = scientist.dna.species
		team_number = S.team

	var/obj/machinery/abductor/console/console = get_team_console(team_number)
	var/obj/item/device/abductor/gizmo/G = new /obj/item/device/abductor/gizmo(scientist)
	if(console!=null)
		console.gizmo = G
		G.console = console
	scientist.equip_to_slot_or_del(G, slot_in_backpack)

	var/obj/item/weapon/implant/abductor/beamplant = new /obj/item/weapon/implant/abductor(scientist)
	beamplant.implant(scientist)

/datum/game_mode/proc/auto_declare_completion_abduction_trait()
	var/text = ""
	if(abductors.len)
		text += "<br><span class='big'><b>The abductors were:</b></span>"
		for(var/datum/mind/abductor_mind in abductors)
			text += printplayer(abductor_mind)
			text += printobjectives(abductor_mind)
		text += "<br>"
		if(abductees.len)
			text += "<br><span class='big'><b>The abductees were:</b></span>"
			for(var/datum/mind/abductee_mind in abductees)
				text += printplayer(abductee_mind)
				text += printobjectives(abductee_mind)
	text += "<br>"
	world << text

/datum/game_mode/traitor/abduction/declare_completion()
	log_yogstat_data("gamemode.php?gamemode=tabductor&value=rounds&action=add&changed=1")
	for(var/team_number=1,team_number<=abductor_teams,team_number++)
		var/obj/machinery/abductor/console/console = get_team_console(team_number)
		var/datum/objective/objective = team_objectives[team_number]
		var/team_name = team_names[team_number]
		if(console.experiment.points >= objective.target_amount)
			world << "<span class='greentext'><b>[team_name] team fullfilled its mission!</b></span>"
			log_yogstat_data("gamemode.php?gamemode=tabductor&value=antagwin&action=add&changed=1")
		else
			world << "<span class='greentext'><b>[team_name] team failed its mission.</b></span>"
			log_yogstat_data("gamemode.php?gamemode=tabductor&value=crewwin&action=add&changed=1")
	..()
	return 1
