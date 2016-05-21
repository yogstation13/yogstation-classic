
////////////////////
//MORE DRONE TYPES//
////////////////////
//Drones with custom laws
//Drones with custom shells
//Drones with overriden procs


//More types of drones
/mob/living/simple_animal/drone/syndrone
	name = "Syndrone"
	desc = "A modified maintenance drone. This one brings with it the feeling of terror."
	icon_state = "drone_synd"
	icon_living = "drone_synd"
	picked = TRUE //the appearence of syndrones is static, you don't get to change it.
	health = 30
	maxHealth = 120 //If you murder other drones and cannibalize them you can get much stronger
	faction = list("syndicate")
	heavy_emp_damage = 10
	laws = \
	"1. Interfere.\n"+\
	"2. Kill.\n"+\
	"3. Destroy."
	default_storage = /obj/item/device/radio/uplink
	default_hatmask = /obj/item/clothing/head/helmet/space/hardsuit/syndi
	seeStatic = 0 //Our programming is superior.


/mob/living/simple_animal/drone/syndrone/New()
	..()
	if(internal_storage && internal_storage.hidden_uplink)
		internal_storage.hidden_uplink.uses = (initial(internal_storage.hidden_uplink.uses) / 2)
		internal_storage.name = "syndicate uplink"


/mob/living/simple_animal/drone/syndrone/Login()
	..()
	src << "<span class='notice'>You can kill and eat other drones to increase your health!</span>" //Inform the evil lil guy


/obj/item/drone_shell/syndrone
	name = "syndrone shell"
	desc = "A shell of a syndrone, a modified maintenance drone designed to infiltrate and annihilate."
	icon_state = "syndrone_item"
	drone_type = /mob/living/simple_animal/drone/syndrone

////////////////////////////////////////////////////////////Minedrones////////////////////////////////////////////////////////////////////
/mob/living/simple_animal/drone/minedrone
	name = "Minedrone"
	desc = "A specialized drone. This type has been created to mine and endure the arduous environment of some asteroids."
	icon_state = "drone_mine"
	icon_living = "drone_mine"
	health = 80
	maxHealth = 80
	laws = \
	"1. You may not in any way shape or form interact with any non-hostile, non-xenobiological life-forms on the asteroid or anywhere else, even in self defense, unless that being is another drone.\n"+\
	"2. You may not harm or impede any non-xenobiological asteroid creatures, regardless of intent or circumstance.\n"+\
	"3. Your goals are to mine, harvest, refine materials, and explore to the best of your abilities. You must never actively work against these goals, however you may obtain tools that improve your abilities."
	sight = (SEE_TURFS)
	see_invisible = SEE_INVISIBLE_MINIMUM
	picked = TRUE
	light_on = 0
	heavy_emp_damage = 20
	health_repair_max = 0
	alarms = list()
	var/obj/item/scanner_storage
	default_storage = /obj/item/weapon/storage/backpack/minedrone
	default_hatmask = /obj/item/clothing/head/helmet/space/hardsuit
	var/obj/item/scanner = /obj/item/device/t_scanner/adv_mining_scanner
	seeStatic = 0

/obj/item/drone_shell/minedrone
	name = "minedrone shell"
	desc = "A shell of a mining drone- a specialized drone that has been designed for working in the mines."
	icon_state = "minedrone_item"
	drone_type = /mob/living/simple_animal/drone/minedrone

/mob/living/simple_animal/drone/minedrone/New()
	..()

	qdel(access_card)
	access_card = new /obj/item/weapon/card/id(src)
	var/datum/job/mining/M = new /datum/job/mining
	access_card.access = M.get_access()

	if(scanner)
		var/obj/item/I = new scanner(src)
		equip_to_slot_or_del(I, "internal_storage_2")

/mob/living/simple_animal/drone/minedrone/Login()
	..()
	update_inv_internal_storage_2()

/mob/living/simple_animal/drone/minedrone/Destroy()
	qdel(default_storage)
	qdel(scanner_storage)
	..()

/mob/living/simple_animal/drone/minedrone/unEquip(obj/item/I, force)
	if(..(I,force))
		update_inv_hands()
		if(I == scanner_storage)
			scanner_storage = null
			update_inv_internal_storage_2()
		return 1
	return 0

/mob/living/simple_animal/drone/minedrone/can_equip(obj/item/I, slot)
	if (slot == "internal_storage_2")
		if(scanner_storage)
			return 0
		return 1
	return ..()

