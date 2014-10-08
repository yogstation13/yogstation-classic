
/datum/admin_ticket/proc/test()
	owner << "Ticket title is \"[title]\" for user \"[owner]\""

/datum/admin_ticket/proc/add_log(calling_user as mob, log_message as text)
	if(!log_message)
		return

	var/time = time2text(world.timeofday, "hh:mm")
	log += "[time] - <b>[calling_user]</b> - [log_message]"

	var/found = 0

	for(var/M in monitors)
		M << "\"[log_message]\" added to ticket by [calling_user]"
		if(M == calling_user)
			found = 1

	if(handling_admin)
		handling_admin << "\"[log_message]\" added to ticket by [calling_user]"

	if(calling_user != owner)
		calling_user << "\"[log_message]\" added to your ticket by [calling_user]"
	else if(!found)
		calling_user << "Your reply has been noted"

/datum/admin_ticket/proc/toggle_monitor(calling_user as mob)
	var/found = 0
	for(var/M in monitors)
		if(M == calling_user)
			found = 1

	if(!found)
		monitors += calling_user
		calling_user << "You are now monitoring this ticket"
		owner << "[calling_user] is now monitoring your ticket"
		return 1
	else
		monitors -= calling_user
		calling_user << "You are no longer monitoring this ticket"
		owner << "[calling_user] is no longer monitoring your ticket"
		return 0

/datum/admin_ticket/proc/view_log(mob/calling_user as mob)
	var/reply_link = "<a href='?src=\ref[calling_user];action=reply_to_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-comment' /> Reply</a>"
	var/refresh_link = "<a href='?src=\ref[calling_user];action=refresh_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-refresh' /> Refresh</a>"

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
			<p>[key_name(owner, 1)]</p>"}

		content += {"<p style='margin-top: 5px;'>
				<a href='?_src_=holder;adminmoreinfo=[ref_mob]'><img width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
				<a href='?pp=[ref_mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
				<a href='?vv=[ref_mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
				<a href='?sm=[ref_mob]'><img width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
				<a href='?jmp=[ref_mob]'><img width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
				<a href='?src=\ref[calling_user];action=monitor_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
				<a href='?src=\ref[calling_user];action=resolve_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
				<a href='?src=\ref[calling_user];action=administer_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-flag' /> Administer</a>
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

	calling_user << browse(null, "window=ViewTicketLog[ticket_id];size=700x500")
	calling_user << browse(html, "window=ViewTicketLog[ticket_id];size=700x500")
