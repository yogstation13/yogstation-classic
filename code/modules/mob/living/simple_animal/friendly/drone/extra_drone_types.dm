
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /mob/living/simple_animal/drone/minedrone
 	name = "Mining Drone"
 	desc = "A specialized drone. This type has been created to mine and endure the arduous environment of some asteroids."
 	icon_state = "drone_mine"
 	icon_living = "drone_mine"
 	health = 90
 	maxHealth = 120
 	laws = \
 	"1. You may not in any way shape or form interact with any non-hostile, non-xenobiological life-forms on the asteroid or anywhere else, even in self defense, unless that being is another drone.\n"+\
 	"2. You may not harm or impede any non-xenobiological asteroid creatures, regardless of intent or circumstance.\n"+\
 	"3. Your goals are to mine, harvest, explore, and refine materials to the best of your abilities. You must never actively work against these goals."
 	sight = (SEE_TURFS | SEE_OBJS)
 	see_invisible = SEE_INVISIBLE_MINIMUM
 	picked = TRUE
 	light_on = 1
 	heavy_emp_damage = 20
 	health_repair_max = 0
 	alarms = list()
 	var/obj/item/scanner_storage
 	default_storage = /obj/item/weapon/storage/backpack/drone
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
	drone_type = /mob/living/simple_animal/drone/syndrone

// SYNDICATE SCOUT DRONES
// *A lot will be presumed on the fact that the drone is being puppeted by another mob.


/mob/living/simple_animal/drone/syndiscout
	name = "Syndicate Scout Drone"
	desc = "A strange dark-colored drone with a red syndicate emblem on the top of it."
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
	laws = \
	"1. Find that fukkin' disk.\n"
	seeStatic = 0 //Whether we see static instead of mobs, this one sees mobs fine.
	default_storage = null // so we don't get a fucking toolbox.
	default_hatmask = null
	var/mob/living/carbon/observer = null
	var/pinpointerslot // to handle the pinpointer slot.
	var/observing

/mob/living/simple_animal/drone/syndiscout/say()
	return

/mob/living/simple_animal/drone/syndiscout/Login()
	..()
	src << "<span class='notice'>You can terminte the view of the drone by clicking terminate link and hide under tables and other furniture with the hide ability.</span>"

/mob/living/simple_animal/drone/syndiscout/New()
	..()
	access_card = new /obj/item/weapon/card/id(src)
	var/datum/job/assistant/C = new /datum/job/assistant
	access_card.access = C.get_access()

/mob/living/simple_animal/drone/syndiscout/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/syndiscoutController))
		var/obj/item/device/syndiscoutController/C = W
		C.icon_state = "phone connecting"
		C.item_state = "phone connecting"
		user << "<span class='notice'>You begin uploading the drones software into the controller and creating a bridge between the two.</span>"
		if(do_after(user, 60, target = src))
			C.icon_state = "base phone"
			C.item_state = "base phone"
			if(C.linked)
				user << "<span class='warning'>[C] is already linked to a drone!</span>"
				return
			user << "<span class='notice'>You link [C] to [src].</span>"
			C.linkedDrones.Add(src)
			C.linked = src
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

	if(istype(W, /obj/item/weapon/screwdriver))
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
		explosion(src, 5, -1, 1, 5)
		qdel(src)
		return

/mob/living/simple_animal/drone/syndiscout/proc/forceterminate()
	src << "<span class='warning'>Your control over the drone has been interrupted!</span>"
	src.mind.transfer_to(observer)
	observer = null
	observing = !observing //change back to 0 if doesn't work. same in verbs.dm
/*
/mob/living/simple_animal/drone/syndiscout/proc/puppet()
	spawn() while(observing)
		if(!observer || observer.stat || observer.weakened || observer.stunned)
			forceterminate()
			return 0
	sleep(1.5)
	return
*/

