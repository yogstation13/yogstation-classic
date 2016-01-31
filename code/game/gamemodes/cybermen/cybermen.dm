/*
 *********************************************************************************************
 * Concept by Alblaka
 * see http://forums.yogstation.net/index.php?threads/mode-cybermen.8096/ for gamemode details
 *********************************************************************************************
*/

#define CYBERMEN_HACK_NOISE_DIST 3
#define CYBERMEN_BASE_HACK_POWER_1 20
#define CYBERMEN_BASE_HACK_POWER_2 10
#define CYBERMEN_BASE_HACK_POWER_3 5
#define CYBERMEN_BASE_HACK_POWER_4 1
#define CYBERMEN_BASE_HACK_RANGE_1 1
#define CYBERMEN_BASE_HACK_RANGE_2 3
#define CYBERMEN_BASE_HACK_RANGE_3 10
#define CYBERMEN_BASE_HACK_MAINTAIN_RANGE 10

//#define CYBERMEN_DEBUG

#ifdef CYBERMEN_DEBUG
#warn Warning: Cybermen debug text and abilities are enabled
#endif

/datum/game_mode
	var/cybermen_win = 0
	var/list/datum/mind/cybermen = list()
	var/list/datum/objective/cybermen/cybermen_objectives = list()
	var/datum/objective/cybermen/queued_cybermen_objective = null
	var/list/obj/effect/cyberman_hack/active_cybermen_hacks = list()
	var/list/cybermen_hacked_objects = list()//used for objectives, might someday be used for faster hacks on things that have already been hacked.
	var/list/datum/tech/cybermen_research_downloaded = list()//used for research objectives. May do other things as well someday.
	var/list/cybermen_access_downloaded = list()//have to use this because otherwise you could hack an ID and then change its access to get the objective, which makes no sense.


/datum/game_mode/cybermen
	name = "cybermen"
	config_tag = "cybermen"
	antag_flag = BE_CYBERMAN
	#ifdef CYBERMEN_DEBUG
	required_players = 1
	required_enemies = 1
	#else
	required_players = 30
	required_enemies = 2
	#endif
	recommended_enemies = 3
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")

/datum/game_mode/cybermen/announce()
	world << "The gamemode is Cybermen."

/datum/game_mode/cybermen/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	if(config.protect_assistant_from_antagonist)
		restricted_jobs += "Assistant"

	#ifdef CYBERMEN_DEBUG
	var/cybermen_num = 1
	#else
	var/cybermen_num = max(3, round(num_players()/14))
	#endif

	while(cybermen_num)
		var/datum/mind/cyberman = pick(antag_candidates)
		cybermen += cyberman
		cyberman.cyberman = new /datum/cyberman_datum()
		antag_candidates -= cyberman
		cyberman.special_role = "Cyberman"
		cyberman.restricted_roles = restricted_jobs
		cybermen_num--
	return 1

/datum/game_mode/cybermen/post_setup()
	sleep(10)

	for(var/datum/mind/cyberman in cybermen)
		log_game("[cyberman.key] (ckey) has been selected as a Cyberman.")
		spawn(9)
			cybermen -= cyberman
			add_cyberman(cyberman, "<span class='boldannounce'><b><font size=3>You are a Cyberman!</font></b></span>\n<b>Any other Cybermen are your allies. Work together to complete your objectives. You will be given a total of four objectives, each revealed upon completion of the previous objective.</b>")
	generate_cybermen_objective(1)
	spawn(10)
		display_current_cybermen_objective()
	..()
	return

