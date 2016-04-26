/obj/structure/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "optable"
	density = 1
	anchored = 1
	can_buckle = 1
	buckle_lying = 1
	buckle_requires_restraints = 1
	var/mob/living/carbon/human/patient = null
	var/obj/machinery/computer/operating/computer = null


/obj/structure/optable/New()
	for(var/dir in cardinal)
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if(computer)
			computer.table = src
			break


/obj/structure/optable/proc/check_patient()
	var/mob/M = locate(/mob/living/carbon/human, loc)
	if(M)
		if(M.resting)
			patient = M
			return 1
	else
		patient = null
		return 0


/obj/structure/optable/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(!G.confirm())
			return
		if(ismob(G.affecting))
			var/mob/M = G.affecting
			M.resting = 1
			M.loc = loc
			visible_message("<span class='notice'>[user] has laid [M] on [src].</span>")
			patient = M
			check_patient()
			qdel(W)
			return
	if(istype(W, /obj/item/weapon/wrench))
		if(!anchored)
			user.visible_message("[user.name] begins to secure the [src.name] to the floor.",\
								"<span class='notice'>You begin to secure the [src.name] to the floor.</span>", \
								"<span class='italics'>You hear a ratchet.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			if(do_after(user, 30, target = src))
				user.visible_message("[user.name] secured [src.name] to the floor.",\
								"<span class='notice'>You secure the [src.name] to the floor.</span>", \
								"<span class='italics'>You hear a ratchet.</span>")
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				anchored = 1
		else if(anchored)
			user.visible_message("[user.name] begins to unsecure the [src.name] from the floor.", \
				"<span class='notice'>You begin to unsecure the [src.name] from the floor.</span>", \
				"<span class='italics'>You hear a ratchet.</span>")
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			if(do_after(user, 30, target = src))
				user.visible_message("[user.name] unsecures the [src.name] from the floor.", \
									"<span class='notice'>You unsecure the [src.name] from the floor.</span>", \
									"<span class='italics'>You hear a ratchet.</span>")
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				anchored = 0
		return
	return ..()