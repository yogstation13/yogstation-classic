/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	luminosity = 3
	desc = "Some blob creature thingy made of a wriggling mass of tendrils."
	density = 0
	opacity = 0
	anchored = 1
	explosion_block = 1
	var/health = 30
	var/maxhealth = 30
	var/health_regen = 2
	var/pulse_timestamp = 0
	var/health_timestamp = 0
	var/brute_resist = 0.5
	var/fire_resist = 1.15 // lower fire_resist = less damage
	var/atmos_block = 0
	var/mob/camera/blob/overmind


/obj/effect/blob/New(loc)
	blobs += src
	src.dir = pick(1, 2, 4, 8)
	..(loc)
	ConsumeTile()
	src.update_icon()
	if(atmos_block)
		air_update_turf(1)
	return


/obj/effect/blob/Destroy()
	if(atmos_block)
		atmos_block = 0
		air_update_turf(1)
	blobs -= src
	if(isturf(loc)) //Necessary because Expand() is retarded and spawns a blob and then deletes it
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
	..()


/obj/effect/blob/proc/check_health(cause)
	health = Clamp(health, 0, maxhealth)
	if(health <= 0)
		if(overmind)
			overmind.blob_reagent_datum.death_reaction(src, cause)
		qdel(src) //we dead now
		return 0
	return 1


/obj/effect/blob/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0)	return 1
	if(istype(mover) && mover.checkpass(PASSBLOB))	return 1
	return 0


/obj/effect/blob/CanAtmosPass(turf/T)
	return !atmos_block


/obj/effect/blob/process()
	Life()
	return


/obj/effect/blob/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/damage = Clamp(0.01 * exposed_temperature, 0, 4)
	take_damage(damage, BURN)


/obj/effect/blob/proc/Life()
	return


/obj/effect/blob/proc/PulseAnimation()
	if(!istype(src, /obj/effect/blob/core) || !istype(src, /obj/effect/blob/node))
		flick("[icon_state]_glow", src)
	return


/obj/effect/blob/proc/RegenHealth()
	// All blobs heal over time when pulsed, but it has a cool down
	if(health_timestamp > world.time)
		return 0
	if(health < initial(health))
		health += health_regen
		update_icon()
		health_timestamp = world.time + 10 // 1 seconds

/obj/effect/blob/proc/Pulse_Area(pulsing_overmind = overmind, claim_range = 10, pulse_range = 3, expand_range = 2)
	src.Be_Pulsed()
	if(claim_range)
		for(var/obj/effect/blob/B in urange(claim_range, src, 1))
			if(!B.overmind && !istype(B, /obj/effect/blob/core) && prob(30))
				B.overmind = pulsing_overmind //reclaim unclaimed, non-core blobs.
				B.update_icon()
	if(pulse_range)
		for(var/obj/effect/blob/B in orange(pulse_range, src))
			B.Be_Pulsed()
	if(expand_range)
		if(prob(85))
			src.expand()
		for(var/obj/effect/blob/B in orange(expand_range, src))
			if(prob(max(10 - get_dist(get_turf(src), get_turf(B)) * 4, 1))) //expand falls off with range but is faster near the blob causing the expansion
				B.expand()
	return

/obj/effect/blob/proc/Be_Pulsed()
	if(pulse_timestamp <= world.time)
		ConsumeTile()
		health = min(maxhealth, health+health_regen)
		update_icon()
		pulse_timestamp = world.time + 10
		return 1 //we did it, we were pulsed!
	return 0 //oh no we failed

/*/obj/effect/blob/proc/pulseLoop(num)
	var/a_color
	if(overmind)
		a_color = overmind.blob_reagent_datum.color
	for(var/i = 1; i < 8; i += i)
		Pulse(num, i, a_color)


/obj/effect/blob/proc/Pulse(pulse = 0, origin_dir = 0, a_color)//Todo: Fix spaceblob expand

	set background = BACKGROUND_ENABLED

	PulseAnimation()

	RegenHealth()

	if(run_action())//If we can do something here then we dont need to pulse more
		return

	if(pulse > 30)
		return//Inf loop check

	//Looking for another blob to pulse
	var/list/dirs = list(1,2,4,8)
	dirs.Remove(origin_dir)//Dont pulse the guy who pulsed us
	for(var/i = 1 to 4)
		if(!dirs.len)	break
		var/dirn = pick(dirs)
		dirs.Remove(dirn)
		var/turf/T = get_step(src, dirn)
		var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
		if(!B)
			if(prob(75))
				expand(T, src.overmind)//No blob here so try and expand
				return
		B.adjustcolors(a_color)

		B.Pulse((pulse+1),get_dir(src.loc,T), a_color)
		return
	return
*/

