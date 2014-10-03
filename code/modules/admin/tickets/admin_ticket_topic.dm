
/client/Topic(href, href_list[])
	..()
	var/mob/M = locate(href_list["src"])

	if(href_list["action"] == "view_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		T.view_log(M)
	else if(href_list["action"] == "reply_to_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		var/logtext = input("Please enter your reply:")

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