/mob/living/simple_animal/drone/syndiscout/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if(prob(25))
			src << "<span class='warning'>You crash into [M]!</span>"
			src.Stun(1)
			src.Weaken(1)
		else
			return
	if (istype(AM, /mob/living/silicon/robot))
		var/mob/living/silicon/S = AM
		src << "<span class='warning'>You aggressively crash into [S]!</span>"
		playsound(src.loc, 'sound/effects/bang.ogg', 10, 1)
		src.Stun(4)
		src.Weaken(3)

	return

/mob/living/simple_animal/drone/syndiscout/death()
	..()
	if(observing)
		src.mind.transfer_to(observer)
		observer << "<span class='warning'>The drone has taken too much damage! You have lost control over it.</span>"
		src.observer = null
		src.observing = 0

/mob/living/simple_animal/drone/syndiscout/emp_act(severity)
	if(observing)
		if(prob(25))
			src.mind.transfer_to(observer)
			observer << "<span class='warning'>The drone has suffered too much internal damage, you are losing connection with it!</span>"
			src.observer = null
			src.observing = 0

		else
			..()
			return
	else
		..()

/obj/item/drone_shell/syndronescout // this is here for another time
	name = "syndrone shell"
	desc = "A shell of a syndicate scout drone, once it's activated it's used to scout the station of any known powergamers on board."
	icon = 'icons/mob/scout_drone.dmi'
	icon_state = "base"
	drone_type = /mob/living/simple_animal/drone/syndrone
	origin_tech = "syndicate=2;biotech=3"

/obj/item/device/syndiscoutController
	name = "scout-drone controller"
	desc = "A device that's purpose seems to be controlling. This includes observing where they are, detonating them, and even controlling their movement. It's antenna seems to be useful for connecting the controller with a scouting drone, but requires patience."
	icon = 'icons/mob/scout_drone.dmi'
	icon_state = "base phone"
	item_state = "base phone"
	throwforce = 0
	w_class = 1
	throw_speed = 4
	throw_range = 7
	flags = CONDUCT
	origin_tech = "syndicate=3;magnets=4;engineering=5"
	var/list/linkedDrones = list()
	var/mob/living/simple_animal/drone/syndiscout/linked = null

/obj/item/device/syndiscoutController/New()
	..()
	var/turf/T = usr.loc
	new /mob/living/simple_animal/drone/syndiscout(T)

/obj/item/device/syndiscoutController/attack_self(mob/user)
	if(!ishuman(user))
		return user << "<span class='alert'>You don't know how to operate this!</span>"

	if(user.restrained() || user.lying || user.stat || user.stunned || user.weakened)
		return

	switch(alert("Select an option.","Controller Options", "Control Scouting Drone","Terminate Drone Link"))
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
				SSD.observer = user
				SSD.observer.mind.transfer_to(SSD)
				SSD.observing = 1
				while (SSD.observing)
					sleep(40)
					if(!SSD.observer || SSD.observer.stat || SSD.observer.weakened || SSD.observer.stunned || SSD.observer.restrained())
						SSD.forceterminate()
						break

					if(!(SSD.observer.loc == hotspot))
						SSD.forceterminate()
						break
				return 1

		if("Terminate Drone Link")
			var/choice = input(user, "Tracking Drone to blow", "Connecting...") in linkedDrones
			var/mob/living/simple_animal/drone/syndiscout/DronesGunnaBlow = choice
			if(!linkedDrones.Find(DronesGunnaBlow))
				user << "<span class='alert'>The controller does not have any linked drones..</span>"
				return
			switch(alert("Are you sure about this? This will blow the drone up.", "Boom", "Yes", "No"))
				if("Yes")
					user << "<span class='notice'>You choose to blow up the drone.</span>"
					src.linkedDrones.Remove(DronesGunnaBlow)
					DronesGunnaBlow.detonate()
					src.icon_state = "phone error"
					src.item_state = "phone error"
				if("No")
					return