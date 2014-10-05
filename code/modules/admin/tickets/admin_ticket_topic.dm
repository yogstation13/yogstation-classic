
/client/Topic(href, href_list[])
	..()
	var/mob/M = locate(href_list["src"])
	var/client/C = usr.client

	if(href_list["action"] == "view_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.view_log(M)
	else if(href_list["action"] == "reply_to_ticket")
		var/time = time2text(world.timeofday, "hh:mm")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		var/logtext = input("Please enter your reply:")

		usr << output("[time] - <b>[M]</b> - [logtext]", "ViewTicketLog.browser:add_message")

		if(logtext)
			T.add_log(M, logtext)
	else if(href_list["action"] == "monitor_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.toggle_monitor(M)
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