/mob/living/simple_animal/drone/minedrone/get_item_by_slot(slot_id)
	if (slot_id == "internal_storage_2")
		return scanner_storage
	return ..()

/mob/living/simple_animal/drone/minedrone/equip_to_slot(obj/item/I, slot)
	if(!slot)	return
	if(!istype(I))	return


	if(I == l_hand)
		l_hand = null
	else if(I == r_hand)
		r_hand = null
	update_inv_hands()
	I.screen_loc = null
	I.loc = src
	I.equipped(src, slot)
	I.layer = 20

	if (slot == "internal_storage_2")
		scanner_storage = I
		update_inv_internal_storage_2()
	return ..()

/mob/living/simple_animal/drone/minedrone/quick_equip()
	var/obj/item/I = get_active_hand()
	if(istype(I, /obj/item/device))
		equip_to_slot(I, "internal_storage_2")
	else ..()



// SYNDICATE SCOUT DRONES
// *A lot will be presumed on the fact that the drone is being puppeted by another mob.
//*Currently not on in uplink_dm


/mob/living/simple_animal/drone/syndiscout
	name = "Syndicate Scout Drone"
	desc = "A shady looking drone with a red syndicate emblem on the top of it."
	icon = 'icons/mob/scout_drone.dmi'
	icon_state = "movement"
	icon_living = "movement"
	icon_dead = "base"
	health = 35
	maxHealth = 35
	faction = list("syndicate")
	pass_flags = PASSTABLE | PASSDOOR
	sight = (SEE_TURFS | SEE_OBJS)
	status_flags = (CANPUSH | CANSTUN | CANWEAKEN)
	voice_name = "squeals"
	has_unlimited_silicon_privilege = 0 // can't open doors. can scoot under them though.
	laws = null
	default_storage = null // so we don't get a fucking toolbox.
	default_hatmask = null
	var/mob/living/carbon/human/observer = null // the syndicate that's controlling them
	var/obj/item/device/syndiscoutController/controller = null // the controller itself.
	var/pinpointerslot // to handle the pinpointer slot.
	var/observing //handles the system for transferring minds
	var/tagging

	var/datum/action/SSD_hide/scouthide = new
	var/datum/action/terminate_drone_link/terminatelink = new

/mob/living/simple_animal/drone/syndiscout/say()
	return

/mob/living/simple_animal/drone/syndiscout/Login()
	..()
	src << "<span class='notice'>You can terminte the view of the drone by clicking terminate link and hide under tables and other furniture with the hide ability.</span>"
	scouthide.Grant(src)
	terminatelink.Grant(src)


/mob/living/simple_animal/drone/syndiscout/New()
	..()
	access_card = new /obj/item/weapon/card/id(src)
	var/datum/job/assistant/C = new /datum/job/assistant
	access_card.access = C.get_access()

/mob/living/simple_animal/drone/syndiscout/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/syndiscoutController))
		if(src.stat)
			user << "<span class='notice'>You can't connect to a dead drone!</span>"
		var/obj/item/device/syndiscoutController/C = W
		C.icon_state = "phone connecting"
		C.item_state = "phone connecting"
		user << "<span class='notice'>You begin connecting the controller to the drone...</span>"
		if(do_after(user, 50, target = src))
			C.icon_state = "base phone"
			C.item_state = "base phone"
			if(C.linked)
				user << "<span class='warning'>[C] is already linked to a drone!</span>"
				return
			if(src.controller)
				user << "<span class='warning'>[src] is already linked to a controller!</span>"
				return
			user << "<span class='notice'>You link [C] to [src].</span>"
			C.linkedDrones.Add(src)
			C.linked = src
			src.controller = C
		else
			user << "<span class='warning'>The connection was aborted!</span>"
			C.icon_state = "phone error"
			C.item_state = "phone error"
			return
		return

	if(istype(W, /obj/item/weapon/pinpointer))
		var/obj/item/weapon/pinpointer/P = W
		if(pinpointerslot)
			user <<"<span class='warning'>The drone already has a pinpointer in it's storage slot!</span>"
			return 0

		if(!P.active)
			user << "<span class='warning'>The drone rejects the unactivated pinpointer!</span>"
			return

		equip_to_slot_or_del(W, "drone_storage_slot")
		pinpointerslot = 1
		qdel(W)

	if(istype(W, /obj/item/weapon/tool/screwdriver))
		var/obj/item/weapon/pinpointer/P
		if(pinpointerslot)
			src.equip_to_slot_or_del(P, "drone_storage_slot")
			new /obj/item/weapon/pinpointer(src.loc)
			src.pinpointerslot = 0
			user << "<span class='notice'>You unscrew the pinpointer out of [src].</span>"
			return
		else
			user << "<span class='warning'>There's nothing in the drone to unscrew!</span>"

	else
		..()