/datum/game_mode/cybermen/process()
	for(var/obj/effect/cyberman_hack/H in active_cybermen_hacks)
		if(!H || qdeleted(H))
			active_cybermen_hacks -= H
	#ifdef CYBERMEN_DEBUG
	world << "---------Active Hacks:-----------"
	for(var/obj/effect/cyberman_hack/H in active_cybermen_hacks)
		world << "\t[H.target_name]"
	#endif
	for(var/datum/mind/cyberman in cybermen)
		if(!cyberman || qdeleted(cyberman))
			cybermen -= cyberman
			continue
		if(cyberman.cyberman.emp_hit > 0)
			cyberman.cyberman.emp_hit--

	for(var/datum/mind/cyberman in cybermen)
		cyberman.cyberman.process_hacking(cyberman.current)
	for(var/obj/effect/cyberman_hack/H in active_cybermen_hacks)
		H.process()

	if(cybermen_objectives.len == 0)
		return
	var/datum/objective/cybermen/T = cybermen_objectives[cybermen_objectives.len]
	if(T != null && (T.is_valid() || T.make_valid()) )
		if(T.check_completion() )
			if(cybermen_objectives.len < 4)
				generate_cybermen_objective(cybermen_objectives.len+1)
				display_current_cybermen_objective()
			else
				//Cybermen win!
				if(!cybermen_win)
					cybermen_win = 1
					message_all_cybermen("<span class='greentext'>You have served the collective well.</span>")
	else
		message_all_cybermen("<span class='notice'>Cybermen objective has been rendered invalid, the collective is assigning a new objective...</span>")
		if(cybermen_objectives.len > 0)
			cybermen_objectives -= cybermen_objectives[cybermen_objectives.len]
		generate_cybermen_objective(cybermen_objectives.len+1)
		display_current_cybermen_objective()

/datum/game_mode/proc/generate_cybermen_objective(phase_num)
	var/list/datum/objective/cybermen/explore_objectives = list(new /datum/objective/cybermen/explore/get_research_levels(), new /datum/objective/cybermen/explore/get_secret_documents(), new /datum/objective/cybermen/explore/get_access())
	var/list/datum/objective/cybermen/expand_objectives = list(new /datum/objective/cybermen/expand/convert_crewmembers(), new /datum/objective/cybermen/expand/hack_ai(), new /datum/objective/cybermen/expand/convert_heads())
	var/list/datum/objective/cybermen/exploit_objectives = list(new /datum/objective/cybermen/exploit/analyze_and_hack())
	var/list/datum/objective/cybermen/exterminate_objectives = list(new /datum/objective/cybermen/exterminate/nuke_station(), new /datum/objective/cybermen/exterminate/hijack_shuttle(), new /datum/objective/cybermen/exterminate/eliminate_humans())

	var/datum/objective/cybermen/current_objective
	switch(phase_num)
		if(1)
			//Explore
			current_objective = generate_cybermen_objective_helper(explore_objectives)
		if(2)
			//Expand
			current_objective = generate_cybermen_objective_helper(expand_objectives)
		if(3)
			//Exploit
			current_objective = generate_cybermen_objective_helper(exploit_objectives)
		if(4)
			//Exterminate
			current_objective = generate_cybermen_objective_helper(exterminate_objectives)
		else
			log_game("ERROR: cyberman objective number incorrect. Was [cybermen_objectives.len], should be 1, 2, 3, or 4.")
			message_admins("Cybermen objectives were not properly assigned.")
			return
	if(current_objective)
		cybermen_objectives += current_objective
	else
		log_game("ERROR: unable to select a valid cybermen objective from phase [phase_num] pool. Taking an objective from the next stage pool instead.")
		generate_cybermen_objective(phase_num+1)//this will make the cybermen have two later phase objectives for the round instead.

/datum/game_mode/proc/generate_cybermen_objective_helper(list/datum/objective/cybermen/possible_objectives)
	var/datum/objective/cybermen/current_objective = null
	while(!current_objective && possible_objectives.len > 0)
		current_objective = pick(possible_objectives)
		if(!current_objective.is_valid() && !current_objective.make_valid() )
			possible_objectives -= current_objective
			current_objective = null
	return current_objective


/datum/game_mode/proc/display_all_cybermen_objectives(datum/mind/M)
	if(cybermen_objectives.len < 1)
		M.current << "<span class='notice'>No objectives to display.</span>"
		return
	var/datum/objective/cybermen/O
	M.current << "<span class='notice'>The objectives of the Cybermen aboard [station_name()] are as follows:</span>"
	for(var/i = 1 to cybermen_objectives.len-1)
		O = cybermen_objectives[i]
		if(O)
			M.current << "Phase [i]:[O.phase]"
			M.current << "[O.explanation_text]"
			M.current << "<font color='green'><b>Complete</b></font><br>"
	O = cybermen_objectives[cybermen_objectives.len]
	M.current << "Phase [cybermen_objectives.len]:[O.phase]"
	M.current << "[O.explanation_text]"
	M.current << (O.check_completion() ? "<font color='green'><b>Complete</b></font><br>" : "<font color='yellow'><b>In Progress</b></font>")

