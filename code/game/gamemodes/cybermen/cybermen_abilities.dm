#define CYBERMEN_HACK_NOISE_DIST 3

//////////////////////
//Ability Activators//
//////////////////////

/obj/effect/proc_holder/cyberman
	panel = "Cyberman"

/obj/effect/proc_holder/cyberman/commune
	name = "Cyberman Broadcast"
	desc = "Communicate with fellow cybermen. Completely undetectable, but cannot be done if you have been recently EMPed."

/obj/effect/proc_holder/cyberman/commune/Click()
	if(!(usr.mind && usr.mind.cyberman))
		usr << "You are not a cyberman, you should not be able to do this!"
		return 0
	return usr.mind.cyberman.use_broadcast(usr)

/mob/living/proc/cyberman_hack(var/atom/target in world)//for the context menu option. Disabled for now becuase middle-click works just fine..
	//set category = ""//automatically goes in "Commands" tab.
	set name = "Hack"
	usr.mind.cyberman.initiate_hack(target, usr)

/obj/effect/proc_holder/cyberman/cyberman_toggle_quickhack
	name = "Prepare Hacking"
	desc = "Enable or disable your cyberman hacking module."

/obj/effect/proc_holder/cyberman/cyberman_toggle_quickhack/Click()
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.toggle_quickhack(usr)

/obj/effect/proc_holder/cyberman/cyberman_manual_select_hack
	name = "Select Current Hack"
	desc = "Select the hack you are contributing processing power to."

/obj/effect/proc_holder/cyberman/cyberman_manual_select_hack/Click()
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.manual_select_hack(usr)

/obj/effect/proc_holder/cyberman/cyberman_cancel_hack//maybe this should open an "are you sure?" dialogue.
	name = "Cancel Hack"
	desc = "End a hack prematurely."

/obj/effect/proc_holder/cyberman/cyberman_cancel_hack/Click()
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.manual_cancel_hack()
/*
/obj/effect/proc_holder/cyberman/cyberman_cancel_component_hack
	name = "Cancel Component Hack"//needs a new name
	desc = "End the closest component hack of a multiple-vector hack."

/obj/effect/proc_holder/cyberman/cyberman_cancel_component_hack/Click()
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.manual_cancel_component_hack(usr)

/mob/living/carbon/human/proc/cancel_hack_context(var/obj/effect/cyberman_hack/hack in cyberman_network.active_cybermen_hacks)
	set name = "Cancel Hack"
	set category = "Hacking"
	if(!usr.mind || !usr.mind.cyberman)
		return
	usr.mind.cyberman.cancel_hack(usr, hack)
*/
/obj/effect/proc_holder/cyberman/cyberman_disp_objectives
	name = "Display Objectives"
	desc = "Display all cyberman objectives that have been assigned so far."

/obj/effect/proc_holder/cyberman/cyberman_disp_objectives/Click()
	cyberman_network.display_all_cybermen_objectives(usr.mind)

////////////////////
//Actual abilities//
////////////////////
/datum/cyberman_datum/proc/initiate_hack(var/atom/target, var/mob/living/carbon/human/user = usr)
	if(user.stat)//no more hacking while a ghost
		return
	if(!validate(user) )
		user << "<span class='warning'>You are not a Cyberman, you cannot initiate a hack.</span>"
		return
	if(emp_hit)
		user << "<span class='warning'>You were recently hit by an EMP, you cannot hack right now!</span>"
		return
	if(get_dist(user, target) > hack_max_start_dist)
		user << "<span class='warning'>You are to far away to hack \the [target].</span>"
		return
	var/obj/effect/cyberman_hack/newHack = target.get_cybermen_hack()
	if(newHack)
		user.audible_message("<span class='danger'>You hear a faint sound of static.</span>", CYBERMEN_HACK_NOISE_DIST )
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			H << "<span class='warning'>You feel a tiny prick!</span>"
		cyberman_network.message_all_cybermen("<span class='notice>[newHack.display_verb] of [newHack.target_name] started by [user].</span>")
		newHack.start()
	else
		user << "<span class='warning'>\The [target] cannot be hacked.</span>"


