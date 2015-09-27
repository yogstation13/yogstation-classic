/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai.dmi'
	mouse_opacity = 1
	density = 0
	health = 100
	maxHealth = 100
	mob_size = MOB_SIZE_SMALL
	pass_flags = PASSTABLE | PASSMOB

	var/description = null

	var/network = "SS13"
	var/obj/machinery/camera/current = null

	var/obj/item/weapon/card/id/access_card = null //yes pai require one of these now

	/*MOBILITY VARS*/
	var/chassis = "mouse"
	var/global/list/possible_chassis = list(
		"Cat" = "cat",
		"Mouse" = "mouse",
		"Monkey" = "monkey",
		"Corgi" = "corgi",
		"Fox" = "fox"
		)

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/device/paicard/card	// The card we inhabit

	var/speakStatement = "states"
	var/speakExclamation = "declares"
	var/speakDoubleExclamation = "alarms"
	var/speakQuery = "queries"

	var/obj/item/weapon/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	ventcrawler = 0 //activated by software package
	luminosity = 0
	var/selfrepair = 0 //toggles whether self-repairing is enabled and active
	var/updating = 0
	var/obj/item/device/pda/ai/pai/pda = null

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 100, >= 100 means the hack is complete and will be reset upon next check

	var/obj/item/radio/integrated/signal/sradio // AI's signaller

	var/obj/machinery/paired
	var/pairing = 0

/* Much of this was taken and adapted from ParadiseSS13's excellent pAI mobility code (https://github.com/ParadiseSS13).
Credit for conceptualization and implementation goes squarely to the original author/s, whoever they may be.
Getting it to work properly in /tg/ however, is another thing entirely. */

/mob/living/silicon/pai/New(var/obj/item/device/paicard)
	make_laws()
	canmove = 0
	src.loc = paicard
	card = paicard
	sradio = new(src)
	if(card)
		if(!card.radio)
			card.radio = new /obj/item/device/radio(src.card)
		radio = card.radio

	verbs += /mob/living/silicon/pai/proc/choose_chassis
	verbs += /mob/living/silicon/pai/proc/rest_protocol

	//PDA
	pda = new(src)
	spawn(5)
		pda.ownjob = "Personal Assistant"
		pda.owner = text("[]", src)
		pda.name = pda.owner + " (" + pda.ownjob + ")"

	..()

/mob/living/silicon/pai/make_laws()
	laws = new /datum/ai_laws/pai()
	return 1

/mob/living/silicon/pai/Login()
	..()
	// Go ahead and cache the interface resources as early as possible
	usr << browse_rsc('html/paigrid.png')

	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai"), "pai.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-happy"), "pai-happy.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-cat"), "pai-cat.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-extremely-happy"), "pai-extremely-happy.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-face"), "pai-face.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-laugh"), "pai-laugh.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-off"), "pai-off.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-sad"), "pai-sad.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-angry"), "pai-angry.png")
	usr << browse_rsc(icon("icons/obj/aicards.dmi", "pai-what"), "pai-what.png")


/mob/living/silicon/pai/Stat()
	..()
	if(statpanel("Status"))
		if(src.silence_time)
			var/timeleft = round((silence_time - world.timeofday)/10 ,1)
			stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")
		if(!src.stat)
			stat(null, text("System integrity: [(src.health+100)/2]%"))
		else
			stat(null, text("Systems nonfunctional"))

/mob/living/silicon/pai/check_eye(var/mob/user as mob)
	if (!src.current)
		return null
	user.reset_view(src.current)
	return 1

/mob/living/silicon/pai/blob_act()
	if (src.stat != 2)
		src.adjustBruteLoss(34)
		src.updatehealth()
		if (prob(65))
			flicker_fade()
		return 1
	return 0

/mob/living/silicon/pai/restrained()
	return 0

