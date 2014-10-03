
/datum/admin_ticket/proc/test()
	user << "Ticket title is \"[title]\" for user \"[user]\""

/datum/admin_ticket/proc/add_log(nuser as mob, ndata as text)
	var/time = time2text(world.timeofday, "hh:mm")
	log += "[time] - [key_name(nuser, 1)] - [ndata]"

	var/found = 0

	for(var/M in monitors)
		M << "\"[ndata]\" added to ticket by [nuser]"
		if(M == nuser)
			found = 1

	if(nuser != user)
		nuser << "\"[ndata]\" added to your ticket by [nuser]"
	else if(!found)
		nuser << "Your reply has been noted"

/datum/admin_ticket/proc/toggle_monitor(nuser as mob)
	var/found = 0
	for(var/M in monitors)
		if(M == nuser)
			found = 1

	if(!found)
		monitors += nuser
		nuser << "You are now monitoring this ticket"
	else
		monitors -= nuser
		nuser << "You are no longer monitoring this ticket"

/datum/admin_ticket/proc/view_log(nsrc as mob)
	var/reply_link = "<a href='?src=\ref[nsrc];action=reply_to_ticket;ticket=\ref[src]'>Reply</a>"

	nsrc << "----- TICKET ----- [title] ----- [reply_link] -----"
	for(var/line in log)
		nsrc << "   [line]"
	nsrc << "---------------------------------[reply_link]-----"