/datum/cyberman_datum/proc/cancel_hack(var/mob/living/carbon/human/user = usr, var/obj/effect/cyberman_hack/hack)
	if(!validate(user) || !hack || user.stat || user.stunned)
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(hack.can_cancel(user) )
		hack.drop("<span class='warning'>[hack.display_verb] of \the [hack.target_name] canceled by [user].<span>")
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

/datum/cyberman_datum/proc/use_broadcast(var/mob/living/carbon/human/user = usr)
	if(user.stat == DEAD || user.stat == UNCONSCIOUS)//you can still use it while stunned.
		user << "<span class='warning'>You can't use that right now!</span>"
		return 0
	if(emp_hit)
		user << "<span class='warning'>You were hit by an EMP recently, you cannot use the cyberman broadcast!</span>"
		return 0
	var/input = stripped_input(user, "Enter a message to share with all other Cybermen.", "Cybermen Broadcast", "")
	if(input)
		cyberman_network.log_broadcast("[user]([user.ckey ? user.ckey : "No ckey"]) Sent a Cyberman Broadcast: [input]")
		log_say("[key_name(user)] : [input]")
		user.say_log_silent += "Cyberman Broadcast: [input]"
		for(var/datum/mind/cyberman in cyberman_network.cybermen)
			var/distorted_message = input
			if(cyberman.cyberman.emp_hit)
				distorted_message = Gibberish2(input, cyberman.cyberman.emp_hit*1.6)
			cyberman.current << "<span class='cyberman'>Cyberman Broadcast: [distorted_message]</span>"
		for(var/mob/dead in dead_mob_list)
			dead << "<span class='cyberman'>Cyberman Broadcast: [input]</span>"
	return 1

/datum/cyberman_datum/proc/get_user_selected_hack(var/mob/living/carbon/human/user = usr, var/display, var/null_option)
	var/list/hacks = list()
	for(var/obj/effect/cyberman_hack/hack in cyberman_network.active_cybermen_hacks)
		hacks += hack.target_name
	if(null_option)
		hacks += null_option
	var/target_hack_name = input(usr, display, "Cyberman Hack Management") as null|anything in hacks
	if(!target_hack_name || target_hack_name == null_option)
		return null
	var/obj/effect/cyberman_hack/target_hack = null
	for(var/obj/effect/cyberman_hack/hack in cyberman_network.active_cybermen_hacks)//this will have issues if two different hacked objects have the same name.
		if(hack.target_name == target_hack_name)
			target_hack = hack
			break
	return target_hack

/datum/cyberman_datum/proc/toggle_quickhack(var/mob/living/carbon/human/user = usr)
	quickhack = !quickhack
	user << (user.mind.cyberman.quickhack ? "You prepare to hack nearby objects. Use alt- or middle-click to hack." : "You decide not to hack anything for the moment.")


/datum/cyberman_datum/proc/manual_select_hack(var/mob/living/carbon/human/user = usr)
	var/obj/effect/cyberman_hack/selected_hack = get_user_selected_hack(user, "Choose which hack you wish to contribute to:", "(automatic)")
	if(selected_hack)
		select_hack(user, selected_hack)


/datum/cyberman_datum/proc/manual_cancel_hack(var/mob/living/carbon/human/user = usr)
	var/obj/effect/cyberman_hack/selected_hack = get_user_selected_hack(user, "Choose which hack you wish to contribute to:", "(none)")
	if(selected_hack)
		user.mind.cyberman.cancel_hack(user, selected_hack)


/datum/cyberman_datum/proc/manual_cancel_component_hack(var/mob/living/carbon/human/user = usr)
	var/obj/effect/cyberman_hack/selected_hack = get_user_selected_hack(user, "(none)")
	if(selected_hack)
		user.mind.cyberman.cancel_closest_component_hack(usr, selected_hack)

/////////////////////////////////////////////
///////////////DEBUG/ADMIN///////////////////
/////////////////////////////////////////////

