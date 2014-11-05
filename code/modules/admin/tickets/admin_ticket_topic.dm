
/client/Topic(href, href_list[])
	..()
	//var/mob/M = locate(href_list["src"])
	var/client/C = usr.client

	if(href_list["action"] == "view_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		// Close ticket list when opening ticket
		//src << browse(null, "window=ViewTickets;size=700x500")
		if(!istype(T, /datum/admin_ticket))
			return
		T.view_log(C.mob)
	else if(href_list["action"] == "reply_to_ticket")
		if(prefs.muted & MUTE_ADMINHELP)
			src << "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>"
			return

		//var/time = time2text(world.timeofday, "hh:mm")
		var/datum/admin_ticket/T = locate(href_list["ticket"])

		if(!istype(T, /datum/admin_ticket))
			return

		if(T.resolved && !holder)
			usr << "<span class='ticket-status'>This ticket is marked as resolved. You may not add any more information to it.</span>"
			return

		if(!compare_ckey(usr, T.handling_admin) && !compare_ckey(usr, T.owner_ckey) && !holder)
			usr << "<span class='ticket-status'>You are not the owner or primary admin of this ticket. You may not reply to it.</span>"
			return

		var/logtext = input("Please enter your [(!compare_ckey(usr, T.handling_admin) && !compare_ckey(usr, T.owner_ckey) ? "supplimentary comment" : "reply")]:")
		//clean the message if it's not sent by a high-rank admin
		if(!check_rights(R_SERVER|R_DEBUG,0))
			logtext = sanitize(copytext(logtext,1,MAX_MESSAGE_LEN))

		if(logtext)
			T.add_log(logtext, src.mob)

		//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
		if(holder && T.owner && T.owner.client && compare_ckey(usr, T.handling_admin) && config.popup_admin_pm)
			spawn()	//so we don't hold the caller proc up
				var/sender = C
				var/sendername = C.key
				var/reply = input(T.owner, logtext,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
				if(reply)
					if(sender)
						T.owner.client.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
					else
						adminhelp(reply)													//sender has left, adminhelp instead
				return
	else if(href_list["action"] == "monitor_admin_ticket")
		if(!holder)
			return

		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			return
		T.toggle_monitor()

		var/monitors_text = ""
		if(T.monitors.len > 0)
			monitors_text += "Monitors:"
			for(var/MO in T.monitors)
				monitors_text += " <span class='monitor'>[get_fancy_key(MO)]</span>"

		world << output("[monitors_text] ", "ViewTicketLog[T.ticket_id].browser:set_monitors")
	else if(href_list["action"] == "administer_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			return
		T.handling_admin = C.mob
		log_admin("[T.handling_admin] has been assigned to ticket #[T.ticket_id] as primary admin.")
		// For Alex: Primary admin notification not necessary
		//T.add_log("[T.handling_admin] has been assigned to this ticket as primary admin.");
		world << output("[usr != null ? "[key_name(usr, 1)]" : "Unassigned"]", "ViewTicketLog[T.ticket_id].browser:handling_user")

		if(href_list["reloadlist"])
			C.view_tickets()
	else if(href_list["action"] == "resolve_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			return
		T.toggle_resolved()
		if(T.resolved)
			log_admin("Ticket #[T.ticket_id] marked as resolved by [get_fancy_key(usr)].")
			T.owner << "<span class='ticket-text-received'>Your ticket has been marked as resolved.</span>"
			for(var/O in T.monitors)
				O << "<span class='ticket-text-received'>\"[T.title]\" was marked as resolved.</span>"
		else
			log_admin("Ticket #[T.ticket_id] marked as unresolved by [get_fancy_key(usr)].")
			T.owner << "<span class='ticket-text-received'>Your ticket has been marked as unresolved.</span>"
			for(var/O in T.monitors)
				O << "<span class='ticket-text-received'>\"[T.title]\" was marked as unresolved.</span>"
		world << output("[T.resolved]", "ViewTicketLog[T.ticket_id].browser:set_resolved")

		if(href_list["reloadlist"])
			C.view_tickets()
	else if(href_list["action"] == "refresh_admin_ticket")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			return
		T.view_log(C)
	else if(href_list["action"] == "get_admin_ticket_json")
		var/datum/admin_ticket/T = locate(href_list["ticket"])
		if(!istype(T, /datum/admin_ticket))
			return
		world << "get_admin_ticket_json [T.title]"
		//return "{'test':'test2'}"

	else if(href_list["vv"])
		if(!holder || !ismob(locate(href_list["vv"])))
			return
		C.debug_variables(locate(href_list["vv"]))
	else if(href_list["pp"])
		if(!holder || !ismob(locate(href_list["pp"])))
			return
		C.holder.show_player_panel(locate(href_list["pp"]))
	else if(href_list["pm"])
		C.cmd_admin_pm(href_list["pm"],null)
	else if(href_list["sm"])
		if(!holder || !ismob(locate(href_list["sm"])))
			return
		C.cmd_admin_subtle_message(locate(href_list["sm"]))
	else if(href_list["jmp"])
		if(!holder || !ismob(locate(href_list["jmp"])))
			return
		var/mob/N = locate(href_list["jmp"])
		if(N)
			if(!isobserver(usr))	C.admin_ghost()
			sleep(2)
			C.jumptomob(N)
