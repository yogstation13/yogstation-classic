/datum/round_event_control/mass_hallucination
	name = "Mass Hallucination"
	typepath = /datum/round_event/mass_hallucination
	weight = 7
	max_occurrences = 2

/datum/round_event/mass_hallucination/start()
	message_admins("Random Event: Mass Hallucination")
	for(var/mob/living/carbon/C in living_mob_list)
		C.hallucination += rand(20, 50)