/mob/living/simple_animal/drone/syndiscout/proc/detonate()
	playsound(src, "sound/machines/defib_charge.ogg", 100, 0)
	spawn(10)
		explosion(src,0,0,3)
		qdel(src)
		return

/mob/living/simple_animal/drone/syndiscout/proc/forceterminate()
	src << "<span class='warning'>Your control over the drone has been interrupted!</span>"
	observer.puppetingSSD = 0
	src.mind.transfer_to(observer)
	observer = null
	observing = !observing

/mob/living/simple_animal/drone/syndiscout/death()
	..()
	if(observing)
		src.mind.transfer_to(observer)
		observer << "<span class='warning'>The drone has taken too much damage! You have lost control over it.</span>"
		observer.puppetingSSD = 0
		src.observer = null
		src.observing = 0
		controller = null


/mob/living/simple_animal/drone/syndiscout/emp_act(severity)
	if(observing)
		if(prob(25))
			src.mind.transfer_to(observer)
			observer << "<span class='warning'>The drone has suffered too much internal damage, you are losing connection with it!</span>"
			observer.puppetingSSD = 0
			src.observer = null
			src.observing = 0

		else
			..()
			return
	else
		..()

/mob/living/simple_animal/drone/syndiscout/ShiftClickOn(atom/movable/A, mob/user=usr)
	if(!tagging)
		return ..()

	if(controller == null)
		return user <<"<span class='warning'>This should not be happening, inform a local coder, mod, or admin. </span>"

	if(A == user)
		return user <<"<span class='warning'>You cannot tag the drone itself!</span>"

	if(istype(A, /obj/item))
		return user <<"<span class='warning'>You cannot tag items!</span>"

	if(istype(A, /mob/living))
		user << "<span class='notice'>Target found . . .</span>"
		if(!ishuman(A) && !issilicon(A))
			user << "<span class='warning'>Unable to tag target. Aborting.</span>"
			return
		user << "<span class='alert'>Scanning...</span>"
		icon_state = "scan"
		icon_living = "scan"
		if(do_after(user, 20, target = user))
			icon_state = "movement"
			icon_living = "movement"
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				var/registered_name
				var/registered_job
				var/lastarea = get_area(A)

				if(H.name == "Unknown")
					registered_name = "Unknown"
					registered_job = "Unknown"
				else
					var/obj/item/weapon/card/id/ID = H.get_idcard()
					registered_name = ID.registered_name
					registered_job = ID.assignment

				user << "<span class='notice'>Transmission complete! Information has been sent to the drone's controller.</span>"
				controller.tag_information = "Name: [registered_name] ([registered_job]) /  Last Seen in [lastarea]"
				return


			else
				var/mob/living/silicon/S = A
				user << "<span class='notice'>Transmission complete! Information has been sent to the drone's controller.</span>"
				if(isAI(A))
					var/mob/living/silicon/ai/L = A
					lastarea = get_area(L.eyeobj)
					controller.tag_information = "Name:[L.name] (Experimental AI) / AI eye last detected in [lastarea]"
					/* possible nerf if required.
					var/alert1 = get_area(user)
					var/alert2 = get_area(src.observer)
					var/alert = pick("You have detected a foreign presence scanning your software located in [alert1]", "You have detected bizzare readings coming from [alert2]")
					if(prob(10))
						L << "<span class='danger'>[alert]</span>"
					*/
				if(isrobot(A))
					controller.tag_information = "Name:[S.name] (Cyborg) /  Last seen in [lastarea]"
				return

		else
			icon_state = "movement"
			icon_living = "movement"
			user << "<span class='warning'>The drone has stopped tagging [A]</span>"
			return

	else
		return usr << "<span class='warning'>You are unable to tag the target.</span>"

/*
/obj/item/drone_shell/syndronescout
	name = "syndrone shell"
	desc = "A shell of a syndicate scout drone, once it's activated it's used to scout the station of any known powergamers on board."
	icon = 'icons/mob/scout_drone.dmi'
	icon_state = "base"
	drone_type = /mob/living/simple_animal/drone/syndrone
	origin_tech = "syndicate=2;biotech=3"
*/

