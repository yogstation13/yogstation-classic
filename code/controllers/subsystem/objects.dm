var/datum/subsystem/objects/SSobj

/datum/proc/process()
	SSobj.processing.Remove(src)
	return 0

/datum/subsystem/objects
	name = "Objects"
	priority = 12

	var/list/processing = list()
	var/list/currentrun = list()
	var/list/burning = list()

/datum/subsystem/objects/New()
	NEW_SS_GLOBAL(SSobj)

/datum/subsystem/objects/Initialize(timeofday, zlevel)
	for(var/atom/movable/AM in world)
		if (zlevel && AM.z != zlevel)
			continue
		AM.initialize()
		CHECK_TICK
	if (zlevel)
		return ..()
	for(var/turf/simulated/floor/F in world)
		F.MakeDirty()
	..()


/datum/subsystem/objects/stat_entry()
	..("P:[processing.len]")


/datum/subsystem/objects/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	while(currentrun.len)
		var/datum/thing = currentrun[1]
		currentrun.Cut(1, 2)
		if(thing)
			thing.process(wait)
		else
			SSobj.processing.Remove(thing)
		if (MC_TICK_CHECK)
			return

	for(var/obj/burningobj in SSobj.burning)
		if(burningobj && (burningobj.burn_state == 1))
			if(burningobj.burn_world_time < world.time)
				burningobj.burn()
		else
			SSobj.burning.Remove(burningobj)