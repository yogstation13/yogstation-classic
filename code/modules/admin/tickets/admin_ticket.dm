

/*
/var/obj/admin_ticket_interface/admin_ticket_interface = new()

/client/proc/admin_ticket_interface()
	set name = "admin_ticket_interface"
	set category = "Admin"

	admin_ticket_interface.start()

/obj/admin_ticket_interface
	var/datum/admin_ticket/current_ticket

/obj/admin_ticket_interface/proc/start()
	ui_interact()

/obj/admin_ticket_interface/proc/get()
	var/data[0]

	data["title"] = current_ticket.title
	data["current_time"] = round(world.time/10,1)

	world << "get [current_ticket.title] [world.time]"

	return data

/obj/admin_ticket_interface/proc/set_ticket(var/datum/admin_ticket/T)
	current_ticket = T

/obj/admin_ticket_interface/ui_interact(mob/user = usr, ui_key = "adminticket", var/datum/nanoui/ui = null)
	var/data[0]

	data["title"] = current_ticket.title
	data["current_time"] = round(world.time/10,1)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if(!ui)
		ui = new(user, src, ui_key, "admin_ticket_interface.tmpl", "Admin Ticket Interface", 800, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
*/




/var/list/tickets_list = list()

/datum/admin_ticket
	var/mob/user
	var/ref_mob
	var/title
	var/list/log = list()
	var/resolved = 0
	var/list/monitors = list()
	var/list/handling_admin = null
	var/browser

/datum/admin_ticket/New(nuser, nmob, ntitle)
	user = nuser
	if(ntitle)
		title = format_text(ntitle)

	// var/ai_found = isAI(user.ckey)
	ref_mob = "\ref[nmob]"
	// var/msg = "<span class='boldnotice'><font color=red>New ticket created: </font>[key_name(user, 1)] (<a href='?_src_=holder;adminmoreinfo=[ref_mob]'>?</a>) (<a href='?_src_=holder;adminplayeropts=[ref_mob]'>PP</a>) (<a href='?_src_=vars;Vars=[ref_mob]'>VV</a>) (<a href='?_src_=holder;subtlemessage=[ref_mob]'>SM</a>) (<a href='?_src_=holder;adminplayerobservejump=[ref_mob]'>JMP</a>) (<a href='?_src_=holder;secretsadmin=check_antagonist'>CA</a>) [ai_found ? " (<a href='?_src_=holder;adminchecklaws=[ref_mob]'>CL</a>)" : ""]:</b> [title] <a href='?src=\ref[user];action=view_admin_ticket;ticket=\ref[src]'>View</a> <a href='?src=\ref[user];action=monitor_admin_ticket;ticket=\ref[src]'>(Un)Monitor</a> <a href='?src=\ref[user];action=resolve_admin_ticket;ticket=\ref[src]'>(Un)Resolve</a></span>"
	var/msg = "<span class='boldnotice'><font color=red>New ticket created: </font>[key_name(user, 1)]: [title] <b><a href='?src=\ref[user];action=view_admin_ticket;ticket=\ref[src]'>View</a></b></span>"

	//send this msg to all admins
	var/admin_number_total = 0		//Total number of admins
	var/admin_number_afk = 0		//Holds the number of admins who are afk
	var/admin_number_ignored = 0	//Holds the number of admins without +BAN (so admins who are not really admins)
	var/admin_number_decrease = 0	//Holds the number of admins with are afk, ignored or both
	for(var/client/X in admins)
		admin_number_total++
		var/invalid = 0
		if(!check_rights_for(X, R_BAN))
			admin_number_ignored++
			invalid = 1
		if(X.is_afk())
			admin_number_afk++
			invalid = 1
		if(invalid)
			admin_number_decrease++
		if(X.prefs.toggles & SOUND_ADMINHELP)
			X << 'sound/effects/adminhelp.ogg'
		X << msg

	user << "<font color='blue'><b>Ticket</b> created for <b>Admins</b>: \"[title]\" <b><a href='?src=\ref[user];action=view_admin_ticket;ticket=\ref[src]'>View</a></b></font>"

	var/time = time2text(world.timeofday, "hh:mm")
	log += "[time] - Ticket created by <b>[user]</b>"

	var/admin_number_present = admin_number_total - admin_number_decrease	//Number of admins who are neither afk nor invalid
	log_admin("TICKET: [key_name(src)]: [title] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		if(!admin_number_afk && !admin_number_ignored)
			send2irc(user.ckey, "Ticket - [title] - No admins online")
		else
			send2irc(user.ckey, "Ticket - [title] - All admins AFK ([admin_number_afk]/[admin_number_total]) or skipped ([admin_number_ignored]/[admin_number_total])")

/datum/admin_ticket/Del()
	var/path = "data/logs/tickets/[time2text(world.realtime,"YYYY/MM-Month/DD-Day-hh-mm")].html"
	var/file = file(path)

	for(var/line in log)
		file <<  "<p>[line]</p>"