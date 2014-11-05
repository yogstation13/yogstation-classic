
/datum/admin_ticket/proc/test()
	owner << "Ticket title is \"[title]\" for user \"[owner]\""

/datum/admin_ticket/proc/add_log(log_message as text, mob/user)
	if(!user)
		user = usr

	if(!log_message)
		return

	if(compare_ckey(user, owner_ckey))
		owner = user

	if(user.client.holder && !handling_admin)
		if(!compare_ckey(user, owner_ckey))
			handling_admin = user
			// For Alex: Do not report primary admin set
			//add_log("[handling_admin] has been assigned to this ticket as primary admin.");
			world << output("[key_name_params(handling_admin, 1, 1, null, src)]", "ViewTicketLog[ticket_id].browser:handling_user")

	//var/time = time2text(world.timeofday, "hh:mm")
	var/message = "[gameTimestamp()] - <b>[key_name_params(user, 0, 0, null, src)]</b> - [log_message]"
	log += "[message]"

	world << output(message, "ViewTicketLog[ticket_id].browser:add_message")

	log_admin("Ticket #[ticket_id] message: [message]")

	var/foundMonitor = 0
	for(var/M in monitors)
		if(compare_ckey(owner_ckey, M) || compare_ckey(user, handling_admin))
			break

		// For Alex: No bigred text for monitors
		//M << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
		if(compare_ckey(user, owner))
			M << "<span class='ticket-text-monitored'>-- <i>[key_name_params(user, 1, 1, null, src)]</i> -> <i>[key_name_params(owner, 0, 0, null, src)]</i>: [log_message]</span>"
		else
			M << "<span class='ticket-text-monitored'>-- <i>[key_name_params(user, 1, 1, null, src)]</i> -> <i>[key_name_params(handling_admin, 0, 0, null, src)]</i>: [log_message]</span>"

		if(has_pref(M, SOUND_ADMINHELP))
			M << 'sound/effects/adminhelp.ogg'
		if(compare_ckey(M, user))
			foundMonitor = 1

	for(var/client/X in admins)
		if(has_pref(X, TICKET_ALL))
			if(compare_ckey(owner, X) || compare_ckey(handling_admin, X) || X in monitors)
				continue
			X << "<span class='ticket-text-monitored'>-- <i>[key_name_params(user, 1, 1)]</i> -> <i><a href='?src=\ref[user];action=view_admin_ticket;ticket=\ref[src]'>Ticket #[src.ticket_id]</a></i>: [log_message]</span>"

	if(!compare_ckey(handling_admin, user))
		// For Alex: No bigred for admins
		//handling_admin << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
		handling_admin << "<span class='ticket-text-received'>-- <i>[key_name_params(user, 1, 1, null, src)]</i> -> <i>[key_name_params(handling_admin, 0, 0, null, src)]</i>: [log_message]</span>"
		if(has_pref(handling_admin, SOUND_ADMINHELP))
			handling_admin << 'sound/effects/adminhelp.ogg'

	if(compare_ckey(owner_ckey, user) || compare_ckey(handling_admin, user))
		if(!compare_ckey(owner_ckey, user))
			if(!is_admin(owner)) owner << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
			if(has_pref(owner, SOUND_ADMINHELP))
				owner << 'sound/effects/adminhelp.ogg'

		if(compare_ckey(owner_ckey, user))
			owner << "<span class='ticket-text-sent'>-- <i>[key_name_params(owner, 0, 0, null, src)]</i> -> <i>[is_admin(owner) ? key_name_params(handling_admin, 1, 1, null, src) : key_name_params(handling_admin, 1, 0, null, src)]</i>: [log_message]</span>"
		else
			owner << "<span class='ticket-text-received'>-- <i>[is_admin(owner) ? key_name_params(user, 1, 1, null, src) : key_name_params(user, 1, 0, null, src)]</i> -> <i>[key_name_params(owner, 0, 0, null, src)]</i>: [log_message]</span>"

	if(!foundMonitor && !compare_ckey(user, owner_ckey))
		//user << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
		user << "<span class='ticket-text-sent'>-- <i>[is_admin(user) ? key_name_params(user, 0, 1, null, src) : "[key_name_params(user, 0, 0, null, src)]"]</i> -> <i>[is_admin(owner) ? key_name_params(owner, 1, 1, null, src) : "[key_name_params(owner, 1, 0, null, src)]"]</i>: [log_message]</span>"
		//user << "<span class='ticket-text-sent'>-- <i>[is_admin(user) ? key_name(user, 1) : "<a href='?priv_msg=[get_ckey(user)]'>[get_ckey(user)]</a>"]</i> -> <i>[get_fancy_key(owner)]</i>: [log_message]</span>"

		// Is this necessary? It sounds when YOU send a message.
		//if(has_pref(user, SOUND_ADMINHELP))
		//	user << 'sound/effects/adminhelp.ogg'