var/list/cybermen_debug_abilities = list(/datum/admins/proc/become_cyberman,
										 /datum/admins/proc/become_cyberman_instant,
										 /datum/admins/proc/cyberman_defect,
										 /datum/admins/proc/reroll_cybermen_objective,
										 /datum/admins/proc/force_complete_cybermen_objective,
										 // /datum/admins/proc/set_cybermen_objective
										 /datum/admins/proc/start_auto_hack,
										 /datum/admins/proc/cybermen_collective_broadcast
										    )

/datum/admins/proc/become_cyberman()
	set category = "Cyberman Debug"
	set name = "Become Cyberman"

	if(ticker.mode.is_cyberman(usr.mind))
		usr << "You are already a Cyberman!"
	else
		var/obj/effect/cyberman_hack/newHack = usr.get_cybermen_hack()
		newHack.innate_processing = 10
		if(newHack)
			if(newHack.start())
				usr << "You are now becoming a Cyberman..."
			else
				usr << "Cyberman conversion failed."

/datum/admins/proc/become_cyberman_instant()
	set category = "Cyberman Debug"
	set name = "Become Cyberman (Instant)"

	if(ticker.mode.is_cyberman(usr.mind))
		usr << "You are already a Cyberman!"
	else
		ticker.mode.add_cyberman(usr.mind)


/datum/admins/proc/cyberman_defect()
	set category = "Cyberman Debug"
	set name = "Quit being a Cyberman"
	src << "Removing cyberman status..."
	ticker.mode.remove_cyberman(usr.mind)


/datum/admins/proc/reroll_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Reroll Objective"
	if(!cyberman_network)
		usr << "There is no Cyberman network to change the objective of."
		return
	cyberman_network.message_all_cybermen("Re-assigning current objective...")
	cyberman_network.cybermen_objectives -= cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len]
	cyberman_network.generate_cybermen_objective(cyberman_network.cybermen_objectives.len+1)
	cyberman_network.display_current_cybermen_objective()

/datum/admins/proc/force_complete_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Force Complete Objective"

	if(!cyberman_network)
		usr << "There is no Cyberman network to complete the objective of."
		return
	if(cyberman_network.cybermen_objectives.len)
		var/datum/objective/cybermen/O = cyberman_network.cybermen_objectives[cyberman_network.cybermen_objectives.len]
		if(O)
			O.completed = 1
			message_admins("[key_name_admin(usr)] has force-completed the cyberman objective: \"[O.explanation_text]\".")
			log_admin("[key_name(usr)] has force-completed the cyberman objective: \"[O.explanation_text]\".")
		else
			usr << "<span class='warning'>ERROR - Current Cyberman objective is null.</span>"
	else
		usr << "<span class='warning'>ERROR - No cyberman objective to force-complete.</span>"

/datum/admins/proc/set_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Set Current Objective"

	usr << "<span class='warning'>This operation is not functional at this time.</span>"

/datum/admins/proc/start_auto_hack(var/atom/target in world)
	set category = "Cyberman Debug"
	set name = "Start Automatic Hack"
	var/obj/effect/cyberman_hack/newHack = target.get_cybermen_hack()
	if(newHack)
		if(newHack.start())
			newHack.innate_processing = 10
		else
			usr << "[newHack.display_verb] of [newHack.target_name] failed."
	else
		usr << "[target] cannot be hacked."

/datum/admins/proc/cybermen_collective_broadcast()
	set category = "Cyberman Debug"
	set name = "Cyberman Collective Broadcast"

	if(!cyberman_network)
		usr << "You cannot make a Cyberman Collective Broadcast, there are no cybermen to hear it."
		return
	var/input = stripped_input(usr, "Enter a message to share with all other Cybermen. This message will not be distorted by EMP effects.", "Cybermen Collective Broadcast", "")
	if(input)
		cyberman_network.log_broadcast("[usr] Sent a Cyberman Collective Broadcast: [input]", 1)
		for(var/datum/mind/cyberman in cyberman_network.cybermen)
			cyberman.current << "<span class='cybermancollective'>Cyberman Collective: [input]</span>"
		for(var/mob/dead in dead_mob_list)
			dead << "<span class='cybermancollective'>Cyberman Collective: [input]</span>"
