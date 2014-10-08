
/client/verb/admin_ticket(ticket_title as text)
	set name = "Adminticket"
	set category = "Admin"

	// 1 minute cool-down for ticket creation
	src.verbs -= /client/verb/admin_ticket
	spawn(600)
		src.verbs += /client/verb/admin_ticket

	var/datum/admin_ticket/T = new /datum/admin_ticket(src, mob, ticket_title)

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
				var/ai_found = isAI(T.owner.ckey)
				content += "<p class='ticket-bar'>Ticket: <b>[key_name(T.owner, 1)]</b>[T.handling_admin ? " (Admin: [T.handling_admin])" : ""] \"[T.title]\" <a href='?_src_=holder;adminmoreinfo=[T.ref_mob]'>?</a> <a href='?_src_=holder;adminplayeropts=[T.ref_mob]'>PP</a> <a href='?_src_=vars;Vars=[T.ref_mob]'>VV</a> <a href='?_src_=holder;subtlemessage=[T.ref_mob]'>SM</a> <a href='?_src_=holder;adminplayerobservejump=[T.ref_mob]'>JMP</a> <a href='?_src_=holder;secretsadmin=check_antagonist'>CA</a> [ai_found ? " <a href='?_src_=holder;adminchecklaws=[T.ref_mob]'>CL</a>" : ""] <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a> <a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T]'>(Un)Monitor</a> <a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T]'>(Un)Resolve</a></p>"

		if(resolved.len > 0)
			content += "<p class='info-bar resolved emboldened'>Resolved Tickets ([resolved.len]/[tickets_list.len]):</p>"
			for(var/datum/admin_ticket/T in resolved)
				var/ai_found = isAI(T.owner.ckey)
				content += "<p class='ticket-bar'>Ticket: <b>[key_name(T.owner, 1)]</b> \"[T.title]\" <a href='?_src_=holder;adminmoreinfo=[T.ref_mob]'>?</a> <a href='?_src_=holder;adminplayeropts=[T.ref_mob]'>PP</a> <a href='?_src_=vars;Vars=[T.ref_mob]'>VV</a> <a href='?_src_=holder;subtlemessage=[T.ref_mob]'>SM</a> <a href='?_src_=holder;adminplayerobservejump=[T.ref_mob]'>JMP</a> <a href='?_src_=holder;secretsadmin=check_antagonist'>CA</a> [ai_found ? " <a href='?_src_=holder;adminchecklaws=[T.ref_mob]'>CL</a>" : ""] <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a> <a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T]'>(Un)Monitor</a> <a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T]'>(Un)Resolve</a></p>"
	else
		if(tickets_list.len == 0)
			src << "<p>There are no tickets in the system</p>"
			return
		else
			content += "<p class='info-bar emboldened'>Your tickets:</p>"
			for(var/datum/admin_ticket/T in tickets_list)
				if(T.owner == src)
					content += "<p class='ticket-bar [T.resolved ? "resolved" : "unresolved"]'>Ticket: \"[T.title]\" <a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'>View</a></p>"

	var/html = get_html("Admin Tickets", "", "", content)

	src << browse(null, "window=ViewTickets;size=700x500")
	src << browse(html, "window=ViewTickets;size=700x500")

