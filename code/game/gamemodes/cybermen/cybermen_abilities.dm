
/obj/effect/proc_holder/cyberman
	panel = "Cyberman"

/obj/effect/proc_holder/cyberman/proc/get_user_selected_hack(var/mob/living/carbon/human/user = usr, var/null_option)
	var/list/hacks = list()
	for(var/obj/effect/cyberman_hack/hack in ticker.mode.active_cybermen_hacks)
		hacks += hack.target_name
	if(null_option)
		hacks += null_option
	var/target_hack_name = input(usr, "Choose which hack you wish to contribute to:", "Cyberman Hack Management") as anything in hacks
	if(!target_hack_name || target_hack_name == null_option)
		return null
	var/obj/effect/cyberman_hack/target_hack = null
	for(var/obj/effect/cyberman_hack/hack in ticker.mode.active_cybermen_hacks)//this will have issues if two different hacked objects have the same name.
		if(hack.target_name == target_hack_name)
			target_hack = hack
			break
	return target_hack

/obj/effect/proc_holder/cyberman/commune
	name = "Cyberman Broadcast"
	desc = "Communicate with fellow cybermen. Completely undetectable, but cannot be done if you have been recently EMPed."

/obj/effect/proc_holder/cyberman/commune/Click()
	if(!(usr.mind && usr.mind.cyberman))
		usr << "You are not a cyberman, you should not be able to do this!"
		return 0
	if(!usr.mind.cyberman.emp_hit)
		var/input = stripped_input(usr, "Enter a message to share with all other Cybermen.", "Cybermen Broadcast", "")
		if(input)
			for(var/datum/mind/cyberman in ticker.mode.cybermen)
				var/distorted_message = input
				if(cyberman.cyberman.emp_hit)
					distorted_message = Gibberish2(input, cyberman.cyberman.emp_hit*1.6)
				cyberman.current << "<span class='cyberman'>Cyberman Broadcast: [distorted_message]</span>"
			for(var/datum/mind/dead in dead_mob_list)
				dead << "<span class='cyberman'>Cyberman Broadcast: [input]</span>"
		return 1
	else
		usr << "<span class='notice'>You were hit by an EMP recently, you cannot use the cyberman broadcast!</span>"
		return 0

/mob/living/proc/cyberman_hack(var/atom/target in world)//for the context menu option. Disabled for now becuase middle-click works just fine..
	//set category = ""//automatically goes in "Commands" tab.
	set name = "Hack"
	usr.mind.cyberman.initiate_hack(target)

/obj/effect/proc_holder/cyberman/cyberman_toggle_quickhack
	name = "Prepare Hacking"
	desc = "Enable or disable your cyberman hacking module."

/obj/effect/proc_holder/cyberman/cyberman_toggle_quickhack/Click()
	if(usr.mind.cyberman)
		usr.mind.cyberman.quickhack = !usr.mind.cyberman.quickhack
		usr << (usr.mind.cyberman.quickhack ? "You prepare to hack nearby objects. Use alt- or middle-click to hack." : "You decide not to hack anything for the moment.")

/obj/effect/proc_holder/cyberman/cyberman_manual_select_hack
	name = "Select Current Hack"
	desc = "Select the hack you are contributing processing power to."

/obj/effect/proc_holder/cyberman/cyberman_manual_select_hack/Click()
	if(!usr || !usr.mind || !usr.mind.cyberman)
		return
	var/obj/effect/cyberman_hack/selected_hack = get_user_selected_hack(usr, "(automatic)")
	usr.mind.cyberman.select_hack(usr, selected_hack)

/obj/effect/proc_holder/cyberman/cyberman_cancel_hack//maybe this should open an "are you sure?" dialogue.
	name = "Cancel Hack"
	desc = "End a hack prematurely."

/obj/effect/proc_holder/cyberman/cyberman_cancel_hack/Click()
	if(!usr || !usr.mind || !usr.mind.cyberman)
		return
	var/obj/effect/cyberman_hack/selected_hack = get_user_selected_hack(usr, "(none)")
	usr.mind.cyberman.cancel_hack(usr, selected_hack)

/obj/effect/proc_holder/cyberman/cyberman_cancel_component_hack
	name = "Cancel Component Hack"//needs a new name
	desc = "End the closest component hack of a multiple-vector hack."

/obj/effect/proc_holder/cyberman/cyberman_cancel_component_hack/Click()
	if(!usr || !usr.mind || !usr.mind.cyberman)
		return
	var/obj/effect/cyberman_hack/selected_hack = get_user_selected_hack(usr, "(none)")
	usr.mind.cyberman.cancel_closest_component_hack(usr, selected_hack)

/obj/effect/proc_holder/cyberman/cyberman_disp_objectives
	name = "Display Objectives"
	desc = "Display all cyberman objectives that have been assigned so far."

/obj/effect/proc_holder/cyberman/cyberman_disp_objectives/Click()
	ticker.mode.display_all_cybermen_objectives(usr.mind)


/////////////////////////////////////////////
///////////////DEBUG/ADMIN///////////////////
/////////////////////////////////////////////
#ifdef CYBERMEN_DEBUG

/mob/living/verb/become_cyberman()
	set category = "Cyberman Debug"
	set name = "Become Cyberman"

	if(ticker.mode.is_cyberman(usr.mind))
		usr << "You are already a Cyberman!"
	else
		var/obj/effect/cyberman_hack/newHack = src.get_cybermen_hack()
		newHack.innate_processing = 10
		if(newHack)
			if(newHack.start())
				usr << "You are now becoming a Cyberman..."
			else
				usr << "Cyberman conversion failed."

/mob/living/verb/become_cyberman_instant()
	set category = "Cyberman Debug"
	set name = "Become Cyberman (Instant)"

	if(ticker.mode.is_cyberman(usr.mind))
		usr << "You are already a Cyberman!"
	else
		ticker.mode.add_cyberman(usr.mind)


/mob/living/verb/cyberman_defect()
	set category = "Cyberman Debug"
	set name = "Quit being a Cyberman"
	src << "Removing cyberman status..."
	ticker.mode.remove_cyberman(usr.mind)


/mob/living/verb/reroll_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Reroll Objective"
	ticker.mode.message_all_cybermen("Re-assigning current objective...")
	ticker.mode.cybermen_objectives -= ticker.mode.cybermen_objectives[ticker.mode.cybermen_objectives.len]
	ticker.mode.generate_cybermen_objective(ticker.mode.cybermen_objectives.len+1)
	ticker.mode.display_current_cybermen_objective()

/*
/mob/living/verb/select_new_cybermen_objective()


/mob/living/verb/select_next_cybermen_objective()

*/

/mob/living/verb/force_complete_cybermen_objective()
	set category = "Cyberman Debug"
	set name = "Force Complete Objective"
	var/datum/objective/cybermen/O = ticker.mode.cybermen_objectives[ticker.mode.cybermen_objectives.len]
	O.completed = 1

/mob/living/verb/start_auto_hack(var/atom/target in world)
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

/mob/living/verb/cybermen_collective_broadcast()
	set category = "Cyberman Debug"
	set name = "Cyberman Collective Broadcast"
	var/input = stripped_input(usr, "Enter a message to share with all other Cybermen. This message will not be distorted by EMP effects.", "Cybermen Collective Broadcast", "")
	if(input)
		for(var/datum/mind/cyberman in ticker.mode.cybermen)
			cyberman.current << "<span class='cyberman'>Cyberman Collective: [input]</span>"//need to find or make a better span class
	for(var/datum/mind/dead in dead_mob_list)
		dead << "<span class='cyberman'>Cyberman Collective: [input]</span>"

#endif