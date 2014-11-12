//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M as mob in mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!holder)
		src << "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>"
		return
	if( !ismob(M) || !M.client )	return
	cmd_admin_pm(M.client,null)
	feedback_add_details("admin_verb","APMM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!holder)
		src << "<font color='red'>Error: Admin-PM-Panel: Only administrators may use this command.</font>"
		return
	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(istype(T.mob, /mob/new_player))
				targets["(New Player) - [T]"] = T
			else if(istype(T.mob, /mob/dead/observer))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/list/sorted = sortList(targets)
	var/target = input(src,"To whom shall we send a message?","Admin PM",null) in sorted|null
	cmd_admin_pm(targets[target],null)
	feedback_add_details("admin_verb","APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_admin_pm(whom, msg)
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
		return

	var/client/C
	if(istext(whom))
		C = directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(holder)	src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
		else		adminhelp(msg)	//admin we are replying to left. adminhelp instead
		return

	// Search current tickets, is this user the owner or primary admin of a ticket
	// We are searching initially, to avoid wasting the users time. We will add more
	// information to the input dialog. Check to see if an admin has already started
	// to reply to this ticket
	//var/addToOther = 0
	var/clickedId = 0
	var/datum/admin_ticket/wasAlreadyClicked = null
	for(var/datum/admin_ticket/T in tickets_list)
		//world << "[T.ticket_id] T.handling_admin=[T.handling_admin] [get_ckey(T.handling_admin)] T.owner=[T.owner] [get_ckey(T.owner)]"
		//if(!T.resolved && T.handling_admin && !compare_ckey(T.handling_admin, usr) && compare_ckey(T.owner, C.mob))
		//	addToOther = T.ticket_id
		if(!T.resolved && T.pm_started_user && compare_ckey(T.owner, C.mob) && !compare_ckey(T.handling_admin, usr))
			if(T.pm_started_flag)
				clickedId = T.ticket_id

			wasAlreadyClicked = T

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		// Removed this one, not really necessary
		// [addToOther ? "* You are not the primary admin of ticket #[addToOther], your message will be added as supplimentary. " : ""]
		var/instructions = {"[clickedId ? "* Someone already started to reply to this ticket. If you reply, you may start a new ticket! " : ""]Message:"}

		if(wasAlreadyClicked)
			wasAlreadyClicked.pm_started_flag = 1

		msg = input(src, instructions, "Reply to ticket") as text|null

		if(!msg)
			// If the user was the user that started PM replying initially, then
			// if the user cancels the reply, we should reset it. So others can reply.
			if(wasAlreadyClicked)
				wasAlreadyClicked.pm_started_user = null
				wasAlreadyClicked.pm_started_flag = 0
			return
		if(!C)
			if(holder)	src << "<font color='red'>Error: Admin-PM: Client not found.</font>"
			else		adminhelp(msg)	//admin we are replying to has vanished, adminhelp instead
			return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0))
		msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
		if(!msg)	return

	var/has_resolved_ticket = 0

	// Search current tickets, is this user the owner or primary admin of a ticket
	for(var/datum/admin_ticket/T in tickets_list)
		if(!T.handling_admin || ((compare_ckey(T.owner, get_client(usr)) || compare_ckey(T.handling_admin, get_client(usr))) && (compare_ckey(T.owner, C) || compare_ckey(T.handling_admin, C))))
			// Hijack this PM!
			if(T.resolved && !holder)
				has_resolved_ticket = 1

			if(T.handling_admin && !compare_ckey(get_client(usr), T.handling_admin) && !compare_ckey(get_client(usr), T.owner))
				if(!holder)
					usr << "<span class='boldnotice'>You are not the owner or primary admin of this users ticket. You may not reply to it.</span>"
				return

			if(!T.resolved)
				T.add_log(msg, get_client(src))

				//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
				if(holder && !C.holder && config.popup_admin_pm)
					spawn()	//so we don't hold the caller proc up
						var/sender = src
						var/sendername = key
						var/reply = input(C, msg,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
						if(C && reply)
							if(sender)
								C.cmd_admin_pm(src,reply)										//sender is still about, let's reply to them
							else
								adminhelp(reply)													//sender has left, adminhelp instead
						return

				return

	if(has_resolved_ticket)
		usr << "<span class='boldnotice'>Your ticket was closed. Only admins can add finishing comments to it.</span>"
		return

	// If we didn't find a ticket, we should make one. This bypasses the rest of the original PM system
	var/datum/admin_ticket/T = new /datum/admin_ticket(usr, msg, C)
	if(!T.error)
		tickets_list.Add(T)
	else
		T = null

	return



	if(C.holder)
		if(holder)	//both are admins
			C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 1)]</b>: [msg]</font>"
			src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>"

		else		//recipient is an admin but sender is not
			C << "<font color='red'>Reply PM from-<b>[key_name(src, C, 1)]</b>: [msg]</font>"
			src << "<font color='blue'>PM to-<b>Admins</b>: [msg]</font>"

		//play the recieving admin the adminhelp sound (if they have them enabled)
		if(C.prefs.toggles & SOUND_ADMINHELP)
			C << 'sound/effects/adminhelp.ogg'

	else
		if(holder)	//sender is an admin but recipient is not. Do BIG RED TEXT
			C << "<font color='red' size='4'><b>-- Administrator private message --</b></font>"
			C << "<font color='red'>Admin PM from-<b>[key_name(src, C, 0)]</b>: [msg]</font>"
			C << "<font color='red'><i>Click on the administrator's name to reply.</i></font>"
			src << "<font color='blue'>Admin PM to-<b>[key_name(C, src, 1)]</b>: [msg]</font>"

			//always play non-admin recipients the adminhelp sound
			C << 'sound/effects/adminhelp.ogg'

			//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
			if(config.popup_admin_pm)
				spawn()	//so we don't hold the caller proc up
					var/sender = src
					var/sendername = key
					var/reply = input(C, msg,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
					if(C && reply)
						if(sender)
							C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
						else
							adminhelp(reply)													//sender has left, adminhelp instead
					return

		else		//neither are admins
			src << "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>"
			return

	log_admin("PM: [key_name(src)]->[key_name(C)]: [msg]")

	//we don't use message_admins here because the sender/receiver might get it too
	for(var/client/X in admins)
		if(X.key!=key && X.key!=C.key)	//check client/X is an admin and isn't the sender or recipient
			X << "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;[key_name(C, X, 0)]:</B> \blue [msg]</font>" //inform X
