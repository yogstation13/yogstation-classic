//This is a power switch. When turned on it looks at the cables around the tile that it's on and notes which cables are trying to connect to it.
//After it knows this it creates the number of cables from the center to each of the cables attempting to conenct. These cables cannot be removed
//with wirecutters. When the switch is turned off it removes all the cables on the tile it's on.
//The switch uses a 5s delay to prevent powernet change spamming for AIs and a 15 sec delay for other mobs.

/obj/structure/breaker/powerswitch
	name = "\improper fuse box"
	desc = "A box that controls power-flow."
	icon = 'icons/obj/breaker.dmi'
	icon_state = "tb_on"
	var/icon_state_on = "tb_on"
	var/icon_state_off = "tb_off"
	density = 0
	anchored = 1
	level = 1
	layer = 2.45
	var/on = 1
	var/busy = 0 //set to 1 when you start using it
	var/id = "placeholder"

/obj/structure/breaker/powerswitch/examine(mob/user)
	..()
	if(on)
		user << "The switch is in the on position"
	else
		user << "The switch is in the off position"

/obj/structure/breaker/powerswitch/attack_ai(mob/user)
	user << "\red You're an AI. This is a fuse box. It's not going to work."
	return

/obj/structure/breaker/powerswitch/attack_hand(mob/user)
	user << "\red You slam your hand into the fuse box really hard. That's not going to work."
	return

/obj/structure/breaker/powerswitch/proc/set_state(var/state)
	on = state
	if(on)
		icon_state = icon_state_on
		var/list/connection_dirs = list()
		for(var/direction in list(1,2,4,8,5,6,9,10))
			for(var/obj/structure/cable/C in get_step(src,direction))
				if(C.d1 == turn(direction, 180) || C.d2 == turn(direction, 180))
					connection_dirs += direction
					break

		for(var/direction in connection_dirs)
			var/obj/structure/cable/C = new/obj/structure/cable(src.loc)
			C.d1 = 0
			C.d2 = direction
			C.icon_state = "[C.d1]-[C.d2]"
			//C.power_switch = src

			var/datum/powernet/PN = new()
			PN.number = powernets.len + 1
			powernets += PN
			//C.netnum = PN.number
			PN.cables += C

			C.mergeConnectedNetworks(C.d2)
			C.mergeConnectedNetworksOnTurf()

	else
		icon_state = icon_state_off
		for(var/obj/structure/cable/C in src.loc)
			qdel(C)

////////////////////////
// ELECTRONIC BREAKER //
////////////////////////


/obj/structure/breaker/ebreaker
	name = "\improper electronic breaker box"
	desc = "An electronic control device which controls a fuse box."
	icon = 'icons/obj/breaker.dmi' //bunch of unused sprites for it in here.
	icon_state = "ebreaker_on"
	density = 0
	anchored = 1
	req_access_txt = 11
	var/id = "placeholder" //this works the same way as buttons work
	var/on = 1
	var/locked = 1 //starts locked at round-start
	var/emagged = 0 //if I ever fancy adding an emagged thing to it.

	var/sprite_on = "ebreaker_on"
	var/sprite_off = "ebreaker_off"
	var/sprite_working = "ebreaker_r"
	var/sprite_bsod = "ebreaker_bs"
	var/sprite_panel = "ebreaker_o"
	//var/sprite_unwired = "ebreaker_o_nw" //not used for now.

	var/panel_open = 0

