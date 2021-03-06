/obj/effect/blob/resource
	name = "resource blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_resource"
	health = 70
	maxhealth = 70
	fire_resist = 0.75
	var/resource_delay = 0

/obj/effect/blob/resource/update_icon()
	if(health <= 0)
		qdel(src)

/obj/effect/blob/resource/PulseAnimation(activate = 0)
	if(activate)
		..()
	return

/obj/effect/blob/resource/run_action()

	if(resource_delay > world.time)
		return 0

	PulseAnimation(1)

	resource_delay = world.time + 40 // 4 seconds

	if(overmind)
		overmind.add_points(1)
	return 0

