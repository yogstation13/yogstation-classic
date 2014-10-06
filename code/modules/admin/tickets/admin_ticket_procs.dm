
/datum/admin_ticket/proc/test()
	user << "Ticket title is \"[title]\" for user \"[user]\""

/datum/admin_ticket/proc/add_log(nuser as mob, ndata as text)
	var/time = time2text(world.timeofday, "hh:mm")
	log += "[time] - <b>[nuser]</b> - [ndata]"

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
		user << "[nuser] is now monitoring your ticket"
		return 1
	else
		monitors -= nuser
		nuser << "You are no longer monitoring this ticket"
		user << "[nuser] is no longer monitoring your ticket"
		return 0

/datum/admin_ticket/proc/view_log(mob/nsrc as mob)
	var/reply_link = "<a href='?src=\ref[nsrc];action=reply_to_ticket;ticket=\ref[src]'>Reply</a>"
	var/refresh_link = "<a href='?src=\ref[nsrc];action=refresh_admin_ticket;ticket=\ref[src]'>Refresh</a>"

	var/content = ""
	content += "<p class='control-bar'>[reply_link] [refresh_link]</p>"
	content += "<p class='info-bar'>Primary Admin: <span id='primary-admin'>[handling_admin != null ? key_name(handling_admin, 1) : "Unassigned"]</span></p>"

	content += "<p id='monitors' class='[monitors.len > 0 ? "shown" : "hidden"]'>Monitors:"
	for(var/M in monitors)
		content += " [M]"
	content += "</p>"

	content += "<p class='resolved-bar [resolved ? "resolved" : "unresolved"]' id='resolved'>[resolved ? "Is resolved" : "Is not resolved"]</p>"

	var/mob/M = usr.client.mob

	if(usr.client.holder)
		content += {"<div class='user-bar'>
			<p>[key_name(user, 1)]</p>"}

		content += {"<p style='margin-top: 5px;'>
				<a href='?_src_=holder;adminmoreinfo=[ref_mob]'>?</a>
				<a href='?pp=[ref_mob]'>PP</a> <a href='?vv=[ref_mob]'>VV</a>
				<a href='?sm=[ref_mob]'>SM</a> <a href='?jmp=[ref_mob]'>JMP</a>
				<a href='?src=\ref[user];action=monitor_admin_ticket;ticket=\ref[src]'>(Un)Monitor</a>
				<a href='?src=\ref[user];action=resolve_admin_ticket;ticket=\ref[src]'>(Un)Resolve</a>
				<a href='?src=\ref[user];action=administer_admin_ticket;ticket=\ref[src]'>Administer</a>
			</p>
			</div>"}

		if(M)
			if(M.mind.assigned_role)
				content += "<p class='user-info-bar'>Role: [M.mind.assigned_role]</p>"
				if(M.mind.special_role)
					content += "<p class='user-info-bar'>Antagonist: [M.mind.special_role]</p>"
				else
					content += "<p class='user-info-bar'>Antagonist: No</p>"

			var/turf/T = get_turf(M)
			var/location = ""
			if(isturf(T))
				if(isarea(T.loc))
					location = "([M.loc == T ? "at " : "in [M.loc] at "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
				else
					location = "([M.loc == T ? "at " : "in [M.loc] at "] [T.x], [T.y], [T.z])"
			content += "<p class='user-info-bar'>Location: [location]</p>"

	content += "<div id='messages'>"
	for(var/line in log)
		content += "<p class='message-bar'>[line]</p>"
	content += "</div>"
	content += "<p class='control-bar'>[reply_link] [refresh_link]</p>"
	content += "<br /></div></body></html>"

	var/html = get_html("Admin Ticket Interface", "", "", content)

	nsrc << browse(null, "window=ViewTicketLog")
	nsrc << browse(html, "window=ViewTicketLog")
