
/client/verb/admin_ticket(ntitle as text)
	set name = "Adminticket"
	set category = "Admin"

	// 2 minute cool-down for ticket creation
	src.verbs -= /client/verb/admin_ticket
	spawn(1200)
		src.verbs += /client/verb/admin_ticket

	var/datum/admin_ticket/T = new /datum/admin_ticket(src, mob, ntitle)

	tickets_list.Add(T)

/client/verb/admin_list_tickets()
	set name = "Adminlisttickets"
	set category = "Admin"

	if(holder)
		/var/list/resolved = new /list()
		/var/list/unresolved = new /list()

		for(var/datum/admin_ticket/T in unresolved)
			unresolved.Remove(T)

		for(var/datum/admin_ticket/T in resolved)
			resolved.Remove(T)

		for(var/datum/admin_ticket/T in tickets_list)
			if(T.resolved)
				resolved.Add(T)
			else
				unresolved.Add(T)

		if(unresolved.len == 0 && resolved.len == 0)
			src << "There are no tickets in the system"

		if(unresolved.len > 0)
			src << "<span class='boldnotice'>Unresolved Tickets ([unresolved.len]/[tickets_list.len])</span>:"
			for(var/datum/admin_ticket/T in unresolved)
				src << "<font color='red'>Ticket: <b>[key_name(T.user, 1)]</b> \"[T.title]\" <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a> [holder ? "<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T]'>(Un)Monitor</a> <a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T]'>(Un)Resolve</a>" : ""]</font>"

		if(resolved.len > 0)
			src << "<span class='boldnotice'>Resolved Tickets ([resolved.len]/[tickets_list.len])</span>:"
			for(var/datum/admin_ticket/T in resolved)
				src << "<font color='green'>Ticket: <b>[key_name(T.user, 1)]</b> \"[T.title]\" <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a> [holder ? "<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T]'>(Un)Monitor</a> <a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T]'>(Un)Resolve</a>" : ""]</font>"
	else
		if(tickets_list.len == 0)
			src << "There are no tickets in the system"
		else
			src << "Your tickets:"
			for(var/datum/admin_ticket/T in tickets_list)
				if(T.user == src)
					src << "<font color='blue'>Ticket: \"[T.title]\" <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a></font>"