/obj/structure/breaker/ebreaker/attack_ai(mob/user)//AI should have a shorter cooldown.

	if(emagged)
		user << "You begin resetting the [src] to factory settings. This may take some time."
		if(do_after(user, 200))
			emagged = 0
			update_sprite()
			user << "You finish restoring [src] to factory settings."
		return

	for(var/obj/structure/breaker/powerswitch/m in world)
		if(m.id == id)

			if(m.busy)//prevent spam
				user << "\red This breaker is already being toggled."
				return
			..()

			m.busy = 1
			icon_state = sprite_working
			for(var/mob/O in viewers(m)) //tell everyone something is going on
				O.show_message(text("\red [src] starts flickering."), 1)
			user << "\red You start reprogramming [src]. You use your processing power to speed the process up."

			if(do_after(user, 50))//do the stuff
				on = m.on
				m.set_state(!on)
				on = m.on

				for(var/mob/O in viewers(src)) //tell everyone the AI is a cunt
					O.show_message(text("\red \The [src] stops flickering. It has been switched to the [!on ? "on": "off"] setting."), 1)
				user << "\red You finish reprogramming [src]. It has been switched to the [!on ? "on": "off"] setting."

			update_sprite()
			m.busy = 0


/obj/structure/breaker/ebreaker/attack_hand(mob/user)
	if(locked)
		user << "\The [src] is locked."
		return

	if(panel_open)
		if(emagged)
			user << "You start restoring [src] to factory settings. This may take a while."
			if(do_after(user, 300))
				emagged = 0
				update_sprite()
				user << "You finish restoring [src] to factory settings."
				return
		return

	for(var/obj/structure/breaker/powerswitch/m in world)
		if(m.id == id)

			if(m.busy)//prevent spam
				user << "\red This [src] is already being toggled."
				return
			..()

			m.busy = 1
			icon_state = sprite_working
			for(var/mob/O in viewers(src)) //tell everyone something is going on
				if(O != user)
					O.show_message(text("\red [user] starts reprogramming the [src]."), 1)
			user << "\red You start reprogramming [src]."

			if(do_after(user, 150))//3x as long as AI toggling the breaker
				on = m.on
				m.set_state(!on)
				on = m.on

				for(var/mob/O in viewers(src)) //tell everyone the operation is done
					if(O != user)
						O.show_message(text("\red [user] reprograms [src]. It has been switched to the [on ? "on": "off"] setting."), 1)
				user << "\red You finish reprogramming [src]. It has been switched to the [on ? "on": "off"] setting."

			update_sprite()
			m.busy = 0

/obj/structure/breaker/ebreaker/examine(mob/user)
	..()
	if(locked)
		user << "\The [src] appears to be locked."
	else
		user << "\The [src] appears to be unlocked."
	if(on)
		user << "\The [src] is flowing power freely."
	else
		user << "Power-flow is cut off."

/obj/structure/breaker/ebreaker/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/card/id))
		if(panel_open) //can't lock/unlock if cover is open
			return
		if(emagged)
			user << "\red \The [src] does not respond to your commands."
			return
		if(check_access(W))
			if(locked)
				locked = 0
				user << "\red You unlock the [src]."
				return
			else
				locked = 1
				user << "\red You lock the [src]."
				return
		else
			user << "\red Insufficient Access."
			return

	if(istype(W, /obj/item/weapon/card/emag))
		if(panel_open)
			return
		if(locked)
			locked = 0
			user << "\red You unlock the [src]."
			emagged = 1
			update_sprite()
			for(var/mob/O in viewers(user))
				if(O != user)
					O << "<span class='danger'> [user] hacked [src] with [W]!"
			return
		else
			user << "\red You cannot lock [src] with [W]."
			return

	if(istype(W, /obj/item/weapon/crowbar))
		if(locked)
			user << "\red The cover does not come off."
			return
		if(panel_open == 0)
			panel_open = 1
		else
			panel_open = 0
		update_sprite()

/obj/structure/breaker/ebreaker/proc/update_sprite()
	/*
	var/sprite_on = "ebreaker_on"
	var/sprite_off = "ebreaker_off"
	var/sprite_working = "ebreaker_r"
	var/sprite_bsod = "ebreaker_bs"
	var/sprite_panel = "ebreaker_on¨

	for reference^^
	*/
	..()

	if(panel_open)
		icon_state = sprite_panel
		return
	else if(emagged)
		icon_state = sprite_bsod
		return
	else if(on)
		icon_state = sprite_on
		return
	else
		icon_state = sprite_off
		return