
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

	/*src << "href=[href]"
	for(var/ref in href_list)
		var/item = href_list[ref]
		src << "ref=[ref] item=[item]"*/