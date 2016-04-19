/datum/round_event_control/apc_fry
	name = "Fried APCs"
	typepath = /datum/round_event/apc_fry
	weight = 45
	earliest_start = 1000

/datum/round_event/apc_fry
	announceWhen = 15
	var/fry_chance = 3

/datum/round_event/apc_fry/setup()
	startWhen = rand(15, 25)
	fry_chance = rand(2,5) //2 to 5 percent of station APCs get fuck'd.
	announceWhen = startWhen + 5

/datum/round_event/apc_fry/announce()
	if(prob(30))
		priority_announce("Error detected in the station electrical grid. Malfunctioning area power controllers may follow.", "Power Grid")
	else
		message_admins("The 'Fried APC' event has fired, but the crew has not been alerted. If you are confused, this is why.")

/datum/round_event/apc_fry/start()
	for(var/obj/machinery/power/apc/A in world)
		if(prob(fry_chance))
			A.break_apc()
