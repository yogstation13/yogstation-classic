
/datum/admin_ticket/proc/test()
	owner << "Ticket title is \"[title]\" for user \"[owner]\""

/datum/admin_ticket/proc/add_log(calling_user as mob, log_message as text)
	if(!log_message)
		return

	var/time = time2text(world.timeofday, "hh:mm")
	var/message = "[time] - <b>[calling_user]</b> - [log_message]"
	log += "[message]"

	log_file << "<p>[message]</p>"

	var/found = 0

	for(var/M in monitors)
		M << "\"[log_message]\" added to <a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>ticket</a> by [calling_user]"
		if(M == calling_user)
			found = 1

	if(handling_admin)
		handling_admin << "\"[log_message]\" added to <a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>ticket</a> by [calling_user]"

	if(owner && calling_user != owner)
		calling_user << "\"[log_message]\" added to <a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>your ticket</a> by [calling_user]"
	else if(!found)
		calling_user << "<a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>Your reply</a> has been noted "

/datum/admin_ticket/proc/toggle_monitor(calling_user as mob)
	var/found = 0
	for(var/M in monitors)
		if(M == calling_user)
			found = 1

	if(!found)
		log_file << "<p>[calling_user] is now monitoring this ticket.</p>"
		monitors += calling_user
		calling_user << "You are now monitoring this ticket"
		if(owner)
			owner << "[calling_user] is now monitoring your ticket"
		return 1
	else
		log_file << "<p>[calling_user] is no longer monitoring this ticket.</p>"
		monitors -= calling_user
		calling_user << "You are no longer monitoring this ticket"
		if(owner)
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

	if(usr.client.holder)
		content += {"<div class='user-bar'>
			<p>[key_name(owner, 1)]</p>"}

		content += {"<p style='margin-top: 5px;'>
				<a href='?_src_=holder;adminmoreinfo=\ref[owner.mob]'><img width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
				<a href='?pp=\ref[owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
				<a href='?vv=\ref[owner.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
				<a href='?sm=\ref[owner.mob]'><img width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
				<a href='?jmp=\ref[owner.mob]'><img width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
				<a href='?src=\ref[calling_user];action=monitor_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
				<a href='?src=\ref[calling_user];action=resolve_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
				<a href='?src=\ref[calling_user];action=administer_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-flag' /> Administer</a>
			</p>
			</div>"}

		if(owner.mob)
			if(owner.mob.mind && owner.mob.mind.assigned_role)
				content += "<p class='user-info-bar'>Role: [owner.mob.mind.assigned_role]</p>"
				if(owner.mob.mind.special_role)
					content += "<p class='user-info-bar'>Antagonist: [owner.mob.mind.special_role]</p>"
				else
					content += "<p class='user-info-bar'>Antagonist: No</p>"

			var/turf/T = get_turf(owner.mob)

			var/location = ""
			if(isturf(T))
				if(isarea(T.loc))
					location = "([owner.mob.loc == T ? "at " : "in [owner.mob.loc] at "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
				else
					location = "([owner.mob.loc == T ? "at " : "in [owner.mob.loc] at "] [T.x], [T.y], [T.z])"

			if(location)
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
