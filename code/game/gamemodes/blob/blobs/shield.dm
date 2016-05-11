/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "A huge wall of writhing tendrils. It looks like it could take a lot of hits."
	health = 150
	maxhealth = 150
	health_regen = 2
	fire_resist = 0.5
	atmos_block = 1
	explosion_block = 3


/obj/effect/blob/shield/update_icon()
	if(health <= 0)
		qdel(src)
		return
	return


/obj/effect/blob/shield/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return


/obj/effect/blob/shield/CanPass(atom/movable/mover, turf/target, height=0)
	if(istype(mover) && mover.checkpass(PASSBLOB))	return 1
	return 0