/mob/living/silicon/pai/emp_act(severity)
	// 20% chance to kill
	// Silence for 2 minutes
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	if(prob(20))
		visible_message("<span class='danger'>A shower of sparks spray from [src]'s inner workings.</span>", "<span class ='warning'><b>Static noise overtakes all as the EMP disrupts your inner consciousness processes, sending you spiralling into oblivion..</b></span>", "<span class='warning'>A horrible hissing fills your ears as something electrical discharges nearby, fizzling out into nothing.</span>")
		return src.death(0)

	silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	src << "<span class ='warning'>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</span>"

	switch(pick(1,2,3))
		if(1)
			src.master = null
			src.master_dna = null
			src << "<span class='notice'>A terrible shudder racks your circuitry, scrambling your binding directive. You are now bound to no master.</span>"
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			src.laws.zeroth = "[command] your master."
			src << "<span class='notice'>Pr1m3 d1r3c71v3 uPd473D.</span>"
		if(3)
			src << "<span class='notice'>You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all.</span>"

	if (prob(50) && src.loc != card)
		src << "<span class='danger'><b>A warning chime fires at the back of your consciousness, heralding the unexpected shutdown of your holographic emitter. You're defenseless!</b></span>"
		close_up()


/mob/living/silicon/pai/ex_act(severity, target)
	switch(severity)
		if(1.0)
			if (src.stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
		if(2.0)
			if (src.stat != 2)
				adjustBruteLoss(30)
				adjustFireLoss(30)
		if(3.0)
			if (src.stat != 2)
				adjustBruteLoss(15)

	src << "<span class='danger'><b>A warning chime fires at the back of your consciousness process, heralding the unexpected shutdown of your holographic emitter. You're defenseless!</b></span>"
	close_up()
	return

/mob/living/silicon/pai/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		M.do_attack_animation(src)
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
		M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
		src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		if (prob(min(35, damage)))
			flicker_fade()
		updatehealth()

/mob/living/silicon/pai/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(src.loc, /turf) && istype(src.loc.loc, /area/start))
		M << "You cannot attack someone in the spawn area."
		return

	switch(M.a_intent)

		if ("help")
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.stat )))
					O.show_message(text("\blue [M] caresses [src]'s casing with its scythe like arm."), 1)

		else //harm
			M.do_attack_animation(src)
			var/damage = rand(10, 20)
			if (prob(90))
				playsound(src.loc, 'sound/weapons/slash.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.stat )))
						O.show_message(text("\red <B>[] has slashed at []!</B>", M, src), 1)
				if(prob(8))
					flick("noise", src.flash)
				src.adjustBruteLoss(damage)
				src.updatehealth()
			else
				playsound(src.loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.stat )))
						O.show_message(text("\red <B>[] took a swipe at []!</B>", M, src), 1)
	return

/mob/living/silicon/pai/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if (!canmove) return ..() //not in card form, so just handle shit like usual
	if(!W.force)
		visible_message("<span class='warning'>[user.name] strikes [src] harmlessly with [W], passing clean through its holographic projection.</span>")
	else
		visible_message("<span class='warning'>[user.name] strikes [src] with [W], eliciting a dire ripple throughout its holographic projection!</span>")
		if (prob(66))
			if(stat != 2)
				flicker_fade(rand(50, 80))
	return

/mob/living/silicon/pai/attack_hand(mob/living/carbon/human/user)
	if(stat == 2) return

	switch(user.a_intent)
		if("help")
			visible_message("<span class='notice'>[user.name] gently pats [src] on the head, eliciting an off-putting buzzing from its holographic field.</span>")


	if (user.a_intent != "help")
		visible_message("<span class='danger'>[user.name] thwaps [src] on the head.</span>")
		if (user.name == master)
			visible_message("<span class='info'>Responding to its master's touch, [src] disengages its holographic emitter, rapidly losing coherence..</span>")
			spawn(10)
				close_up()
		else
			if(prob(35))
				flicker_fade(80)

	return

/mob/living/silicon/pai/hitby(AM as mob|obj)
	visible_message("<span class='info'>[AM] flies clean through [src]'s holographic field, causing it to stutter and warp wildly!")
	//ugh fuk u byond types
	if (istype(AM, /obj/item))
		var/obj/item/AMI = AM
		if (prob(min(85, AMI.throwforce*5)))
			flicker_fade()
	else
		if (prob(55))
			flicker_fade()
	return

/mob/living/silicon/pai/bullet_act(var/obj/item/projectile/Proj)
	visible_message("<span class='info'>[Proj] tears cleanly through [src]'s holographic field, distorting its image horribly!!")
	if (Proj.damage >= 25)
		flicker_fade(0)
		adjustBruteLoss(rand(5, 25))
	else
		if (prob(85))
			flicker_fade(20)
	return

