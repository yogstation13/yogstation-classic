
/client/Topic(href, href_list[])
	..()
	var/mob/M = locate(href_list["src"])
	var/client/C = usr.client

	if(href_list["action"] == "view_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		// Close ticket list when opening ticket
		//src << browse(null, "window=ViewTickets;size=700x500")
		T.view_log(M)
	else if(href_list["action"] == "reply_to_ticket")
		var/time = time2text(world.timeofday, "hh:mm")
		var/datum/admin_ticket/T = locate(href_list["ticket"])

		if(T.handling_admin && src != T.handling_admin && src != T.owner)
			usr << "You are not the owner or primary admin of this ticket. You may not reply to it."
			return

		var/logtext = input("Please enter your reply:")

		if(holder && !T.handling_admin)
			if(src != T.owner)
				T.handling_admin = src
				T.add_log("[T.handling_admin] has been assigned to this ticket as primary admin.");
				usr << output("[key_name(T.handling_admin, 1)]", "ViewTicketLog[T.ticket_id].browser:handling_user")
				T.owner << output("[key_name(T.handling_admin, 1)]", "ViewTicketLog[T.ticket_id].browser:handling_user")

		usr << output("[time] - <b>[M]</b> - [logtext]", "ViewTicketLog[T.ticket_id].browser:add_message")
		if(src != T.owner)
			T.owner << output("[time] - <b>[M]</b> - [logtext]", "ViewTicketLog[T.ticket_id].browser:add_message")

		if(logtext)
			T.add_log(M, logtext)
	else if(href_list["action"] == "monitor_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.toggle_monitor(M)

		var/monitors_text = ""
		if(T.monitors.len > 0)
			monitors_text += "Monitors:"
			for(var/MO in T.monitors)
				monitors_text += " [MO]"

		usr << output("[monitors_text] ", "ViewTicketLog[T.ticket_id].browser:set_monitors")
		if(src != T.owner)
			T.owner << output("[monitors_text] ", "ViewTicketLog[T.ticket_id].browser:set_monitors")
	else if(href_list["action"] == "administer_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.handling_admin = M
		T.add_log("[T.handling_admin] has been assigned to this ticket as primary admin.");
		usr << output("[key_name(src, 1)]", "ViewTicketLog[T.ticket_id].browser:handling_user")
		if(src != T.owner)
			T.owner << output("[key_name(src, 1)]", "ViewTicketLog[T.ticket_id].browser:handling_user")
	else if(href_list["action"] == "resolve_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.resolved = !T.resolved
		if(T.resolved)
			T.owner << "Your ticket has been marked as resolved."
			for(var/O in T.monitors)
				O << "\"[T.title]\" was marked as resolved."
		else
			T.owner << "Your ticket has been marked as unresolved."
			for(var/O in T.monitors)
				O << "\"[T.title]\" was marked as unresolved."
		usr << output("[T.resolved]", "ViewTicketLog[T.ticket_id].browser:set_resolved")
		if(src != T.owner)
			T.owner << output("[T.resolved]", "ViewTicketLog[T.ticket_id].browser:set_resolved")
	else if(href_list["action"] == "refresh_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.view_log(M)
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
