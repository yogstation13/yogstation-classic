
/client/Topic(href, href_list[])
	..()
	//var/mob/M = locate(href_list["src"])
	var/client/C = usr.client

	if(href_list["action"] == "view_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		// Close ticket list when opening ticket
		//src << browse(null, "window=ViewTickets;size=700x500")
		T.view_log(C)
	else if(href_list["action"] == "reply_to_ticket")
		//var/time = time2text(world.timeofday, "hh:mm")
		var/datum/admin_ticket/T = locate(href_list["ticket"])

		if(T.resolved && !holder)
			usr << "<span class='boldnotice'>This ticket is marked as resolved. You may not add any more information to it.</span>"
			return

		if(T.handling_admin && usr != T.handling_admin && usr != T.owner)
			usr << "<span class='boldnotice'>You are not the owner or primary admin of this ticket. You may not reply to it.</span>"
			return

		var/logtext = input("Please enter your reply:")
		logtext = sanitize(logtext)

		if(logtext)
			T.add_log(logtext)
	else if(href_list["action"] == "monitor_admin_ticket")
		if(!holder)
			return

		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.toggle_monitor()

		var/monitors_text = ""
		if(T.monitors.len > 0)
			monitors_text += "Monitors:"
			for(var/MO in T.monitors)
				monitors_text += " <span class='monitor'>[MO]</span>"

		world << output("[monitors_text] ", "ViewTicketLog[T.ticket_id].browser:set_monitors")
	else if(href_list["action"] == "administer_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.handling_admin = C
		T.log_file << "<p>[T.handling_admin] has been assigned to this ticket as primary admin.</p>"
		T.add_log("[T.handling_admin] has been assigned to this ticket as primary admin.");
		world << output("[usr != null ? "[key_name(usr, 1)]" : "Unassigned"]", "ViewTicketLog[T.ticket_id].browser:handling_user")
	else if(href_list["action"] == "resolve_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.resolved = !T.resolved
		if(T.resolved)
			T.log_file << "<p>Ticket marked as resolved by [usr].</p>"
			T.owner << "<span class='boldnotice'>Your ticket has been marked as resolved.</span>"
			for(var/O in T.monitors)
				O << "<span class='boldnotice'>\"[T.title]\" was marked as resolved.</span>"
		else
			T.log_file << "<p>Ticket marked as unresolved by [usr].</p>"
			T.owner << "<span class='boldnotice'>Your ticket has been marked as unresolved.</span>"
			for(var/O in T.monitors)
				O << "<span class='boldnotice'>\"[T.title]\" was marked as unresolved.</span>"
		world << output("[T.resolved]", "ViewTicketLog[T.ticket_id].browser:set_resolved")
	else if(href_list["action"] == "refresh_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.view_log(C)
	else if(href_list["action"] == "get_admin_ticket_json")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		world << "get_admin_ticket_json [T.title]"
		//return "{'test':'test2'}"

	else if(href_list["vv"])
		C.debug_variables(locate(href_list["vv"]))
	else if(href_list["pp"])
		C.holder.show_player_panel(locate(href_list["pp"]))
	else if(href_list["pm"])
		C.cmd_admin_pm(href_list["pm"],null)
	else if(href_list["sm"])
		C.cmd_admin_subtle_message(locate(href_list["sm"]))
	else if(href_list["jmp"])
		var/mob/N = locate(href_list["jmp"])
		if(N)
			if(!isobserver(usr))	C.admin_ghost()
			sleep(2)
			C.jumptomob(N)
