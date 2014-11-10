
/client/verb/admin_ticket(ticket_title as text)
	// Original command name is being replaced with Adminhelp for easy user transitioning
	//set name = "Adminticket"
	set category = "Admin"
	set name = "Adminhelp"

	// 1 minute cool-down for ticket creation? Timeout removed for this system.
	//src.verbs -= /client/verb/admin_ticket
	//spawn(600)
	//	src.verbs += /client/verb/admin_ticket

	var/datum/admin_ticket/found_ticket = null
	for(var/datum/admin_ticket/T in tickets_list)
		if(compare_ckey(T.owner_ckey, usr) && !T.resolved)
			found_ticket = T

	if(!found_ticket)
		var/datum/admin_ticket/T = new /datum/admin_ticket(usr, ticket_title)

		if(!T.error)
			tickets_list.Add(T)
		else
			T = null
	else
		//var/time = time2text(world.timeofday, "hh:mm")
		//usr << output("[time] - <b>[found_ticket.owner]</b> - [ticket_title]", "ViewTicketLog[found_ticket.ticket_id].browser:add_message")
		found_ticket.owner = usr
		if(!compare_ckey(usr, found_ticket.owner))
			found_ticket.owner << output("[gameTimestamp()] - <b>[key_name(found_ticket.owner, 1)]</b> - [ticket_title]", "ViewTicketLog[found_ticket.ticket_id].browser:add_message")
		found_ticket.add_log(ticket_title)

/client/verb/view_my_ticket()
	set category = "Admin"
	set name = "View My Ticket"
	for(var/datum/admin_ticket/T in tickets_list)
		if((compare_ckey(T.owner_ckey, usr) || compare_ckey(T.handling_admin, usr)) && !T.resolved)
			T.view_log()
			return

	usr << "<span class='ticket-status'>Oops! You do not appear to have a ticket!</span>"

// Admin proc-verb @see admin_verbs.dm
/client/proc/view_tickets()
	set name = "Adminlisttickets"
	set category = "Admin"

	var/content = ""

	if(holder)
		var/list/resolved = new /list()
		var/list/unresolved = new /list()
		var/list/admin2admin = new /list()

		for(var/datum/admin_ticket/T in tickets_list)
			/*if(!T.owner)
				continue*/

			// Admin 2 Admin category only confuses things
			/*if(is_admin(T.owner) && is_admin(T.handling_admin))
				admin2admin.Add(T)
				continue*/

			if(T.resolved)
				resolved.Add(T)
			else
				unresolved.Add(T)

		if(unresolved.len == 0 && resolved.len == 0)
			usr << "<span class='ticket-status'>There are no tickets in the system</span>"
			return

		if(unresolved.len > 0)
			content += "<p class='info-bar unresolved emboldened large-font'>Unresolved Tickets ([unresolved.len]/[tickets_list.len]):</p>"
			for(var/datum/admin_ticket/T in unresolved)
				/*if(!T.owner)
					continue*/

				if(!T.owner)
					content += {"<p class='ticket-bar'>
						<b>[T.title]</b><br />
						<b>Owner:</b> <b>[T.owner_ckey] (DC)</b>
						<a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
						<a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
						</p>"}
				else
					var/ai_found = (T.owner && isAI(get_ckey(T.owner)))
					content += {"<p class='ticket-bar'>
						<b>[T.title]</b><br />
						<b>Owner:</b> <b>[key_name(T.owner, 1)]</b><br />
						[T.handling_admin ? " <b>Admin:</b> [T.handling_admin]<br />" : ""]
						<a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						"}
					if(T.owner.mob)
						content += {"
							<a href='?_src_=holder;adminmoreinfo=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
							<a href='?_src_=holder;adminplayeropts=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
							<a href='?_src_=vars;Vars=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
							<a href='?_src_=holder;subtlemessage=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
							<a href='?_src_=holder;adminplayerobservejump=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
							<a href='?_src_=holder;secretsadmin=check_antagonist'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> CA</a>
							[ai_found ? " <a href='?_src_=holder;adminchecklaws=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> CL</a>" : ""]
							"}
					content += {"
						<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
						<a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
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
						<a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
						<a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
						</p>"}
				else
					var/ai_found = (T.owner && isAI(get_ckey(T.owner)))
					content += {"<p class='ticket-bar'>
						<b>[T.title]</b><br />
						<b>Owner:</b> <b>[key_name(T.owner, 1)]</b><br />
						[T.handling_admin ? " <b>Admin:</b> [T.handling_admin]<br />" : ""]
						<a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						"}
					if(T.owner.mob)
						content += {"
							<a href='?_src_=holder;adminmoreinfo=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
							<a href='?_src_=holder;adminplayeropts=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
							<a href='?_src_=vars;Vars=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
							<a href='?_src_=holder;subtlemessage=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
							<a href='?_src_=holder;adminplayerobservejump=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
							<a href='?_src_=holder;secretsadmin=check_antagonist'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> CA</a>
							[ai_found ? " <a href='?_src_=holder;adminchecklaws=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> CL</a>" : ""]
								"}
					content += {"
						<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
						<a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
						</p>"}

		if(admin2admin.len > 0)
			content += "<p class='info-bar admin emboldened large-font'>Admin to Admin Tickets ([admin2admin.len]/[tickets_list.len]):</p>"
			for(var/datum/admin_ticket/T in admin2admin)
				if(!T.owner)
					continue

				if(!T.owner)
					content += {"<p class='ticket-bar'>
						<b>[T.title]</b><br />
						<b>Owner:</b> <b>[T.owner_ckey] (DC)</b>
						<a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
						<a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
						</p>"}
				else
					var/ai_found = (T.owner && isAI(get_ckey(T.owner)))
					content += {"<p class='ticket-bar'>
						<b>[T.title]</b><br />
						<b>Owner:</b> <b>[key_name(T.owner, 1)]</b><br />
						[T.handling_admin ? " <b>Admin:</b> [T.handling_admin]<br />" : ""]
						<a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						"}
					if(T.owner.mob)
						content += {"
							<a href='?_src_=holder;adminmoreinfo=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
							<a href='?_src_=holder;adminplayeropts=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
							<a href='?_src_=vars;Vars=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
							<a href='?_src_=holder;subtlemessage=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
							<a href='?_src_=holder;adminplayerobservejump=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
							<a href='?_src_=holder;secretsadmin=check_antagonist'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> CA</a>
							[ai_found ? " <a href='?_src_=holder;adminchecklaws=\ref[T.owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> CL</a>" : ""]
								"}
					content += {"
						<a href='?src=\ref[src];action=monitor_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
						<a href='?src=\ref[src];action=resolve_admin_ticket;ticket=\ref[T];reloadlist=1'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
						</p>"}
	else
		if(tickets_list.len == 0)
			usr << "<span class='ticket-status'>There are no tickets in the system</span>"
			return
		else
			content += "<p class='info-bar emboldened'>Your tickets:</p>"
			for(var/datum/admin_ticket/T in tickets_list)
				if(compare_ckey(T.owner, usr))
					content += {"<p class='ticket-bar [T.resolved ? "resolved" : "unresolved"]'>
						<b>[T.title]</b>
						<a href='?src=\ref[src];action=view_admin_ticket;ticket=\ref[T]'><img width='16' height='16' class='uiIcon16 icon-search' /> View</a>
						</p>"}

	var/html = get_html("Admin Tickets", "", "", content)

	usr << browse(null, "window=ViewTickets;size=700x500")
	usr << browse(html, "window=ViewTickets;size=700x500")

