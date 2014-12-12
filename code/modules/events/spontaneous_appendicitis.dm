/datum/round_event_control/spontaneous_appendicitis
	name = "Spontaneous Appendicitis"
	typepath = /datum/round_event/spontaneous_appendicitis
	weight = 20
	max_occurrences = 4
	earliest_start = 6000

/datum/round_event/spontaneous_appendicitis/start()
	message_admins("Random Event: Spontaneous Appendicitis")
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		var/foundAlready = 0	//don't infect someone that already has the virus
		var/has_appendix = 0
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
			break
		for(var/obj/item/organ/appendix/appendix in H.internal_organs)
			has_appendix = 1
			break
		if(H.stat == 2 || foundAlready || has_appendix == 0)
			continue

		var/datum/disease/D = new /datum/disease/appendicitis
		H.AddDisease(D)
		break