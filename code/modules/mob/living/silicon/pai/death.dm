/mob/living/silicon/pai/death(gibbed)
	if(stat == DEAD)	return
	unpair(1)

	if(canmove || resting)
		var/turf/T = get_turf(loc)
		for (var/mob/M in viewers(T))
			M.show_message("\red [src]'s holographic emitters lose power and coherence immediately, collapsing into the charred remains of what was once a personal AI.", 3, "\red A loud beeping followed by the tinkling clatter of glass and metal suddenly fills the air.", 2)
		name = "pAI debris"
		desc = "The unfortunate remains of some poor personal AI device."
		icon_state = "[chassis]_dead"
	else
		card.overlays.Cut()
		card.overlays += "pai-off"

	stat = DEAD
	close_up()
	canmove = 0
	if(blind)	blind.layer = 0
	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	//var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	//mind.store_memory("Time of death: [tod]", 0)

	//New pAI's get a brand new mind to prevent meta stuff from their previous life. This new mind causes problems down the line if it's not deleted here.
	//Read as: I have no idea what I'm doing but asking for help got me nowhere so this is what you get. - Nodrak
	if(mind)	del(mind)
	living_mob_list -= src
	ghostize()
	qdel(src)