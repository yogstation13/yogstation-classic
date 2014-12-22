
/client/verb/admin_ticket(ticket_title as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(!ticket_title)
		usr << "<span class='ticket-status'>You did not supply a message for your ticket. Ignoring your request.</span>"
		return

	var/datum/admin_ticket/found_ticket = null
	for(var/datum/admin_ticket/T in tickets_list)
		if(compare_ckey(T.owner_ckey, src) && !T.resolved)
			found_ticket = T

	if(!found_ticket)
		var/datum/admin_ticket/T = new /datum/admin_ticket(src, ticket_title)

		if(!T.error)
			tickets_list.Add(T)
		else
			T = null
	else
		found_ticket.owner = src
		if(!compare_ckey(src, found_ticket.owner))
			found_ticket.owner << output("[gameTimestamp()] - <b>[key_name(found_ticket.owner, 1)]</b> - [ticket_title]", "ViewTicketLog[found_ticket.ticket_id].browser:add_message")
		found_ticket.add_log(ticket_title)

/client/verb/view_my_ticket()
	set category = "Admin"
	set name = "View My Ticket"
	// Firstly, check if we are the owner of a ticket. This should be our first priority.
	for(var/datum/admin_ticket/T in tickets_list)
		if(compare_ckey(T.owner_ckey, usr) && !T.resolved)
			T.view_log()
			return
	// If we reach here, perhaps we have a ticket to handle. That should be shown.
	for(var/datum/admin_ticket/T in tickets_list)
		if(compare_ckey(T.handling_admin, usr) && !T.resolved)
			T.view_log()
			return

	usr << "<span class='ticket-status'>Oops! You do not appear to have a ticket!</span>"

/client/proc/view_tickets()
	set name = "Adminlisttickets"
	set category = "Admin"

	view_tickets_main(TICKET_FLAG_LIST_ALL)

/client/proc/view_tickets_main(var/flag)
	flag = text2num(flag)
	if(!flag)
		flag = TICKET_FLAG_LIST_ALL

	var/content = ""

	if(holder)
		content += {"<p class='info-bar'>
			<a href='?user=\ref[src];action=refresh_admin_ticket_list;flag=[flag]'>Refresh List</a>
			<a href='?user=\ref[src];action=refresh_admin_ticket_list;flag=[(flag | TICKET_FLAG_LIST_ALL) & ~TICKET_FLAG_LIST_MINE]'>All Tickets</a>
			<a href='?user=\ref[src];action=refresh_admin_ticket_list;flag=[(flag | TICKET_FLAG_LIST_MINE) & ~TICKET_FLAG_LIST_ALL]'>My Tickets</a>
		</p>"}

		content += {"<p class='info-bar'>
			Filtering:<b>
			[(flag & TICKET_FLAG_LIST_ALL) ? " All" : ""]
			[(flag & TICKET_FLAG_LIST_MINE) ? " Mine" : ""]
		</b></p>"}

		var/list/resolved = new /list()
		var/list/unresolved = new /list()

		for(var/i = tickets_list.len, i >= 1, i--)
		//for(var/datum/admin_ticket/T in tickets_list)
			var/datum/admin_ticket/T = tickets_list[i]

			if(flag & TICKET_FLAG_LIST_MINE)
				if(!compare_ckey(src, T.owner_ckey) && !compare_ckey(src, T.handling_admin))
					continue

			if(T.resolved)
				resolved.Add(T)
			else
				unresolved.Add(T)

		if(unresolved.len == 0 && resolved.len == 0)
			content += "<p class='info-bar emboldened'>There are no tickets matching your filter(s)</p>"

		if(unresolved.len > 0)
			content += "<p class='info-bar unresolved emboldened large-font'>Unresolved Tickets ([unresolved.len]/[tickets_list.len]):</p>"
			for(var/datum/admin_ticket/T in unresolved)
				if(!T.owner)
					content += {"<p class='ticket-bar'>
						<b>[T.handling_admin ? "" : "<span class='unclaimed'>Unclaimed</span>!"] [T.title]</b><br />
						<b>Owner:</b> <b>[T.owner_ckey] (DC)</b>
						<a href='?src=\ref[T];user=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						<a href='?src=\ref[T];user=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1' class='monitor-button'><img border='0' width='16' height='16' class='uiIcon16 icon-pin-s' /> <span>[!T.is_monitor(usr.client) ? "Un" : ""]Monitor</span></a>
						<a href='?src=\ref[T];user=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1' class='resolve-button'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> <span>[T.resolved ? "Un" : ""]Resolve</span></a>
						</p>"}
				else
					var/ai_found = (T.owner && isAI(get_ckey(T.owner)))
					content += {"<p class='ticket-bar'>
						<b>[T.handling_admin ? "" : "<span class='unclaimed'>Unclaimed</span>"] [T.title]</b><br />
						<b>Owner:</b> <b>[key_name(T.owner, 1)]</b><br />
						[T.handling_admin ? " <b>Admin:</b> [T.handling_admin]<br />" : ""]
						<a href='?src=\ref[T];user=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						"}
					if(T.owner.mob)
						content += {"
							<a href='?_src_=holder;adminmoreinfo=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
							<a href='?_src_=holder;adminplayeropts=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
							<a href='?_src_=vars;Vars=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
							<a href='?_src_=holder;subtlemessage=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
							<a href='?_src_=holder;adminplayerobservejump=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
							<a href='?_src_=holder;secretsadmin=check_antagonist'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> CA</a>
							[ai_found ? " <a href='?_src_=holder;adminchecklaws=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> CL</a>" : ""]
							"}
					content += {"
						<a href='?src=\ref[T];user=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1' class='monitor-button'><img border='0' width='16' height='16' class='uiIcon16 icon-pin-s' /> <span>[!T.is_monitor(usr.client) ? "Un" : ""]Monitor</span></a>
						<a href='?src=\ref[T];user=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1' class='resolve-button'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> <span>[T.resolved ? "Un" : ""]Resolve</span></a>
						</p>"}

		if(resolved.len > 0)
			content += "<p class='info-bar resolved emboldened large-font'>Resolved Tickets ([resolved.len]/[tickets_list.len]):</p>"
			for(var/datum/admin_ticket/T in resolved)
				/*if(!T.owner)
					continue*/

				if(!T.owner)
					content += {"<p class='ticket-bar'>
						<b>[T.title]</b><br />
						<b>Owner:</b> <b>[T.owner_ckey] (DC)</b>
						<a href='?src=\ref[T];user=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						<a href='?src=\ref[T];user=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1' class='monitor-button'><img border='0' width='16' height='16' class='uiIcon16 icon-pin-s' /> <span>[!T.is_monitor(usr.client) ? "Un" : ""]Monitor</span></a>
						<a href='?src=\ref[T];user=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1' class='resolve-button'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> <span>[T.resolved ? "Un" : ""]Resolve</span></a>
						</p>"}
				else
					var/ai_found = (T.owner && isAI(get_ckey(T.owner)))
					content += {"<p class='ticket-bar'>
						<b>[T.title]</b><br />
						<b>Owner:</b> <b>[key_name(T.owner, 1)]</b><br />
						[T.handling_admin ? " <b>Admin:</b> [T.handling_admin]<br />" : ""]
						<a href='?src=\ref[T];user=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						"}
					if(T.owner.mob)
						content += {"
							<a href='?_src_=holder;adminmoreinfo=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
							<a href='?_src_=holder;adminplayeropts=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
							<a href='?_src_=vars;Vars=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
							<a href='?_src_=holder;subtlemessage=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
							<a href='?_src_=holder;adminplayerobservejump=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
							<a href='?_src_=holder;secretsadmin=check_antagonist'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> CA</a>
							[ai_found ? " <a href='?_src_=holder;adminchecklaws=\ref[T.owner.mob]'><img border='0' width='16' height='16' class='uiIcon16 icon-clipboard' /> CL</a>" : ""]
								"}
					content += {"
						<a href='?src=\ref[T];user=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1' class='monitor-button'><img border='0' width='16' height='16' class='uiIcon16 icon-pin-s' /> <span>[!T.is_monitor(usr.client) ? "Un" : ""]Monitor</span></a>
						<a href='?src=\ref[T];user=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1' class='resolve-button'><img border='0' width='16' height='16' class='uiIcon16 icon-check' /> <span>[T.resolved ? "Un" : ""]Resolve</span></a>
						</p>"}
	else
		content += "<p class='info-bar'><a href='?user=\ref[src];action=refresh_admin_ticket_list;flag=[flag]'>Refresh List</a></p>"

		if(tickets_list.len == 0)
			content += "<p class='info-bar emboldened'>There are no tickets in the system</p>"
		else
			content += "<p class='info-bar emboldened'>Your tickets:</p>"
			for(var/datum/admin_ticket/T in tickets_list)
				if(compare_ckey(T.owner, usr))
					content += {"<p class='ticket-bar [T.resolved ? "resolved" : "unresolved"]'>
						<b>[T.title]</b>
						<a href='?src=\ref[T];user=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img border='0' width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						</p>"}

	var/html = get_html("Admin Tickets", "", "", content)

	usr << browse(null, "window=ViewTickets")
	usr << browse(html, "window=ViewTickets")

