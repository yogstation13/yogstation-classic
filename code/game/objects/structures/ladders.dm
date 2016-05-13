/obj/structure/ladder
	name = "ladder"
	desc = "A ladder.  You can climb it up and down."
	icon_state = "ladderdown"
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1

	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

/obj/structure/ladder/initialize()
	// the upper will connect to the lower
	if(allowed_directions & DOWN) //we only want to do the top one, as it will initialize the ones before it.
		for(var/obj/structure/ladder/L in GetBelow(src))
			if(L.allowed_directions & UP)
				target_down = L
				L.target_up = src
				return
	update_icon()

/obj/structure/ladder/Destroy()
	if(target_down)
		target_down.target_up = null
		target_down = null
	if(target_up)
		target_up.target_down = null
		target_up = null
	return ..()

/obj/structure/ladder/attackby(obj/item/C as obj, mob/user as mob)
	attack_hand(user)
	return

/obj/structure/ladder/attack_hand(var/mob/M)
	var/move = moveOccupant(M)
	if(move)
		var/text = (move == UP ? "up" : "down")
		M.visible_message("<span class='notice'>\The [M] climbs [text] \the [src]!</span>",
		"You climb [text] \the [src]!",
		"You hear the grunting and clanging of a metal ladder being used.")

/obj/structure/ladder/proc/moveOccupant(var/mob/M)
	if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf) || (target_down && !istype(target_down.loc,/turf))))
		M << "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>"
		return 0
	var/obj/structure/ladder/target = target_down ? target_down : target_up
	if(target_down && target_up)
		switch(alert(M,"Do you want to go up or down?", "Ladder", "Up", "Down", "Cancel"))
			if("Up")
				target = target_up
			if("Down")
				target = target_down
			if("Cancel")
				return 0
	if(!target)
		return 0

	var/turf/T = target.loc
	for(var/atom/A in T)
		if(!A.CanPass(M))
			M << "<span class='notice'>\The [A] is blocking \the [src].</span>"
			return 0
	if(M.Move(T))
		return target == target_up ? UP : DOWN
	return 0

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/ladder/attack_ghost(var/mob/M)
	moveOccupant(M)

/obj/structure/ladder/update_icon()
	icon_state = "ladder[!!(allowed_directions & UP)][!!(allowed_directions & DOWN)]"

/obj/structure/ladder/up
	allowed_directions = UP

/obj/structure/ladder/updown
	allowed_directions = UP|DOWN

