
/client/Topic(href, href_list[])
	..()
	var/mob/M = locate(href_list["src"])
	var/client/C = usr.client

	if(href_list["action"] == "view_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		src << browse(null, "window=ViewTickets")
		T.view_log(M)
	else if(href_list["action"] == "reply_to_ticket")
		var/time = time2text(world.timeofday, "hh:mm")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		var/logtext = input("Please enter your reply:")

		if(holder)
			if(src != T.user)
				T.handling_admin = src
				usr << output("[key_name(T.handling_admin, 1)]", "ViewTicketLog.browser:handling_user")
				T.user << output("[key_name(T.handling_admin, 1)]", "ViewTicketLog.browser:handling_user")

		usr << output("[time] - <b>[M]</b> - [logtext]", "ViewTicketLog.browser:add_message")
		if(src != T.user)
			T.user << output("[time] - <b>[M]</b> - [logtext]", "ViewTicketLog.browser:add_message")

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

		usr << output("[monitors_text] ", "ViewTicketLog.browser:set_monitors")
		if(src != T.user)
			T.user << output("[monitors_text] ", "ViewTicketLog.browser:set_monitors")
	else if(href_list["action"] == "administer_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.handling_admin = M
		usr << output("[key_name(src, 1)]", "ViewTicketLog.browser:handling_user")
		if(src != T.user)
			T.user << output("[key_name(src, 1)]", "ViewTicketLog.browser:handling_user")
	else if(href_list["action"] == "resolve_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.resolved = !T.resolved
		if(T.resolved)
			T.user << "Your ticket has been marked as resolved."
			for(var/O in T.monitors)
				O << "\"[T.title]\" was marked as resolved."
		else
			T.user << "Your ticket has been marked as unresolved."
			for(var/O in T.monitors)
				O << "\"[T.title]\" was marked as unresolved."
		usr << output("[T.resolved]", "ViewTicketLog.browser:set_resolved")
		if(src != T.user)
			T.user << output("[T.resolved]", "ViewTicketLog.browser:set_resolved")
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
