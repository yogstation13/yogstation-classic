//This is a power switch. When turned on it looks at the cables around the tile that it's on and notes which cables are trying to connect to it.
//After it knows this it creates the number of cables from the center to each of the cables attempting to conenct. These cables cannot be removed
//with wirecutters. When the switch is turned off it removes all the cables on the tile it's on.
//The switch uses a 5s delay to prevent powernet change spamming for AIs and a 15 sec delay for other mobs.

/obj/structure/breaker/powerswitch
	name = "\improper fuse box"
	desc = "A box that controls power-flow."
	icon = 'icons/obj/power.dmi'//devnote: change these
	icon_state = "switch-dbl-up"//devnote: change these
	var/icon_state_on = "switch-dbl-down"//devnote: change these
	var/icon_state_off = "switch-dbl-up"//devnote: change these
	density = 0
	anchored = 1
	var/on = 0
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

/////////////////////////
//  ELECTRONIC BREAKER //
//  WHAT AM I DOING?!  //
/////////////////////////


/obj/structure/breaker/ebreaker
	name = "\improper electronic breaker box"
	desc = "An electronic control device which controls a fuse box."
	icon = 'icons/obj/breaker.dmi' //bunch of unused sprites for it in here.
	icon_state = "ebreaker_on"
	density = 0
	anchored = 1
	var/id = "placeholder"
	var/on = 0


/obj/structure/breaker/ebreaker/attack_ai(mob/user)//AI should have a shorter cooldown.
	for(var/obj/structure/breaker/powerswitch/m in world)
		if(m.id == id)

			if(m.busy)//prevent spam
				user << "\red This breaker is already being toggled."
				return
			..()

			m.busy = 1
			for(var/mob/O in viewers(m)) //tell everyone something is going on
				O.show_message(text("\red [src] starts flickering."), 1)
			user << "\red You start reprogramming [src]. You use your processing power to speed the process up."

			if(do_after(user, 50))//do the stuff
				if(m.on == 1)
					on = 1
				else
					on = 0

				m.set_state(!on)

			for(var/mob/O in viewers(src)) //tell everyone the AI is a cunt
				O.show_message(text("\red \The [src] stops flickering. It has been switched to the [!on ? "on": "off"] setting."), 1)
			user << "\red You finish reprogramming [src]. It has been switched to the [!on ? "on": "off"] setting."

			if(m.on) //set sprite
				icon_state = "ebreaker_on"
			else
				icon_state = "ebreaker_off"
			m.busy = 0


/obj/structure/breaker/ebreaker/attack_hand(mob/user)
	for(var/obj/structure/breaker/powerswitch/m in world)
		if(m.id == id)

			if(m.busy)//prevent spam
				user << "\red This breaker is already being toggled."
				return
			..()

			m.busy = 1
			for(var/mob/O in viewers(src)) //tell everyone something is going on
				O.show_message(text("\red [user] starts reprogramming the breaker."), 1)
			user << "\red You start reprogramming [src]."

			if(do_after(user, 150))//3x as long as AI toggling the breaker
				if(m.on == 1)
					on = 1
				else
					on = 0

				m.set_state(!on)

			for(var/mob/O in viewers(src)) //tell everyone the operation is done
				if(O != user)
					O.show_message(text("\red [user] reprograms [src]. It has been switched to the [!on ? "on": "off"] setting."), 1)
			user << "\red You finish reprogramming [src]. It has been switched to the [!on ? "on": "off"] setting."

			if(m.on) //set sprite
				icon_state = "ebreaker_on"
			else
				icon_state = "ebreaker_off"
			m.busy = 0