/datum/game_mode/proc/display_current_cybermen_objective()
	if(cybermen_objectives.len > 0)
		var/datum/objective/cybermen/O = cybermen_objectives[cybermen_objectives.len]
		message_all_cybermen("<span class='notice'>Cybermen objectives have advanced to stage [cybermen_objectives.len]:[O.phase].Your new objective is: </span>")
		message_all_cybermen(O.explanation_text)
	else
		log_game("ERROR - [usr] attempted to display current cyberman objective when there are no objectives")

/datum/game_mode/proc/message_all_cybermen(message)
	for(var/datum/mind/cyberman in cybermen)
		cyberman.current << message

/*
/datum/game_mode/proc/is_cyberman(datum/mind/mind)//fast and simple one
	return mind && mind.cyberman && (mind in cybermen)
*/

/datum/game_mode/proc/is_cyberman(datum/mind/mind)//better for logging errors
	if(!mind)
		return 0
	var/in_cybermen = (mind in cybermen)
	if((mind.cyberman && !in_cybermen) || (!mind.cyberman && in_cybermen))
		var/message = mind.cyberman ? "[mind] was found to have an initialized cyberman datum, but is not a registered cyberman. Please report this bug to a coder." : "[mind] was found to not have an initialized cyberman datum, but is a registered cyberman. Please report this bug to a coder."
		log_game(message)
		return 0
	return mind.cyberman

/datum/game_mode/proc/add_cyberman(var/datum/mind/cyberman, var/message_override)
	if(is_cyberman(cyberman))
		return
	cybermen += cyberman//careful this doesn't happen twice.
	cyberman.cyberman = new /datum/cyberman_datum()
	cyberman.special_role = "cyberman"
	cyberman.current.attack_log += "\[[time_stamp()]\] <span class='danger'>Became a cyberman</span>"

	update_cybermen_icons_add(cyberman)
	if(message_override)
		cyberman.current << message_override
	else
		cyberman.current << "<span class='boldannounce'><b><font size=3>You are now a Cyberman! Work with your fellow cybermen and do not harm them.</font></b></span>"

	var/mob/living/carbon/human/H = cyberman.current
	if(cyberman.assigned_role == "Clown")
		H << "<span class='notice'>Your superior Cyberman form has allowed you to overcome your clownish genetics.</span>"
		H.dna.remove_mutation(CLOWNMUT)
	if(isloyal(H))
		H << "<span class='notice'>Your loyalty implant has been deactivated, but not destroyed. While scanners will show that it is still active, you are no longer loyal to Nanotrasen.</span>"//I personnally am not a fan of this, but Alblaka said it so that's what I've done.

	cyberman.current << "<span class='notice'>As a Cyberman, hacking is your most valuable ability. Click on \'Prepare Hacking\' in the Cybermen tab to use it.</span>"
	cyberman.current << "<span class='notice'>\n\"Cybermen\" is an experimental gamemode. If you find any bugs, please submit a bug report on the forums. If a bug prevents you from completing an objective, or you are not properly assigned an objective, contact an admin via ahelp.</span>"
	display_all_cybermen_objectives(cyberman)

