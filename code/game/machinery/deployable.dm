/*
CONTAINS:

Deployable items
Barricades

for reference:

	access_security = 1
	access_brig = 2
	access_armory = 3
	access_forensics_lockers= 4
	access_medical = 5
	access_morgue = 6
	access_tox = 7
	access_tox_storage = 8
	access_genetics = 9
	access_engine = 10
	access_engine_equip= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emergency_storage = 14
	access_change_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_storage = 23
	access_atmospherics = 24
	access_bar = 25
	access_janitor = 26
	access_crematorium = 27
	access_kitchen = 28
	access_robotics = 29
	access_rd = 30
	access_cargo = 31
	access_construction = 32
	access_chemistry = 33
	access_cargo_bot = 34
	access_hydroponics = 35
	access_manufacturing = 36
	access_library = 37
	access_lawyer = 38
	access_virology = 39
	access_cmo = 40
	access_qm = 41
	access_court = 42

*/


//Barricades, maybe there will be a metal one later...
/obj/structure/barricade/wooden
	name = "wooden barricade"
	desc = "This space is blocked off by a wooden barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "woodenbarricade"
	anchored = 1.0
	density = 1.0
	var/health = 100.0
	var/maxhealth = 100.0

/obj/structure/barricade/wooden/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if (istype(W, /obj/item/stack/sheet/mineral/wood))
		if (src.health < src.maxhealth)
			visible_message("[user] begins to repair \the [src]!", "<span class='notice'>You begin to repair \the [src]...</span>")
			if(do_after(user,20, target = src))
				src.health = src.maxhealth
				W:use(1)
				visible_message("[user] repairs \the [src]!", "<span class='notice'>You repair \the [src].</span>")
				return
		else
			return
		return
	else
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 1
			if("brute")
				src.health -= W.force * 0.75
			else
		if (src.health <= 0)
			visible_message("<span class='warning'>The barricade is smashed apart!</span>")
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			new /obj/item/stack/sheet/mineral/wood(get_turf(src))
			qdel(src)
		..()

/obj/structure/barricade/wooden/ex_act(severity, target)
	switch(severity)
		if(1.0)
			visible_message("<span class='warning'>The barricade is blown apart!</span>")
			qdel(src)
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				visible_message("<span class='warning'>The barricade is blown apart!</span>")
				new /obj/item/stack/sheet/mineral/wood(get_turf(src))
				new /obj/item/stack/sheet/mineral/wood(get_turf(src))
				new /obj/item/stack/sheet/mineral/wood(get_turf(src))
				qdel(src)
			return

/obj/structure/barricade/wooden/blob_act()
	src.health -= 25
	if (src.health <= 0)
		visible_message("<span class='warning'>The blob eats through the barricade!</span>")
		qdel(src)
	return

/obj/structure/barricade/wooden/CanPass(atom/movable/mover, turf/target, height=0)//So bullets will fly over and stuff.
	if(height==0)
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0


//Actual Deployable machinery stuff

/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = 0.0
	density = 1.0
	icon_state = "barrier0"
	var/health = 100.0
	var/maxhealth = 100.0
	var/locked = 0.0
	var/obj/item/device/radio/attachedradio = null
	var/obj/item/device/encryptionkey/installedkey = null
	var/obj/item/device/assembly/signaler/attachedsignaler = null
	var/radio_freq
	var/initialdesc

//	req_access = list(access_maint_tunnels)

/obj/machinery/deployable/barrier/New()
	..()

	src.icon_state = "barrier[src.locked]"
	attachedradio = new /obj/item/device/radio(src)
	attachedradio.listening = 0
	attachedradio.frequency = 0 // since it generally defaults to commmons.
	initialdesc = desc

/obj/machinery/deployable/barrier/attackby(obj/item/weapon/W, mob/user, params)
	if (W.GetID())
		if (src.allowed(user))
			if	(src.emagged < 2.0)
				src.locked = !src.locked
				src.anchored = !src.anchored
				src.icon_state = "barrier[src.locked]"
				if ((src.locked == 1.0) && (src.emagged < 2.0))
					user << "Barrier lock toggled on."
					return
				else if ((src.locked == 0.0) && (src.emagged < 2.0))
					user << "Barrier lock toggled off."
					return
			else
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message("<span class='danger'>BZZzZZzZZzZT</span>")
				return
		return
	else if (istype(W, /obj/item/weapon/wrench))
		if (src.health < src.maxhealth)
			src.health = src.maxhealth
			src.emagged = 0
			src.req_access = list(access_security)
			visible_message("<span class='danger'>[user] repairs \the [src]!</span>")
			return
		else if (src.emagged > 0)
			src.emagged = 0
			src.req_access = list(access_security)
			visible_message("<span class='danger'>[user] repairs \the [src]!</span>")
			return
		return

	else if (istype(W, /obj/item/weapon/screwdriver))

		if (src.locked == 1.0)
			user << "<span class='danger'>You can't eject anything from the barrier while it's locked!</span>"
			return

		if (attachedsignaler)
			new /obj/item/device/assembly/signaler(src.loc)
			attachedsignaler = null
			desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
			initialdesc = desc
			desc_report() //puts the cherry ontop of our... codey sundae
			user.visible_message( \
						"[user] deattaches the signaler from the barrier.", \
						"<span class='notice'>You unscrew the signaler from the barrier.</span>")
			return

		if (installedkey)
			var/turf/T = get_turf(src.loc)
			if(T)
				installedkey.loc = T
				installedkey = null
			attachedradio.frequency = 0
			user.visible_message("[user] unscrews the encryption key from the barrier.")
			return


		if (!installedkey && !attachedsignaler)
			user << "<span class='danger'>[src] doesn't have anything to eject.</span>"
			return

	else if (istype(W, /obj/item/device/encryptionkey))

		if (src.locked == 1.0)
			user << "<span class='danger'>You can't install anything while the barrier is locked!</span>"
			return

		var/initialkey = installedkey

		if(installedkey)
			user << "[src] already has an encryption key installed!"
			return

		installedkey = W

		if(installedkey.channels.Find("Security"))
			visible_message("[src] swallows the encryption key and vibrates happily!")
			attachedradio.set_frequency(SEC_FREQ)
			radio_freq = SEC_FREQ
			user.unEquip(W)
			W.loc = src
			return