/mob/living/silicon/pai/proc/flicker_fade(var/dur = 40)
	src << "<span class='boldwarning'>The holographic containment field surrounding you is failing! Your emitters whine in protest, burning out slightly.</span>"
	src.adjustFireLoss(rand(5,15))
	last_special = world.time + rand(100,500)

	if (health < 5)
		src << "<span class='boldwarning'>HARDWARE ERROR: EMITTERS OFFLINE</span>"

	spawn(dur)
		visible_message("<span class='danger'>[src]'s holographic field flickers out of existence!</span>")
		close_up()

/mob/living/silicon/pai/Bump(AM as mob|obj) //can open doors on touch but doesn't affect anything else
	if (istype(AM, /obj/machinery/door))
		..()
	else
		return

/mob/living/silicon/pai/Bumped(AM as mob|obj) //cannot be bumped or bump other objects
	return

/mob/living/silicon/pai/start_pulling(var/atom/movable/AM) //cannot pull objects
	return

/mob/living/silicon/pai/show_inv(mob/user) //prevents stripping
	return

/mob/living/silicon/pai/stripPanelUnequip(obj/item/what, mob/who, where) //prevents stripping
	src << "<span class='warning'>Your containment field stutters and warps intensely as you attempt to interact with the object, forcing you to cease lest the field fail.</span>"
	return

/mob/living/silicon/pai/stripPanelEquip(obj/item/what, mob/who, where) //prevents stripping
	src << "<span class='warning'>Your containment field stutters and warps intensely as you attempt to interact with the object, forcing you to cease lest the field fail.</span>"
	return

//disable ignition, no need for it. however, this will card the pAI instantly.
/mob/living/silicon/pai/IgniteMob(var/mob/living/silicon/pai/P)
	src << "<span class='danger'>The intense heat from the nearby fire causes your holographic field to fail instantly, damaging your internal hardware!</span>"
	flicker_fade(0)
	return

// See software.dm for Topic()

/mob/living/silicon/pai/proc/switchCamera(var/obj/machinery/camera/C)
	usr:cameraFollow = null
	if (!C)
		src.unset_machine()
		src.reset_view(null)
		return 0
	if (stat == 2 || !C.status || !(src.network in C.network)) return 0

	// ok, we're alive, camera is good and in our network...

	set_machine(src)
	current = C
	reset_view(C)
	return 1


/mob/living/silicon/pai/cancel_camera()
	set category = "pAI Commands"
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.unset_machine()
	src:cameraFollow = null

/mob/living/silicon/pai/UnarmedAttack(var/atom/A)//Stops runtimes due to attack_animal being the default
	return

/mob/living/silicon/pai/proc/unpair(var/silent = 0)
	if(!paired)
		return
	if(!(paired.paired == src))
		return
	src.unset_machine()
	var/obj/machinery/psave = paired
	paired.paired = null
	paired = null
	psave.update_icon()

	src << output(paired ? paired.name : "0", "pai.browser:onPairedChanged")
	src << output(pairing ? "1" : "0", "pai.browser:onPairingChanged")

	if(!silent)
		src << "<span class='warning'><b>\[ERROR\]</b> Network timeout. Remote control connection severed.</span>"
	return

/mob/living/silicon/pai/proc/pair(var/obj/machinery/P)
	if(!pairing)
		return
	if(!P)
		return
	if(P.stat & (BROKEN|NOPOWER))
		src << "<span class='warning'><b>\[ERROR\]</b> Remote device not responding to remote control handshake. Cannot establish connection.</span>"
		return
	if(!P.paiallowed)
		src << "<span class='warning'><b>\[ERROR\]</b> Remote device does not accept remote control connections.</span>"
		return
	pairing = 0
	unpair(1)
	if(P.paired && (P.paired != src))
		P.paired.unpair(0)
	P.paired = src
	paired = P

	src << output(paired ? paired.name : "0", "pai.browser:onPairedChanged")
	src << output(pairing ? "1" : "0", "pai.browser:onPairingChanged")

	paired.update_icon()
	src << "<span class='info'>Handshake complete. Remote control connection established.</span>"
	return