/datum/game_mode/proc/remove_cyberman(datum/mind/cyberman, var/message_override)
	if(!is_cyberman(cyberman) )
		return
	//drop all installed parts (except limbs)
	for(var/obj/item/weapon/stock_parts/capacitor/P in cyberman.cyberman.upgrades_installed)
		P.loc = cyberman.current.loc
		cyberman.cyberman.upgrades_installed -= P
	qdel(cyberman.cyberman)
	cyberman.cyberman = null//redundant but doesn't hurt to be safe.
	cybermen -= cyberman
	cyberman.current.attack_log += "\[[time_stamp()]\] <span class='danger'>No longer a cyberman</span>"
	cyberman.special_role = null

	update_cybermen_icons_remove(cyberman)
	var/mob/living/carbon/human/H = cyberman.current
	if(issilicon(H))
		H.audible_message("<span class='notice'>[H] lets out a short blip.</span>", "<span class='userdanger'>You have been turned into a robot! You are no longer a cyberman! Though you try, you cannot remember anything about the cybermen or your time as one...</span>")
	else
		H.visible_message("<span class='big'>[H] looks like their mind is their own again!</span>", message_override ? message_override : "<span class='userdanger'>Your mind is your own again! You are no longer a cyberman! Though you try, you cannot remember anything about the cybermen or your time as one...</span>")
		if(isloyal(H))
			H << "<span class='notice'>Your loyalty implant has been re-activated - you are once again unfailingly loyal to Nanotrasen.</span>"

/datum/game_mode/cybermen/check_finished()
	return ..() || cybermen_win

/datum/game_mode/cybermen/check_win()
	return cybermen_win

/datum/game_mode/cybermen/declare_completion()
	..()
	if(!cybermen_win && SSshuttle.emergency.mode >= SHUTTLE_ESCAPE)
		world << "<span class='redtext'>The Cybermen failed to take control of the station!</span>"
	else if(cybermen_win && station_was_nuked)
		world << "<span class='greentext'>The Cybermen win! They acivated the station's self-destruct device!</span>"
	else if(cybermen_win)
		world << "<span class='greentext'>The Cybermen win! They have exterminated or stranded all of the non-cybermen!</span>"
	else
		world << "<span class='redtext'>The Cybermen have failed!</span>"

	world << "<br><span class='big'><b>The Cybermens' Objectives were:</b></span>"
	var/datum/objective/cybermen/O
	for(var/i = 1 to cybermen_objectives.len-1)
		O = cybermen_objectives[i]
		if(O)
			world << "Phase [i]:[O.phase]"
			world << "[O.explanation_text]"
			world << "<font color='green'><b>Completed</b></font><br>"
	O = cybermen_objectives[cybermen_objectives.len]
	world << "Phase [cybermen_objectives.len]:[O.phase]"
	world << "[O.explanation_text]"
	world << (O.check_completion() ? "<font color='green'><b>Completed</b></font><br>" : "<font color='red'><b>Failed</b></font>")
	return 1

/datum/game_mode/proc/auto_declare_completion_cybermen()
	if(cybermen.len > 0)
		var/text = ""
		text += "<br><span class='big'><b>The Cybermen were:</b></span>"
		for(var/datum/mind/cyberman in ticker.mode.cybermen)
			text += printplayer(cyberman)
			text += "<br>"
		world << text

datum/game_mode/proc/update_cybermen_icons_add(datum/mind/cyberman)
	var/datum/atom_hud/antag/cyberman_hud = huds[ANTAG_HUD_CYBERMEN]
	cyberman_hud.join_hud(cyberman.current)
	set_antag_hud(cyberman.current, "cybermen")

datum/game_mode/proc/update_cybermen_icons_remove(datum/mind/cyberman)
	var/datum/atom_hud/antag/cyberman_hud = huds[ANTAG_HUD_CYBERMEN]
	cyberman_hud.leave_hud(cyberman.current)
	set_antag_hud(cyberman.current, null)


////////////////////////////////////////////////////////
//CYBERMAN DATUM
////////////////////////////////////////////////////////

/datum/mind/
	var/datum/cyberman_datum/cyberman

