/datum/round_event_control/disease_outbreak
	name = "Disease Outbreak"
	typepath = /datum/round_event/disease_outbreak
	max_occurrences = 1
	weight = 5

/datum/round_event/disease_outbreak
	announceWhen	= 15

	var/virus_type


/datum/round_event/disease_outbreak/announce()
	priority_announce("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak7.ogg')

/datum/round_event/disease_outbreak/setup()
	announceWhen = rand(15, 30)

/datum/round_event/disease_outbreak/start()
	message_admins("Random Event: Disease Outbreak")
	if(!virus_type)
		virus_type = pick(/datum/disease/dnaspread, /datum/disease/advance/flu, /datum/disease/advance/cold, /datum/disease/brainrot, /datum/disease/magnitis)

	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		var/turf/T = get_turf(H)
		if(!T)
			continue
		if(T.z != 1)
			continue
		var/foundAlready = 0	// don't infect someone that already has the virus
		for(var/datum/disease/D in H.viruses)
			foundAlready = 1
			break
		if(H.stat == DEAD || foundAlready)
			continue

		var/datum/disease/D
		if(virus_type == /datum/disease/dnaspread)		//Dnaspread needs strain_data set to work.
			if(!H.dna || (H.sdisabilities & BLIND))	//A blindness disease would be the worst.
				continue
			D = new virus_type()
			var/datum/disease/dnaspread/DS = D
			DS.strain_data["name"] = H.real_name
			DS.strain_data["UI"] = H.dna.uni_identity
			DS.strain_data["SE"] = H.dna.struc_enzymes
		else
			D = new virus_type()
		D.carrier = 1
		D.holder = H
		D.affected_mob = H
		H.viruses += D
		var/log = "has contracted [D.name]"
		if(istype(D, /datum/disease/advance))
			var/datum/disease/advance/DD = D
			log += " \[ symptoms: "
			for(var/datum/symptom/S in DD.symptoms)
				log += "[S.name] "
			log += "\]"
		log += " as a carrier from a Disease Outbreak random event."
		H.investigate_log(log, "viro")
		break