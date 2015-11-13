/datum/round_event_control/plasma_fire
	name = "Plasma Fire"
	typepath = /datum/round_event/plasma_fire
	earliest_start = 6000
	weight = 10
	alertadmins = 1

//this is an extremely lazy copy of electrical storm as a proof of concept more than anything else

/datum/round_event/plasma_fire
	announceWhen	= 1

	var/totalToxinsMoles
	var/list/ventList = list()
	var/affectedArea
	var/epiRange = 30
	var/molesToAdd
	var/maxVents = 3

/datum/round_event/plasma_fire/announce()
	priority_announce("WARNING: Fulminant atmospherics error detected. Plasma routing temporarily diverted to distribution loop. Fires may occur. Internals are advised.", "Station Atmospherics Monitoring")


/datum/round_event/plasma_fire/setup()
	startWhen = 10
	endWhen = rand(startWhen+25, 55)

	totalToxinsMoles = rand(50, 150)

	//choose an area and populate our affected vents with it
	var/list/epicentreList = list()
	var/list/possibleVents = list()

	for(var/i=1, i <= maxVents, i++)
		var/list/possibleEpicentres = list()
		for(var/obj/effect/landmark/newEpicentre in landmarks_list)
			if(newEpicentre.name == "lightsout" && !(newEpicentre in epicentreList))
				possibleEpicentres += newEpicentre
		if(possibleEpicentres.len)
			epicentreList += pick(possibleEpicentres)
		else
			break

	if(!epicentreList.len)
		return

	message_admins("Plasma leak event is spawning [totalToxinsMoles]mol plasma across [maxVents] vents over [endWhen] seconds.")

	for(var/obj/effect/landmark/epicentre in epicentreList)
		for(var/obj/machinery/atmospherics/components/unary/vent_pump/pump in range(epicentre,epiRange))
			if (!pump.welded)
				possibleVents += pump

	if (possibleVents.len && possibleVents.len >= maxVents)
		while (ventList.len < maxVents)
			var/obj/machinery/atmospherics/components/unary/vent_pump/pump = pick(possibleVents)
			ventList += pump
			affectedArea = pump.loc.loc.name
			message_admins("Plasma leak from event at [affectedArea] ([pump.loc.x],[pump.loc.y],[pump.loc.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[pump.loc.x];Y=[pump.loc.y];Z=[pump.loc.z]'>JMP</a>)")
	else
		message_admins("Attempted to start plasma leak event, but couldn't find enough viable vents.")
		return kill()

	molesToAdd = (totalToxinsMoles/endWhen) / ventList.len


/datum/round_event/plasma_fire/tick()
	//cycle through vents and put plasma on their loc at a random chance
	if (!ventList.len) //sadness
		return

	for(var/obj/machinery/atmospherics/components/unary/vent_pump/pump in ventList)
		var/datum/gas_mixture/air_contents = pump.loc.return_air()
		//take loc's source tile, add toxins moles to the loc proportionally over the duration of the leak
		air_contents.toxins += molesToAdd

		pump.loc.assume_air(air_contents)
		pump.air_update_turf()

		if (prob(3)) //may the honkmother have mercy on your soul (this ignites the vent tile presumably causing hellfire and suffering)
			var/turf/location = pump.loc
			if (isturf(location))
				location.hotspot_expose(1000,500,1)

/datum/round_event/plasma_fire/end()
	priority_announce("Subsystem error rectified. Distribution loop returning to normal. Atmospherics response advised for affected general area: [affectedArea].", "Station Atmospherics Monitoring")