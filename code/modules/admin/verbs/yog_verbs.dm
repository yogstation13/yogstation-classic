/client/proc/fix_air(var/turf/simulated/T in world)
	set name = "Fix Air"
	set category = "Server"
	
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(check_rights(R_SERVER,1))
		var/range=input("Enter range:","Num",2) as num
		message_admins("[key_name_admin(usr)] fixed air with range [range] in area [T.loc.name]")
		log_game("[key_name_admin(usr)] fixed air with range [range] in area [T.loc.name]")
		var/datum/gas_mixture/GM = new
		GM.oxygen=22
		GM.nitrogen=82
		GM.temperature=293
		GM.volume=2500
		for(var/turf/simulated/floor/F in range(range,T))
			F.copy_air(GM)