/*		Is this even needed? Only the future can tell.
		else if(installedkey.channels.Find("Syndicate"))
			if(src.emagged < 1)
				visible_message("[src] rejects the encryption key and vibrates aggressively!")
				installedkey = initialkey
				return
			else
				visible_message("[src] swallows the encryption key and vibrates happily!")
				attachedradio.set_frequency(SYND_FREQ)
				radio_freq = SYND_FREQ
				if (istype(W, /obj/item/device/encryptionkey/syndicate))
					installedkey = new /obj/item/device/encryptionkey/syndicate
				if (istype(W, /obj/item/device/encryptionkey))
					installedkey = new /obj/item/device/encryptionkey/binary
				return qdel(W) */

		else
			visible_message("[src] rejects the encryption key and vibrates angrily!")
			installedkey = initialkey
			return

	else if(issignaler(W))

		if(attachedsignaler)
			user << "<span class='notice'>There's a signaler attatched to the barrier!</span>"
			return

		attachedsignaler = W

		if(attachedsignaler.secured)
			user <<"<span class='danger'>The device is secured.</span>"
			attachedsignaler = null
			return

		if(!radio_freq)
			user << "<span class='danger'>There isn't an encryption key associated with the barrier to attach the signaler to!</span>"
			attachedsignaler = null
			return

		else
			user.visible_message( \
						"[user] attaches the signaler to the barrier.", \
						"<span class='notice'>You attach the signaler to the barrier.</span>")
			desc = "[src.desc] It also appears to have a remote signaling device attatched to it."
			initialdesc = desc
			qdel(W)
		return

	else
		user.changeNext_move(CLICK_CD_MELEE)
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 0.75
			if("brute")
				src.health -= W.force * 0.5
			else

		// examine damage notifiers.
		if (src.health <= 99)
			desc_report()


		if (src.health <= 0)
			attachedradio.talk_into(src, "Losing signal with the security channel!",radio_freq)
			src.explode()
		..()

		// This will send a message to the security channel if the barrier's radio is connected to it's frequency

		if (attachedradio.frequency == SEC_FREQ && !src.emagged) // security currently. emagging will disable this.
			if(!W.force)
				return

			var/thebarrier = "A deployable barrier"

			if(attachedsignaler)
				var/detectedarea = get_area(src)
				thebarrier = thebarrier + " located in [detectedarea]"

			var/damagereport
			if(W.force <= 5 && W.force != 0) // less or equal to 5
				damagereport = "a small amount of damage."
			if(W.force > 5 && W.force <= 15) // in the 5-15 range, but greater than 5
				damagereport = "a moderate amount of damage."
			if(W.force > 15) //greater than 15
				damagereport = "a large amount of damage."
			else if (!damagereport)
				return

			if(src.health <= 95 && src.health > 50)
				attachedradio.talk_into(src, "Alert! [thebarrier] is suffering [damagereport] The barriers rate of functionality is at [health]%!!",radio_freq)

			if(src.health <= 50 && src.health > 25)
				attachedradio.talk_into(src, "Alert! [thebarrier] is suffering [damagereport] The barriers rate of functionality is at [health]%!!",radio_freq)

			if(src.health <= 25 && src.health > 0)
				attachedradio.talk_into(src, "Alert! [thebarrier] is suffering [damagereport] The barriers rate of functionality is at [health]%!!",radio_freq)


/obj/machinery/deployable/barrier/proc/desc_report() // something to update the description of the barrier.

	if (src.health >= 61)
		desc = "[initialdesc] <span class='danger'>The barrier is slightly damaged.</span>"
		return

	if (src.health <= 60 && src.health >= 31)
		desc = "[initialdesc] <span class='danger'>The barrier seems to have taken a moderate amount of damage.</span>"
		return

	if (src.health <= 30 && src.health > 1)
		desc = "[initialdesc] <span class='danger'>The barrier appears to be severely damanged and in need of repair. </span>"
		return


/obj/machinery/deployable/emag_act(mob/user)
	if (src.emagged == 0)
		src.emagged = 1
		src.req_access = null
		user << "<span class='notice'>You break the ID authentication lock on \the [src].</span>"
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='danger'>BZZzZZzZZzZT</span>")
		return
	else if (src.emagged == 1)
		src.emagged = 2
		user << "<span class='notice'>You short out the anchoring mechanism on \the [src].</span>"
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='danger'>BZZzZZzZZzZT</span>")
		return

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			src.explode()
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				src.explode()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[src.locked]"

/obj/machinery/deployable/barrier/blob_act()
	src.health -= 25
	if (src.health <= 0)
		src.explode()
	return

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height=0)//So bullets will fly over and stuff.
	if(height==0)
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/deployable/barrier/proc/explode()

	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

/*	var/obj/item/stack/rods/ =*/
	new /obj/item/stack/rods(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	explosion(src.loc,-1,-1,0)
	playsound(src.loc, 'sound/effects/Explosion1.ogg',75,1)
	if(src)
		qdel(src)