/datum/admin_ticket/proc/toggle_monitor()
	var/foundMonitor = 0
	for(var/M in monitors)
		if(compare_ckey(M, usr))
			foundMonitor = 1

	if(!foundMonitor)
		log_admin("[usr] is now monitoring ticket #[ticket_id]")
		monitors += usr
		usr << "<span class='ticket-status'>You are now monitoring this ticket</span>"
		if(owner)
			owner << "<span class='ticket-status'>[usr] is now monitoring your ticket</span>"
		return 1
	else
		log_admin("[usr] is no longer monitoring ticket #[ticket_id]")
		monitors -= usr
		usr << "<span class='ticket-status'>You are no longer monitoring this ticket</span>"
		if(owner)
			owner << "<span class='ticket-status'>[usr] is no longer monitoring your ticket</span>"
		return 0

/datum/admin_ticket/proc/toggle_resolved()
	resolved = !resolved

	if(resolved && ticker.delay_end)
		var/unresolvedCount = 0
		for(var/datum/admin_ticket/T in tickets_list)
			if(!resolved)
				unresolvedCount++

		if(unresolvedCount)
			if(alert(usr, "You have resolved the last ticket (the server restart is currently delayed!). Would you like to restart the server now?", "Restart Server", "Restart", "Cancel") == "Restart")
				sleep(ticker.restart_timeout)
				kick_clients_in_lobby("\red The round came to an end with you in the lobby.", 1) //second parameter ensures only afk clients are kicked
				world.Reboot()
			else
				usr << "<span class='ticket-status'>You chose not to restart the server. If you do not have permissions to restart the server normally, you can still do so by making a new ticket and resolving it again.</span>"

/datum/admin_ticket/proc/view_log()
	var/reply_link = "<a href='?src=\ref[usr];action=reply_to_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-comment' /> Reply</a>"
	var/refresh_link = "<a href='?src=\ref[usr];action=refresh_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-refresh' /> Refresh</a>"

	var/content = ""
	content += "<p class='control-bar'>[reply_link] [refresh_link]</p>"
	content += "<p class='title-bar'>[title]</p>"
	content += "<p class='info-bar'>Primary Admin: <span id='primary-admin'>[handling_admin != null ? (usr.client.holder ? key_name_params(handling_admin, 1, 1, null, src) : "[key_name_params(handling_admin, 1, 0, null, src)]") : "Unassigned"]</span></p>"

	content += "<p id='monitors' class='[monitors.len > 0 ? "shown" : "hidden"]'>Monitors:"
	for(var/M in monitors)
		content += " <span class='monitor'>[key_name(M, 0, 0)]</span>"
	content += "</p>"

	content += "<p class='resolved-bar [resolved ? "resolved" : "unresolved"]' id='resolved'>[resolved ? "Is resolved" : "Is not resolved"]</p>"

	if(usr.client.holder && owner)
		content += {"<div class='user-bar'>
			<p>[key_name(owner, 1)]</p>"}

		if(owner.client && owner.client.mob)
			content += {"<p style='margin-top: 5px;'>
					<a href='?_src_=holder;adminmoreinfo=\ref[owner.client.mob]'><img width='16' height='16' class='uiIcon16 icon-search' /> ?</a>
					<a href='?pp=\ref[owner.client.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> PP</a>
					<a href='?vv=\ref[owner.client.mob]'><img width='16' height='16' class='uiIcon16 icon-clipboard' /> VV</a>
					<a href='?sm=\ref[owner.client.mob]'><img width='16' height='16' class='uiIcon16 icon-mail-closed' /> SM</a>
					<a href='?jmp=\ref[owner.client.mob]'><img width='16' height='16' class='uiIcon16 icon-arrowthick-1-e' /> JMP</a>
					<a href='?src=\ref[usr];action=monitor_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-pin-s' /> (Un)Monitor</a>
					<a href='?src=\ref[usr];action=resolve_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-check' /> (Un)Resolve</a>
					<a href='?src=\ref[usr];action=administer_admin_ticket;ticket=\ref[src]'><img width='16' height='16' class='uiIcon16 icon-flag' /> Administer</a>
				</p>"}

			if(owner.client.mob.mind && owner.client.mob.mind.assigned_role)
				content += "<p class='user-info-bar'>Role: [owner.client.mob.mind.assigned_role]</p>"
				if(owner.client.mob.mind.special_role)
					content += "<p class='user-info-bar'>Antagonist: [owner.client.mob.mind.special_role]</p>"
				else
					content += "<p class='user-info-bar'>Antagonist: No</p>"

			var/turf/T = get_turf(owner.client.mob)

			var/location = ""
			if(isturf(T))
				if(isarea(T.loc))
					location = "([owner.client.mob.loc == T ? "at " : "in [owner.client.mob.loc] at "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
				else
					location = "([owner.client.mob.loc == T ? "at " : "in [owner.client.mob.loc] at "] [T.x], [T.y], [T.z])"

			if(location)
				content += "<p class='user-info-bar'>Location: [location]</p>"

		content += "</div>"

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

	usr << browse(null, "window=ViewTicketLog[ticket_id];size=700x500")
	usr << browse(html, "window=ViewTicketLog[ticket_id];size=700x500")
