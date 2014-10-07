
/client/verb/admin_ticket(ntitle as text)
	set name = "Adminticket"
	set category = "Admin"

	// 1 minute cool-down for ticket creation
	src.verbs -= /client/verb/admin_ticket
	spawn(600)
		src.verbs += /client/verb/admin_ticket

	var/datum/admin_ticket/T = new /datum/admin_ticket(src, mob, ntitle)

	tickets_list.Add(T)

/client/verb/view_tickets()
	set name = "Adminlisttickets"
	set category = "Admin"

	var/content = ""

	if(holder)
		var/list/resolved = new /list()
		var/list/unresolved = new /list()

		for(var/datum/admin_ticket/T in tickets_list)
			if(T.resolved)
				resolved.Add(T)
			else
				unresolved.Add(T)

		if(unresolved.len == 0 && resolved.len == 0)
			src << "<p>There are no tickets in the system</p>"
			return

		if(unresolved.len > 0)
			content += "<p class='info-bar unresolved emboldened'>Unresolved Tickets ([unresolved.len]/[tickets_list.len]):</p>"
			for(var/datum/admin_ticket/T in unresolved)
				var/ai_found = isAI(T.user.ckey)
				content += "<p class='ticket-bar'>Ticket: <b>[key_name(T.user, 1)]</b> \"[T.title]\" <a href='?_src_=holder;adminmoreinfo=[T.ref_mob]'>?</a> <a href='?_src_=holder;adminplayeropts=[T.ref_mob]'>PP</a> <a href='?_src_=vars;Vars=[T.ref_mob]'>VV</a> <a href='?_src_=holder;subtlemessage=[T.ref_mob]'>SM</a> <a href='?_src_=holder;adminplayerobservejump=[T.ref_mob]'>JMP</a> <a href='?_src_=holder;secretsadmin=check_antagonist'>CA</a> [ai_found ? " <a href='?_src_=holder;adminchecklaws=[T.ref_mob]'>CL</a>" : ""] <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a> <a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T]'>(Un)Monitor</a> <a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T]'>(Un)Resolve</a></p>"

		if(resolved.len > 0)
			content += "<p class='info-bar resolved emboldened'>Resolved Tickets ([resolved.len]/[tickets_list.len]):</p>"
			for(var/datum/admin_ticket/T in resolved)
				var/ai_found = isAI(T.user.ckey)
				content += "<p class='ticket-bar'>Ticket: <b>[key_name(T.user, 1)]</b> \"[T.title]\" <a href='?_src_=holder;adminmoreinfo=[T.ref_mob]'>?</a> <a href='?_src_=holder;adminplayeropts=[T.ref_mob]'>PP</a> <a href='?_src_=vars;Vars=[T.ref_mob]'>VV</a> <a href='?_src_=holder;subtlemessage=[T.ref_mob]'>SM</a> <a href='?_src_=holder;adminplayerobservejump=[T.ref_mob]'>JMP</a> <a href='?_src_=holder;secretsadmin=check_antagonist'>CA</a> [ai_found ? " <a href='?_src_=holder;adminchecklaws=[T.ref_mob]'>CL</a>" : ""] <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a> <a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T]'>(Un)Monitor</a> <a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T]'>(Un)Resolve</a></p>"
	else
		if(tickets_list.len == 0)
			src << "<p>There are no tickets in the system</p>"
			return
		else
			content += "<p class='info-bar emboldened'>Your tickets:</p>"
			for(var/datum/admin_ticket/T in tickets_list)
				if(T.user == src)
					content += "<p class='ticket-bar [T.resolved ? "resolved" : "unresolved"]'>Ticket: \"[T.title]\" <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a></p>"

	var/html = get_html("Admin Tickets", "", "", content)

	src << browse(null, "window=ViewTickets")
	src << browse(html, "window=ViewTickets")

/*
/client/verb/admin_list_tickets()
	set name = "Adminlisttickets"
	set category = "Admin"

	if(holder)
		var/list/resolved = new /list()
		var/list/unresolved = new /list()

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
*/