/client/proc/check_for_bombs()
	set name = "Check existence of bombs"
	set desc = "SDQL2 queries for bawmbs."
	set category = "Debug"

	if(!holder) //juuuuuuuust in case.
		src << "Only administrators may use this command."
		return

	src.SDQL2_query("SELECT /obj/item/device/transfer_valve",1) //checking for permissions is done in the SDQL_Query proc so no worry about that.
	return

/client/proc/delall_bombs()
	set name = "Delete ALL bombs."
	set desc = "For emergency use."
	set category = "Debug"

	if(!holder)
		src << "Only administrators may use this command."
		return

	var/del_count = 0

	for(var/obj/item/device/transfer_valve/T in world)
		del_count++
		qdel(T)
	src << "Deleted [del_count] bombs."
	return