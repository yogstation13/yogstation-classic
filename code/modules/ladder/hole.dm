/obj/effect/portal/minewormhole

		name = "minewormhole"
		desc = "Looks unstable. Best to test it with the clown."
		icon = 'icons/obj/objects.dmi'
		icon_state = "anom"
		density = 1
		unacidable = 1//Can't destroy energy portals.
		creator = null
		anchored = 1.0
		precision = 0



/obj/effect/portal/minewormhole/attack_hand(mob/user)
	teleport(user)

/obj/effect/portal/minewormhole/attackby(obj/item/I, mob/user, params)
	teleport(user)

/obj/effect/portal/minewormhole/teleport(atom/movable/M)

/obj/effect/portal/minewormhole/teleport(atom/movable/M)
	if(istype(M, /obj/effect))	//sparks don't teleport
		return
	if(M.anchored && istype(M, /obj/mecha))
		return

	if(istype(M, /atom/movable))
		var/turf/target
		if(portals.len)
			var/obj/effect/portal/P = pick(portals)
			if(P && isturf(P.loc))
				target = P.loc
		if(!target)	return
		do_teleport(M, target, 1, 1, 0, 0) ///You will appear adjacent to the beacon

/obj/effect/portal/minewormhole/New(loc, turf/target, creator)
	..(loc, target, creator, -1)