/obj/item/device/syndiscoutController
	name = "scout-drone controller"
	desc = "A device which looks oddly like a game controller. This includes observing where they are, detonating them, and even controlling their movement. It's antenna seems to be useful for connecting the controller with a scouting drone, but requires patience."
	icon = 'icons/mob/scout_drone.dmi'
	icon_state = "base phone"
	item_state = "base phone"
	throwforce = 3
	w_class = 1
	throw_speed = 4
	throw_range = 7
	flags = CONDUCT
	origin_tech = "syndicate=2;engineering=5;biotech=3"
	var/list/linkedDrones = list()
	var/mob/living/simple_animal/drone/syndiscout/linked = null
	var/tag_information = null

/obj/item/device/syndiscoutController/New()
	..()
	var/turf/T = usr.loc
	new /mob/living/simple_animal/drone/syndiscout(T)

/obj/item/device/syndiscoutController/attack_self(mob/user)
	if(!ishuman(user))
		return user << "<span class='alert'>You can't seem to operate this!</span>"

	if(user.restrained() || user.lying || user.stat || user.stunned || user.weakened)
		return

	switch(alert("Select an option.","Controller Options", "Control Scouting Drone","Blow Drone", "Clear Tags"))
		if("Control Scouting Drone")
			var/choice = input(user, "Tracking linked scouting drone", "Connecting...") in linkedDrones
			var/mob/living/simple_animal/drone/syndiscout/SSD = choice
			if (!src.linkedDrones.Find(SSD))
				user << "<span class='alert'>The controller does not have any linked drones.</span>"
				return

			if (src.linkedDrones.Find(SSD) && SSD.stat)
				user << "<span class='alert'>The controller can't seem to connect to it's drone. Aborting transmission.</span>"
				src.linkedDrones.Remove(SSD)
				return

			if (src.linkedDrones.Find(SSD))
				var/atom/hotspot = user.loc
				var/start = user.z
				var/in_container
				var/container = null

				if(SSD.z != user.z && user.loc && !istype(user.loc, /obj) && isturf(user.loc))
					user << "<span class='warning'>The drone is too far away to control!</span>"
					return

				SSD.observer = user
				SSD.observer.mind.transfer_to(SSD)
				SSD.observer.puppetingSSD = 1
				SSD.observing = 1

				if (istype(SSD.observer.loc, /obj) && !isturf(SSD.observer.loc))
					in_container = 1
					container = get_turf(SSD.observer)

				while (SSD.observing)
					sleep(20) //orignally was 40.

					if(!SSD.observing)
						break

					if (SSD.z != start && !in_container) // if the drone goes off map.
						SSD.forceterminate()
						src.linkedDrones.Remove(SSD)
						SSD.controller = null
						user << "<span class='warning'>The drone is too far away to control! The contoller is going through a routine reboot!</span>"
						break

					if(!SSD.observer || SSD.observer.stat || SSD.observer.weakened || SSD.observer.stunned || SSD.observer.lying || SSD.observer.restrained() || !SSD.mind || (!(src in SSD.observer.contents)))
						SSD.forceterminate()
						break

					if(!(SSD.observer.loc == hotspot))
						SSD.forceterminate()
						break

					if(in_container)
						if(SSD.observer.loc != container) // checks if the container matches the observers location.
							SSD.forceterminate()
							break
				return 1

		if("Blow Drone")
			var/choice = input(user, "Tracking Drone to blow", "Connecting...") in linkedDrones
			var/mob/living/simple_animal/drone/syndiscout/DronesGunnaBlow = choice
			if(!linkedDrones.Find(DronesGunnaBlow))
				user << "<span class='alert'>The controller does not have any linked drones..</span>"
				return
			switch(alert("Are you sure about this? This will blow the drone up.", "Boom", "Yes", "No"))
				if("Yes")
					user << "<span class='notice'>You have choosen to detonate the drone.</span>"
					src.linkedDrones.Remove(DronesGunnaBlow)
					DronesGunnaBlow.detonate()
					src.icon_state = "phone error"
					src.item_state = "phone error"
				if("No")
					return

		if("Clear Tags")
			if(tag_information == null)
				user << "<span class='danger'>There are no tags avaliable in the controller's system.</span>"
				return
			tag_information = null
			user << "<span class='danger'>The system has successfully cleared the tag.</span>"
			return

/obj/item/device/syndiscoutController/examine(mob/user)
	. = ..()
	if(tag_information != null)
		user << "<span class='notice'>Last Tag:</span>"
		user << "<span class='notice'>[tag_information]</span>"
