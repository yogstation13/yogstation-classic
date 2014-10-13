
/datum/admin_ticket/proc/test()
	owner << "Ticket title is \"[title]\" for user \"[owner]\""

/datum/admin_ticket/proc/add_log(calling_user as mob, log_message as text)
	if(!log_message)
		return

	log_message = sanitize(log_message)

	var/time = time2text(world.timeofday, "hh:mm")
	var/message = "[time] - <b>[calling_user]</b> - [log_message]"
	log += "[message]"

	world << output(message, "ViewTicketLog[ticket_id].browser:add_message")

	log_file << "<p>[message]</p>"

	var/found = 0

	for(var/M in monitors)
		if(owner == M || calling_user == handling_admin)
			break

		M << "<font color='red' size='3'><b>-- Ticket #[ticket_id] - New message <a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>View</a> --</b></font>"
		M << "<span>-- <b>[calling_user]</b>: [log_message]</span>"
		if(M == calling_user)
			found = 1

	if(handling_admin != calling_user)
		handling_admin << "<font color='red' size='3'><b>-- Ticket #[ticket_id] - New message <a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>View</a> --</b></font>"
		handling_admin << "<span>-- <b>[calling_user]</b>: [log_message]</span>"

	owner << "<font color='red' size='4'><b>-- Ticket #[ticket_id] - New message <a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>View</a> --</b></font>"
	owner << "<span>-- <b>[calling_user]</b>: [log_message]</span>"

	if(!found && calling_user != owner)
		calling_user << "<font color='red' size='4'><b>-- Ticket #[ticket_id] - New message <a href='?src=\ref[calling_user];action=view_admin_ticket;ticket=\ref[src]'>View</a> --</b></font>"
		calling_user << "<span>-- <b>[calling_user]</b>: [log_message]</span>"

/datum/admin_ticket/proc/toggle_monitor(calling_user as mob)
	var/found = 0
	for(var/M in monitors)
		if(M == calling_user)
			found = 1

	if(!found)
		log_file << "<p>[calling_user] is now monitoring this ticket.</p>"
		monitors += calling_user
		calling_user << "<span class='boldnotice'>You are now monitoring this ticket</span>"
		if(owner)
			owner << "<span class='boldnotice'>[calling_user] is now monitoring your ticket</span>"
		return 1
	else
		log_file << "<p>[calling_user] is no longer monitoring this ticket.</p>"
		monitors -= calling_user
		calling_user << "<span class='boldnotice'>You are no longer monitoring this ticket</span>"
		if(owner)
			owner << "<span class='boldnotice'>[calling_user] is no longer monitoring your ticket</span>"
		return 0

/datum/admin_ticket/proc/view_log(mob/calling_user as mob)
	var/reply_link = "<a href='?src=\ref[calling_user];action=reply_to_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-comment' /> Reply</a>"
	var/refresh_link = "<a href='?src=\ref[calling_user];action=refresh_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-refresh' /> Refresh</a>"

	var/content = ""
	content += "<p class='control-bar'>[reply_link] [refresh_link]</p>"
	content += "<p class='title-bar'>[title]</p>"
	content += "<p class='info-bar'>Primary Admin: <span id='primary-admin'>[handling_admin != null ? (usr.client.holder ? key_name(handling_admin, 1) : "[handling_admin]") : "Unassigned"]</span></p>"

	content += "<p id='monitors' class='[monitors.len > 0 ? "shown" : "hidden"]'>Monitors:"
	for(var/M in monitors)
		content += " <span class='monitor'>[M]</span>"
	content += "</p>"

	content += "<p class='resolved-bar [resolved ? "resolved" : "unresolved"]' id='resolved'>[resolved ? "Is resolved" : "Is not resolved"]</p>"

	if(usr.client.holder)
		content += {"<div class='user-bar'>
			<p>[key_name(owner, 1)]</p>"}

		if(owner && owner.mob)
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


	var/i = 0
	for(i = log.len; i > 0; i--)
		content += "<p class='message-bar'>[log[i]]</p>"

	/*for(var/line in log)
		content += "<p class='message-bar'>[line]</p>"*/

	content += "</div>"
	content += "<p class='control-bar'>[reply_link] [refresh_link]</p>"
	content += "<br /></div></body></html>"

	var/html = get_html("Admin Ticket Interface", "", "", content)

	calling_user << browse(null, "window=ViewTicketLog[ticket_id];size=700x500")
	calling_user << browse(html, "window=ViewTicketLog[ticket_id];size=700x500")