/obj/effect/blob/proc/run_action()
	return 0


//old Yog expand
/*/obj/effect/blob/proc/expand(turf/T = null, prob = 1, a_color)
	if(prob && !prob(health))	return
	if(istype(T, /turf/space) && !(locate(/obj/structure/lattice) in T) && prob(75)) 	return
	if(!T)
		var/list/dirs = list(1,2,4,8)
		for(var/i = 1 to 4)
			var/dirn = pick(dirs)
			dirs.Remove(dirn)
			T = get_step(src, dirn)
			if(!(locate(/obj/effect/blob) in T))	break
			else	T = null

	if(!T)	return 0
	var/obj/effect/blob/normal/B = new /obj/effect/blob/normal(src.loc, min(src.health, 30))
	B.color = a_color
	B.density = 1
	if(T.Enter(B,src))//Attempt to move into the tile
		B.density = initial(B.density)
		B.loc = T

	else
		T.blob_act()//If we cant move in hit the turf
		B.loc = null //So we don't play the splat sound, see Destroy()
		qdel(B)

	for(var/atom/A in T)//Hit everything in the turf
		A.blob_act()
	return 1*/
//new /tg/ expand
/obj/effect/blob/proc/expand(turf/T = null, controller = null, expand_reaction = 1)
	src.update_icon()
	if(!T)
		var/list/dirs = list(1,2,4,8)
		for(var/i = 1 to 4)
			var/dirn = pick(dirs)
			dirs.Remove(dirn)
			T = get_step(src, dirn)
			if(!(locate(/obj/effect/blob) in T))
				break
			else
				T = null
	if(!T)
		return 0
	var/make_blob = TRUE //can we make a blob?

	if(istype(T, /turf/space) && !(locate(/obj/structure/lattice) in T) && prob(80))
		make_blob = FALSE
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1) //Let's give some feedback that we DID try to spawn in space, since players are used to it

	ConsumeTile() //hit the tile we're in, making sure there are no border objects blocking us
	if(!T.CanPass(src, T, 5)) //is the target turf impassable
		make_blob = FALSE
		T.blob_act() //hit the turf if it is
	for(var/atom/A in T)
		if(!A.CanPass(src, T, 5)) //is anything in the turf impassable
			make_blob = FALSE
		A.blob_act() //also hit everything in the turf

	if(make_blob) //well, can we?
		var/obj/effect/blob/B = new /obj/effect/blob/normal(src.loc)
		if(controller)
			B.overmind = controller
		else
			B.overmind = overmind
		B.update_icon()
		B.density = 1
		if(T.Enter(B,src)) //NOW we can attempt to move into the tile
			B.density = initial(B.density)
			B.loc = T
			B.color = src.overmind.blob_reagent_datum.color
			B.update_icon()
			if(B.overmind && expand_reaction)
				B.overmind.blob_reagent_datum.expand_reaction(src, B, T)
			return B
		else
			blob_attack_animation(T, controller)
			T.blob_act() //if we can't move in hit the turf again
			qdel(B) //we should never get to this point, since we checked before moving in. destroy the blob so we don't have two blobs on one tile
			return null
	else
		blob_attack_animation(T, controller) //if we can't, animate that we attacked
	return null


/obj/effect/blob/proc/ConsumeTile()
	for(var/atom/A in loc)
		A.blob_act()
	if(istype(loc, /turf/simulated/wall))
		loc.blob_act() //don't ask how a wall got on top of the core, just eat it



/obj/effect/blob/proc/blob_attack_animation(atom/A = null, controller) //visually attacks an atom
	var/obj/effect/overlay/temp/blob/O = PoolOrNew(/obj/effect/overlay/temp/blob, src.loc)
	if(controller)
		var/mob/camera/blob/BO = controller
		O.color = BO.blob_reagent_datum.color
		O.alpha = 200
	else if(overmind)
		O.color = overmind.blob_reagent_datum.color
	if(A)
		O.do_attack_animation(A) //visually attack the whatever
	return O //just in case you want to do something to the animation.