/datum/cyberman_datum
	var/emp_hit = 0//if not 0, cyberman cannot hack or use cyberman broadcast. reduced by 1 every tick if it is greater than 0. set to -1 for infinite EMPed.
	var/quickhack = 0
	var/obj/effect/cyberman_hack/selected_hack
	var/obj/effect/cyberman_hack/manual_selected_hack
	var/hack_power_level_1 = CYBERMEN_BASE_HACK_POWER_1//might want to do all these in a single list instead of separate variables.
	var/hack_power_level_2 = CYBERMEN_BASE_HACK_POWER_2
	var/hack_power_level_3 = CYBERMEN_BASE_HACK_POWER_3
	var/hack_power_level_4 = CYBERMEN_BASE_HACK_POWER_4
	var/hack_max_dist_level_1 = CYBERMEN_BASE_HACK_RANGE_1
	var/hack_max_dist_level_2 = CYBERMEN_BASE_HACK_RANGE_2
	var/hack_max_dist_level_3 = CYBERMEN_BASE_HACK_RANGE_3
	var/hack_max_start_dist = 1
	var/hack_max_maintain_dist = CYBERMEN_BASE_HACK_MAINTAIN_RANGE
	var/list/upgrades_installed = list()
	var/list/obj/effect/proc_holder/cyberman/abilities = list(new /obj/effect/proc_holder/cyberman/commune(), new /obj/effect/proc_holder/cyberman/cyberman_toggle_quickhack(), new /obj/effect/proc_holder/cyberman/cyberman_cancel_hack(), new /obj/effect/proc_holder/cyberman/cyberman_cancel_component_hack(), new /obj/effect/proc_holder/cyberman/cyberman_disp_objectives(), new /obj/effect/proc_holder/cyberman/cyberman_manual_select_hack() )

/datum/cyberman_datum/proc/validate(var/mob/living/carbon/human/user = usr)
	if(!user)
		return 0
	if(!istype(user, /mob/living/carbon/human))//cybermen need to be human.
		ticker.mode.remove_cyberman(user.mind)
		log_game("[user] was detected as a non-human cyberman. They have been un-cyberman'ed.")
		return 0
	if(!ticker.mode.is_cyberman(user.mind) )
		return 0
	if(user.mind.cyberman != src)
		log_game("[user] somehow tried to use cyberman abilities with someone else's cyberman datum. Please report this bug to a coder.")
		return 0
	return 1

/datum/cyberman_datum/proc/add_cyberman_abilities_to_statpanel()
	for(var/obj/effect/proc_holder/cyberman/A in abilities)
		statpanel("[A.panel]", "", A)

/datum/cyberman_datum/proc/initiate_hack(atom/target)
	if(!validate(usr) )
		usr << "<span class='warning'>You are not a Cyberman, you cannot initiate a hack.</span>"
		return
	if(emp_hit)
		usr << "<span class='warning'>You were recently hit by an EMP, you cannot hack right now!</span>"
	else if(get_dist(usr, target) > hack_max_start_dist)
		usr << "<span class='warning'>You are to far away to hack \the [target].</span>"
	else
		usr.audible_message("<span class='notice'>You hear a faint sound of static.</span>", CYBERMEN_HACK_NOISE_DIST )
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			H << "<span class='warning'>You feel a tiny prick!</span>"
		var/obj/effect/cyberman_hack/newHack = target.get_cybermen_hack()
		if(newHack)
			newHack.start()
		else
			usr << "<span class='warning'>\The [target] cannot be hacked.</span>"


/datum/cyberman_datum/proc/cancel_hack(var/mob/living/carbon/human/user = usr, var/obj/effect/cyberman_hack/hack)
	if(!validate(user) || !hack)
		return
	if(hack.can_cancel(user) )
		hack.drop("<span class='notice'>[hack.display_verb] of \the [hack.target_name] canceled by [user].<span>")
	else
		user << "<span class='warning'>You cannot cancel a hack unless you are close enough to maintain it!</span>"