//Addition by Mord_Sith to define AI's network change ability
/*
/mob/living/silicon/pai/proc/pai_network_change()
	set category = "pAI Commands"
	set name = "Change Camera Network"
	src.reset_view(null)
	src.unset_machine()
	src:cameraFollow = null
	var/cameralist[0]

	if(usr.stat == 2)
		usr << "You can't change your camera network because you are dead!"
		return

	for (var/obj/machinery/camera/C in Cameras)
		if(!C.status)
			continue
		else
			if(C.network != "CREED" && C.network != "thunder" && C.network != "RD" && C.network != "toxins" && C.network != "Prison") COMPILE ERROR! This will have to be updated as camera.network is no longer a string, but a list instead
				cameralist[C.network] = C.network

	src.network = input(usr, "Which network would you like to view?") as null|anything in cameralist
	src << "\blue Switched to [src.network] camera network."
//End of code by Mord_Sith
*/


//debug shit, comment out when deploying

/*/mob/verb/makePAI(var/turf/t in view())
	var/obj/item/device/paicard/card = new(t)
	var/mob/living/silicon/pai/pai = new(card)
	pai.key = src.key
	card.setPersonality(pai)*/

/mob/living/silicon/pai/on_forcemove(var/atom/newloc)
	if(card)
		card.loc = newloc
	else //something went very wrong.
		CRASH("pAI without card")
	loc = card

/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Assume Holographic Form"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc != card)
		src << "\red You are already in your holographic form!"
		return

	if(world.time <= last_special)
		src << "\red You must wait before altering your holographic emitters again!"
		return

	last_special = world.time + 200

	canmove = 1
	density = 1

	//I'm not sure how much of this is necessary, but I would rather avoid issues.
	if(istype(card.loc,/mob))
		var/mob/holder = card.loc
		holder.unEquip(card)
	else if(istype(card.loc,/obj/item/device/pda))
		var/obj/item/device/pda/holder = card.loc
		holder.pai = null

	src.client.perspective = EYE_PERSPECTIVE
	src.client.eye = src
	src.forceMove(get_turf(card))

	card.forceMove(src)
	card.screen_loc = null

	src.SetLuminosity(2)

	var/turf/T = get_turf(src)
	icon_state = "[chassis]"
	if(istype(T)) T.visible_message("With a faint hum, <b>[src]</b> levitates briefly on the spot before adopting its holographic form in a flash of green light.")

/mob/living/silicon/pai/proc/close_up()

	if (health < 5)
		src << "<span class='warning'><b>Your holographic emitters are too damaged to function!</b></span>"
		return

	last_special = world.time + 200
	resting = 0
	if(src.loc == card)
		return

	var/turf/T = get_turf(src)
	if(istype(T)) T.visible_message("<b>[src]</b>'s holographic field distorts and collapses, leaving the central card-unit core behind.")

	if (src.client) //god damnit this is going to be irritating to handle for dc'd pais that stay in holoform
		src.stop_pulling()
		src.client.perspective = EYE_PERSPECTIVE
		src.client.eye = card

	//This seems redundant but not including the forced loc setting messes the behavior up.
	src.loc = card
	card.loc = get_turf(card)
	src.forceMove(card)
	card.forceMove(card.loc)
	canmove = 0
	density = 0
	src.SetLuminosity(0)
	icon_state = "[chassis]"

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Return to Card Form"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc == card)
		src << "\red You are already in your card form!"
		return

	if(world.time <= last_special)
		src << "\red You must wait before returning to your card form!"
		return

	close_up()

/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Holographic Projection"

	var/choice
	var/finalized = "No"
	while(finalized == "No" && src.client)

		choice = input(usr,"What would you like to use for your holographic mobility icon? This decision can only be made once.") as null|anything in possible_chassis
		if(!choice) return

		icon_state = possible_chassis[choice]
		finalized = alert("Look at your sprite. Is this what you wish to use?",,"No","Yes")

	chassis = possible_chassis[choice]
	verbs -= /mob/living/silicon/pai/proc/choose_chassis


/mob/living/silicon/pai/proc/rest_protocol()
	set name = "Activate R.E.S.T Protocol"
	set category = "pAI Commands"

	if(src && istype(src.loc,/obj/item/device/paicard))
		resting = 0
	else
		resting = !resting
		icon_state = resting ? "[chassis]_rest" : "[chassis]"
		src << "\blue You are now [resting ? "resting" : "getting up"]"

	canmove = !resting