/obj/effect/blob/ex_act(severity, target)
	..()
	var/damage = 150 - 20 * severity
	take_damage(damage, BRUTE)


/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	..()
	take_damage(Proj.damage, Proj.damage_type)
	return 0


/obj/effect/blob/Crossed(mob/living/L)
	..()
	L.blob_act()


/obj/effect/blob/attackby(obj/item/weapon/W, mob/living/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>[user] has attacked the [src.name] with \the [W]!</span>")
	if(W.damtype == BURN)
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
	take_damage(W.force, W.damtype)


/obj/effect/blob/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>\The [M] has attacked the [src.name]!</span>")
	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
	take_damage(damage, BRUTE)
	return


/obj/effect/blob/attack_alien(mob/living/carbon/alien/humanoid/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>[M] has slashed the [src.name]!</span>")
	var/damage = rand(15, 30)
	take_damage(damage, BRUTE)
	return


/obj/effect/blob/proc/take_damage(damage, damage_type, cause = null, overmind_reagent_trigger = 1)
	switch(damage_type) //blobs only take brute and burn damage
		if(BRUTE)
			damage = max(damage * brute_resist, 0)
		if(BURN)
			damage = max(damage * fire_resist, 0)
		if(CLONE) //this is basically a marker for 'don't modify the damage'

		else
			damage = 0
	if(overmind && overmind_reagent_trigger)
		damage = overmind.blob_reagent_datum.damage_reaction(src, health, damage, damage_type, cause) //pass the blob, its health before damage, the damage being done, the type of damage being done, and the cause.
	health -= damage
	update_icon()
	check_health(cause)

/obj/effect/blob/proc/change_to(type, controller)
	if(!ispath(type))
		throw EXCEPTION("change_to(): invalid type for blob")
		return
	var/obj/effect/blob/B = new type(src.loc)
	if(controller)
		B.overmind = controller
		B.adjustcolors(overmind.blob_reagent_datum.color)
	B.update_icon()
	qdel(src)
	return B
/*	if(!ispath(type))
		throw EXCEPTION("change_to(): invalid type for blob")
		return
	var/obj/effect/blob/B = new type(src.loc)
	if(!istype(type, /obj/effect/blob/core) || !istype(type, /obj/effect/blob/node))
		B.color = color
	else
		B.adjustcolors(color)
	qdel(src)
	return B*/


/obj/effect/blob/proc/adjustcolors(a_color)
	if(a_color)
		color = a_color
	return


/obj/effect/blob/examine(mob/user)
	..()
	user << "It appears to be composed of [get_chem_name()]."
	return


/obj/effect/blob/proc/get_chem_name()
	if(overmind)
		return overmind.blob_reagent_datum.name
	return "an unknown variant"


/obj/effect/blob/normal
	icon_state = "blob"
	desc = "A thick wall of writhing tendrils."
	luminosity = 0
	health = 30
	maxhealth = 30


/obj/effect/blob/normal/update_icon()
	if(check_health())
		if(health <= 10)
			icon_state = "blob_damaged"
			name = "fragile blob"
			desc = "A thin lattice of slightly twitching tendrils."
			brute_resist = 0.5
		else
			icon_state = "blob"
			name = "blob"
			desc = "A thick wall of writhing tendrils."
			brute_resist = 0.25


/obj/effect/blob/tesla_act(power)
	..()
	if(overmind)
		if(overmind.blob_reagent_datum.tesla_reaction(src, power))
			take_damage(power/400, BURN)
	else
		take_damage(power/400, BURN)


/obj/effect/blob/extinguish()
	..()
	if(overmind)
		overmind.blob_reagent_datum.extinguish_reaction(src)


/* // Used to create the glow sprites. Remember to set the animate loop to 1, instead of infinite!

var/datum/blob_colour/B = new()

/datum/blob_colour/New()
	..()
	var/icon/I = 'icons/mob/blob.dmi'
	I += rgb(35, 35, 0)
	if(isfile("icons/mob/blob_result.dmi"))
		fdel("icons/mob/blob_result.dmi")
	fcopy(I, "icons/mob/blob_result.dmi")

*/