/datum/cyberman_datum/proc/cancel_closest_component_hack(var/mob/living/carbon/human/user = usr, var/obj/effect/cyberman_hack/multiple_vector/hack)
	if(!validate(user) || !hack || !istype(hack, /obj/effect/cyberman_hack/multiple_vector))
		return
	hack.do_tick_calculations_if_required(user)
	if(!hack.tick_best_hack)
		user << "<span class='warning'>Error: No component hacks of [hack.target_name] detected.</span>"
		return
	if(!hack.tick_best_hack.can_cancel(user) )
		user << "<span class='warning'>You are not close enough to cancel the [hack.tick_best_hack.display_verb] of \the [hack.tick_best_hack.target_name], the closest component hack of \the [hack.target_name].</span>"
		return
	if(hack.component_hacks.len == 1 && !hack.innate_processing)//safeguard in case they don't realise that they are the last one hacking the ai/tcomms network/etc. If it is a magic admin/debug hack, though, you can always stop contributing.
		user << "<span class='warning'>The [hack.tick_best_hack.display_verb] of \the [hack.tick_best_hack.target_name] is the only remaining component hack of \the [hack.target_name]. If you want to cancel it, you must cancel the whole hack.</span>"
		return
	hack.tick_best_hack.drop("<span class='notice'>The [hack.tick_best_hack.display_verb] of \the [hack.tick_best_hack.target_name], which was contributing to the [hack.display_verb] of \the [hack.target_name], was canceled by [user].<span>")

/datum/cyberman_datum/proc/select_hack(var/mob/living/carbon/human/user = usr, var/obj/effect/cyberman_hack/hack)
	if(!validate(user))
		return
	if(hack == user.mind.cyberman.manual_selected_hack)
		user.mind.cyberman.manual_selected_hack = null
	else
		user.mind.cyberman.manual_selected_hack = hack

/datum/cyberman_datum/proc/update_processing_power(mob/living/carbon/human/user = usr)
	if(!validate(user) )
		return
	hack_power_level_1 = CYBERMEN_BASE_HACK_POWER_1
	hack_power_level_2 = CYBERMEN_BASE_HACK_POWER_2
	hack_power_level_3 = CYBERMEN_BASE_HACK_POWER_3
	hack_power_level_4 = CYBERMEN_BASE_HACK_POWER_4
	hack_max_dist_level_1 = CYBERMEN_BASE_HACK_RANGE_1
	hack_max_dist_level_2 = CYBERMEN_BASE_HACK_RANGE_2
	hack_max_dist_level_3 = CYBERMEN_BASE_HACK_RANGE_3
	hack_max_maintain_dist = CYBERMEN_BASE_HACK_MAINTAIN_RANGE

	for(var/obj/item/organ/limb/L in user.organs)
		if(L.status == ORGAN_ROBOTIC)
			upgrades_installed |= L
	for(var/obj/item/organ/limb/L in upgrades_installed)
		hack_power_level_1 += 1
		hack_power_level_2 += 1
		hack_power_level_3 += 1

	for(var/obj/item/weapon/stock_parts/capacitor/P in upgrades_installed)
		var/increase_amount = P.rating * 2.5
		hack_power_level_1 += increase_amount
		hack_power_level_2 += increase_amount
		hack_power_level_3 += increase_amount

/datum/cyberman_datum/proc/process_hacking(mob/living/carbon/human/user = usr)
	//this proc assumes that there are no null or qdeleted items in cybermen_active_hacks. If there are any nulls, it could cause a null pointer exception and break hacking for this tick.
	selected_hack = null
	if(!validate(user) || user.stat)
		return
	if(user.stat || user.stunned || emp_hit)
		return
	if(ticker.mode.active_cybermen_hacks.len == 0)
		return
	update_processing_power(user)
	if(manual_selected_hack && (manual_selected_hack in ticker.mode.active_cybermen_hacks) )
		selected_hack = manual_selected_hack
	else if(ticker.mode.active_cybermen_hacks.len > 0)
		var/best_preference = -1
		for(var/obj/effect/cyberman_hack/current_hack in ticker.mode.active_cybermen_hacks)
			var/this_preference = current_hack.get_preference_for(user)
			if(this_preference > best_preference)
				best_preference = this_preference
				selected_hack = current_hack
	if(selected_hack)
		selected_hack.contribute_to(user)
	return

/datum/cyberman_datum/proc/emp_act(var/mob/living/carbon/human/mob = src, var/severity)
	mob.Stun(5)
	mob.Weaken(5)
	mob.silent = max(60, mob.silent)
	mob.adjustBrainLoss(40)
	mob.visible_message("<span class='danger'>[mob] clutches their head, writhing in pain!</span>")
	emp_hit = max(60, emp_hit)