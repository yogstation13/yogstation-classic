/mob/dead/observer/Topic(href, href_list, hsrc)
	if("search_mob" in href_list)
		var/name = href_list["target_name"]
		var/mob/ref = locate(href_list["target_ref"])
		var/param = href_list["param"]

		if(!name || !ref)
			return

		if(param == "FLW")
			ManualFollow(ref)
		else if(param == "JMP")
			var/mob/A = src			 //Source mob
			var/turf/T = get_turf(ref) //Turf of the destination mob

			if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
				A.loc = T
			else
				A << "This mob is not located in the game world."

	..()