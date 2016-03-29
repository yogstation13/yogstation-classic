/client/proc/grief_fix(var/something in list("Check for bombs","Delete ALL bombs", "Stop protected pumps","Stop ALL pumps","Cancel"))//cancel should be at the end
	set name = "Grief fix"
	set desc = "Used for fixing and preventing grief."
	set category = "Special Verbs"

	var/yes = null

	if(!holder) //juuuuuuuust in case.
		src << "Only administrators may use this command."
		return

	switch(something)
		if("Check for bombs")
			src.SDQL2_query("SELECT /obj/item/device/transfer_valve",1) //checking for permissions is done in the SDQL_Query proc so no worry about that.
			return
		if("Delete ALL bombs")
			var/del_count = 0

			yes = input("Are you sure?", "Verify") in list("Yes","No")
			if(yes == "No")
				return

			for(var/obj/item/device/transfer_valve/T in world)
				del_count++
				qdel(T)
			src << "Deleted [del_count] bombs."
			message_admins("[key_name_admin(src)] deleted all ([del_count]) bombs.")
			return
		if("Stop protected pumps")

			yes = input("Are you sure?", "Verify") in list("Yes","No")
			if(yes == "No")
				return

			for(var/obj/machinery/atmospherics/components/binary/pump/P in world)
				if(P.adminlog == 1)
					P.on = 0
					P.update_icon()
			message_admins("[key_name_admin(src)] stopped all protected pumps.")
			return
		if("Stop ALL pumps")
			yes = input("Are you sure?", "Verify") in list("Yes","No")
			if(yes == "No")
				return
			for(var/obj/machinery/atmospherics/components/binary/pump/P in world)
				P.on = 0
				P.update_icon()
			message_admins("[key_name_admin(src)] stopped all pumps.")
		if("Cancel")
			src  << "Aborting."