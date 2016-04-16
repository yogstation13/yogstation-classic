/mob/living/silicon/ai/death(gibbed)
	if(stat == DEAD)	return
	stat = DEAD


	if("[icon_state]_dead" in icon_states(src.icon,1))
		icon_state = "[icon_state]_dead"
	else
		icon_state = "ai_dead"

	update_canmove()
	if(eyeobj)
		eyeobj.setLoc(get_turf(src))
	src.sight |= SEE_TURFS
	src.sight |= SEE_MOBS
	src.sight |= SEE_OBJS
	src.see_in_dark = 8
	src.see_invisible = SEE_INVISIBLE_LEVEL_TWO
	if(see_override)
		see_invisible = see_override

	shuttle_caller_list -= src
	SSshuttle.autoEvac()

	if(nuking)
		set_security_level("red")
		nuking = 0
		SSshuttle.emergencyNoEscape = 0
		if(SSshuttle.emergency.mode == SHUTTLE_STRANDED)
			SSshuttle.emergency.mode = SHUTTLE_DOCKED
			SSshuttle.emergency.timer = world.time
			priority_announce("Hostile enviroment resolved. You have 3 minutes to board the Emergency Shuttle.", null, 'sound/AI/shuttledock.ogg', "Priority")

	if(doomsday_device)
		doomsday_device.timing = 0
		qdel(doomsday_device)

	if(explosive)
		spawn(10)
			explosion(src.loc, 3, 6, 12, 15)

	for(var/obj/machinery/ai_status_display/O in world) //change status
		if(src.key)
			spawn( 0 )
			O.mode = 2
			if (istype(loc, /obj/item/device/aicard))
				loc.icon_state = "aicard-404"

	tod = worldtime2text() //weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)

	return ..(gibbed)
