
/var/list/tickets_list = list()
/var/ticket_count = 0;

/datum/ticket_log
	var/text
	var/admin_only = 0

/datum/ticket_log/New(ntext, nadmin = 0)
	text = ntext
	admin_only = nadmin



/datum/admin_ticket
	var/ticket_id
	var/client/owner
	var/owner_ckey
	var/title
	var/list/log = list()
	var/resolved = 0
	var/list/monitors = list()
	var/client/handling_admin = null
	var/client/pm_started_user = null
	var/pm_started_flag = 0
	var/error = 0
	//var/log_file

/datum/admin_ticket/New(nowner, ntitle, ntarget)
	if(compare_ckey(nowner, ntarget))
		usr << "<span class='ticket-status'>You cannot make a ticket for yourself</span>"
		error = 1
		return

	owner = get_client(nowner)
	owner_ckey = get_ckey(owner)

	if(owner.holder && ntarget)
		handling_admin = get_client(owner)
		owner = get_client(ntarget)
		owner_ckey = get_ckey(ntarget)

	for(var/datum/admin_ticket/T in tickets_list)
		if(!T.resolved && (compare_ckey(owner_ckey, T.owner_ckey)/* || compare_ckey(handling_admin, T.handling_admin)*/))
			error = 1
			usr << "<span class='ticket-status'>Ticket not created. This user already has a ticket. You can view it here: [T.get_view_link(usr)]</span>"
			// Code removed. This would usually enable adding comments to tickets.
			//   we instead want a new ticket to be created.
			/*if(alert(usr, "This user already has a ticket. Would you like to add to it as a supplimentary comment?", "Supplimentary comment", "Add comment", "Cancel") == "Add comment")
				T.add_log(ntitle)*/
			return

	if(ntitle)
		title = format_text(ntitle)
	ticket_count++
	ticket_id = ticket_count

	//var/path = "data/logs/tickets/[time2text(world.realtime,"YYYY/MM-Month/DD-Day/[owner ? owner.ckey : owner]-[ticket_id]")].html"
	//log_file = file(path)

	var/admin_title = generate_admin_info(title)
	//var/time = time2text(world.timeofday, "hh:mm")
	log += new /datum/ticket_log("<b>[title]</b>", 0)

	// var/ai_found = isAI(owner.ckey)
	// var/msg = "<span class='ticket-text-received'><font color=red>New ticket created: </font>[key_name(owner, 1)] (<a href='?_src_=holder;adminmoreinfo=\ref[owner.mob]'>?</a>) (<a href='?_src_=holder;adminplayeropts=\ref[owner.mob]'>PP</a>) (<a href='?_src_=vars;Vars=\ref[owner.mob]'>VV</a>) (<a href='?_src_=holder;subtlemessage=\ref[owner.mob]'>SM</a>) (<a href='?_src_=holder;adminplayerobservejump=\ref[owner.mob]'>JMP</a>) (<a href='?_src_=holder;secretsadmin=check_antagonist'>CA</a>) [ai_found ? " (<a href='?_src_=holder;adminchecklaws=\ref[owner.mob]'>CL</a>)" : ""]:</b> [title] <a href='?src=\ref[owner];action=view_admin_ticket;ticket=\ref[src]'>View</a> <a href='?src=\ref[owner];action=monitor_admin_ticket;ticket=\ref[src]'>(Un)Monitor</a> <a href='?src=\ref[owner];action=resolve_admin_ticket;ticket=\ref[src]'>(Un)Resolve</a></span>"
	var/msg = "<span class='ticket-text-received'><b>[get_view_link(usr)] created: [key_name_params(owner, 1, 1, "new=1", src)]: [admin_title]</span>"


	var/tellAdmins = 1
	if(compare_ckey(owner, ntarget))
		tellAdmins = 0
		if(!is_admin(owner)) owner << "<span class='ticket-header-recieved'>-- Administrator private message --</span>"
		owner << "<span class='ticket-text-received'>Ticket created by [is_admin(owner) ? key_name_params(handling_admin, 1, 1, null, src) : key_name_params(handling_admin, 1, 0, null, src)] for you: \"[title]\"</span>"
		if(!is_admin(owner)) owner << "<span class='ticket-admin-reply'>Click on the administrator's name to reply.</span>"
		handling_admin << "<span class='ticket-text-sent'>Ticket created by you for [is_admin(handling_admin) ? key_name_params(ntarget, 1, 1, null, src) : key_name_params(ntarget, 1, 0, null, src)]: \"[admin_title]\"</span>"
		// log += "[gameTimestamp()] - Ticket created by <b>[handling_admin] for [ntarget]</b>"
		log += new /datum/ticket_log("[gameTimestamp()] - Ticket created by <b>[handling_admin] for [ntarget]</b>", 0)
		if(has_pref(owner, SOUND_ADMINHELP))
			owner << 'sound/effects/adminhelp.ogg'
		if(has_pref(handling_admin, SOUND_ADMINHELP))
			handling_admin << 'sound/effects/adminhelp.ogg'
	else
		// log += "[gameTimestamp()] - Ticket created by <b>[owner]</b>"
		log += new /datum/ticket_log("[gameTimestamp()] - Ticket created by <b>[owner]</b>", 0)
		owner << "<span class='ticket-status'>Ticket created for Admins: \"[title]\"</span>"
		if(has_pref(owner, SOUND_ADMINHELP))
			owner << 'sound/effects/adminhelp.ogg'

	//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
	if(usr.client.holder && owner && !owner.holder && compare_ckey(usr, handling_admin) && config.popup_admin_pm)
		spawn()	//so we don't hold the caller proc up
			var/sender = usr.client
			var/sendername = usr.client.key
			var/reply = input(owner, title,"Admin PM from-[sendername]", "") as text|null		//show message and await a reply
			if(reply && sender)
				owner.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them

	var/admin_number_total = 0		//Total number of admins
	var/admin_number_afk = 0		//Holds the number of admins who are afk
	var/admin_number_ignored = 0	//Holds the number of admins without +BAN (so admins who are not really admins)
	var/admin_number_decrease = 0	//Holds the number of admins with are afk, ignored or both
	if(tellAdmins)
		//send this msg to all admins
		for(var/client/X in admins)
			if(compare_ckey(owner, X) || compare_ckey(ntarget, X))
				continue
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
			if(has_pref(X, SOUND_ADMINHELP))
				X << 'sound/effects/adminhelp.ogg'
			X << msg

	var/admin_number_present = admin_number_total - admin_number_decrease	//Number of admins who are neither afk nor invalid
	log_admin("TICKET #[ticket_id]: [key_name(owner)]: [title] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		if(!admin_number_afk && !admin_number_ignored)
			send2irc(owner.ckey, "Ticket - [title] - No admins online")
		else
			send2irc(owner.ckey, "Ticket - [title] - All admins AFK ([admin_number_afk]/[admin_number_total]) or skipped ([admin_number_ignored]/[admin_number_total])")
