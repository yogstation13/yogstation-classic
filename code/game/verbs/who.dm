
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder)
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg

/client/proc/adminwhotoggle()
	set category = "Admin"
	set name = "Admin Who Toggle"

	if(holder)
		if(check_rights(R_ADMIN,0))
			config.admin_who_blocked = !config.admin_who_blocked
			message_admins("Set by [src]: Adminwho is [!config.admin_who_blocked ? "now" : "no longer"] displayed to non-admins.")

			for(var/client/C in clients)
				if(!C.holder)
					if(!config.admin_who_blocked)
						C.verbs += /client/proc/adminwho
					else
						C.verbs -= /client/proc/adminwho

/client/proc/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	var/msg = "<b>Current Admins:</b>\n"
	if(holder)
		for(var/client/C in admins)
			msg += "\t[C] is a [C.holder.rank]"

			if(C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				msg += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				msg += " - Lobby"
			else
				msg += " - Playing"

			if(C.is_afk())
				msg += " (AFK)"
			msg += "\n"
	else
		if(config.admin_who_blocked)
			src << "<b>Adminwho is currently disabled</b>"
			verbs -= /client/proc/adminwho
			return

		for(var/client/C in admins)
			if(!C.holder.fakekey && !C.is_afk())
				msg += "\t[C] is a [C.holder.rank]\n"

	src << msg
