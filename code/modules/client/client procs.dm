	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		1048576	//Restricts client uploads to the server to 1MB //Could probably do with being lower.
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)

	if("WMIQuery" in href_list)

		var/list/class = WMIData[href_list["class"]]
		var/instance_index = text2num(href_list["index"])
		while(class.len < instance_index)
			class.Add(0)
			class[class.len] = list()

		var/list/instance = class[instance_index]
		instance += list(href_list["field"] = href_list["value"])

	if("CloseWMIQuery" in href_list)
		src << browse(null,"window=WMIQuery[href_list["CloseWMIQuery"]]")


	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	//Admin PM
	if(href_list["priv_msg"])
		if(href_list["ticket"])
			var/datum/admin_ticket/T = locate(href_list["ticket"])

			if(holder && T.resolved)
				var/found_ticket = 0
				for(var/datum/admin_ticket/T2 in tickets_list)
					if(!T.resolved && compare_ckey(T.owner_ckey, T2.owner_ckey))
						found_ticket = 1

				if(!found_ticket)
					if(alert(usr, "No open ticket exists, would you like to make a new one?", "Tickets", "New ticket", "Cancel") == "Cancel")
						return
			else if(!holder && T.resolved)
				usr << "<span class='boldnotice'>Your ticket was closed. Only admins can add finishing comments to it.</span>"
				return

			if(get_ckey(usr) == get_ckey(T.owner))
				T.owner.cmd_admin_pm(get_ckey(T.handling_admin),null)
			else if(get_ckey(usr) == get_ckey(T.handling_admin))
				T.handling_admin.cmd_admin_pm(get_ckey(T.owner),null)
			else
				cmd_admin_pm(get_ckey(T.owner),null)
			return

		if(href_list["new"])
			var/datum/admin_ticket/T = locate(href_list["ticket"])
			if(T.handling_admin && !compare_ckey(T.handling_admin, usr))
				usr << "Using this PM-link for this ticket would usually be the first response to a ticket. However, an admin has already responded to this ticket. This link is now disabled, to ensure that no additional tickets are created for the same problem. You can create a new ticket by PMing the user any other way."
				return
			else
				T.pm_started_user = get_client(usr)
		if (href_list["ahelp_reply"])
			cmd_ahelp_reply(href_list["priv_msg"])
			return
		cmd_admin_pm(href_list["priv_msg"],null)

		return

	if(href_list["view_admin_ticket"])
		var/id = text2num(href_list["view_admin_ticket"])
		var/client/C = usr.client
		if(!C.holder)
			message_admins("EXPLOIT \[admin_ticket\]: [usr] attempted to operate ticket [id].")
			return

		for(var/datum/admin_ticket/T in tickets_list)
			if(T.ticket_id == id)
				T.view_log()
				return

		usr << "The ticket ID #[id] doesn't exist."

		return

	if(href_list["toggle_be_special"])
		var/role_flag = href_list["toggle_be_special"]
		var/client/C = locate(href_list["_src_"])

		if(!C.prefs.hasSpecialRole(role_flag))
			C.prefs.be_special[role_flag] = spec_roles[role_flag]
		else
			C.prefs.be_special -= role_flag

		C.prefs.save_preferences()

		var/item = spec_roles[role_flag]
		src << "You will [(C.prefs.hasSpecialRole(role_flag)) ? "now" : "no longer"] be considered for [item["name"]] events [(C.prefs.hasSpecialRole(role_flag)) ? "(where possible)" : ""]"
		feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		toggle_be_special()

		return

	if(prefs.afreeze && !holder)
		src << "<span class='userdanger'>You are frozen by an administrator.</span>"
		return

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)

	..()	//redirect to hsrc.Topic()

/client/proc/is_content_unlocked()
	if(!prefs.unlock_content)
		src << "Become a BYOND member to access member-perks and features, as well as support the engine that makes this game possible. <a href='http://www.byond.com/membership'>Click Here to find out more</a>."
		return 0
	return 1

/client/proc/handle_spam_prevention(message, mute_type)
	if(config.automute_on && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			src << "<span class='danger'>You have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>"
			cmd_admin_mute(src, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			src << "<span class='danger'>You are nearing the spam filter limit for identical messages.</span>"
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		src << "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>"
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
#if (PRELOAD_RSC == 0)
var/list/external_rsc_urls
var/next_external_rsc = 0
#endif


/client/New(TopicData)

	TopicData = null							//Prevent calls to client.Topic from connect

	if(connection != "seeker")					//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

	spawn(30)
		antag_token_reload_from_db(src)
		credits_reload_from_db(src)

		for(var/datum/admin_ticket/T in tickets_list)
			if(compare_ckey(T.owner_ckey, src) && !T.resolved)
				T.owner = src
				T.add_log(new /datum/ticket_log(T, src, "¤ Connected ¤", 1), src)
				break
			if(compare_ckey(T.handling_admin, src) && !T.resolved)
				T.handling_admin = src
				T.add_log(new /datum/ticket_log(T, src, "¤ Connected ¤", 1), src)
				break

#if (PRELOAD_RSC == 0)
	if(external_rsc_urls && external_rsc_urls.len)
		next_external_rsc = Wrap(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	clients += src
	directory[ckey] = src

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	//Need to load before we load preferences for correctly removing Ultra if user no longer whitelisted
	is_whitelisted = is_job_whitelisted(src)

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	if(ckey in donators)
		prefs.unlock_content |= 2
		add_donor_verbs()
	else
		prefs.unlock_content &= ~2
		if(prefs.toggles & QUIET_ROUND)
			prefs.toggles &= ~QUIET_ROUND
			prefs.save_preferences()

	add_verbs_from_config()
	set_client_age_from_db()

	if (isnum(player_age) && player_age == -1) //first connection
		if (config.panic_bunker && !holder && !(ckey in deadmins))
			log_access("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			src << "Sorry but the server is currently not accepting connections from never before seen players."
			qdel(src)
			return 0

		if (config.notify_new_player_age >= 0)
			message_admins("New user: [key_name_admin(src)] is connecting here for the first time.")
			if (config.irc_first_connection_alert)
				send2irc_adminless_only("New-user", "[key_name(src)] is connecting for the first time!")

		player_age = 0 // set it from -1 to 0 so the job selection code doesn't have a panic attack

	else if (isnum(player_age) && player_age < config.notify_new_player_age)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [player_age] day[(player_age==1?"":"s")]")


	if (!ticker || ticker.current_state == GAME_STATE_PREGAME)
		spawn (rand(10,150))
			if (src)
				sync_client_with_db()
	else
		sync_client_with_db()


	. = ..()	//calls mob.Login()

	if( (world.address == address || !address) && !host )
		host = key
		world.update_status()

	if(holder)
		message_admins("Admin login: [key_name(src)]")
		if(config.allow_vote_restart && check_rights_for(src, R_ADMIN))
			log_admin("Staff joined with +ADMIN. Restart vote disallowed.")
			message_admins("Staff joined with +ADMIN. Restart vote disallowed.")
			config.allow_vote_restart = 0
		add_admin_verbs()
		add_donor_verbs()
		admin_memo_output("Show")
		if((global.comms_key == "default_pwd" || length(global.comms_key) <= 6) && global.comms_allowed) //It's the default value or less than 6 characters long, but it somehow didn't disable comms.
			src << "<span class='danger'>The server's API key is either too short or is the default value! Consider changing it immediately!</span>"
		verbs += /client/verb/weightstats

	send_resources()

	if(!void)
		void = new()

	screen += void

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		src << "<span class='info'>You have unread updates in the changelog.</span>"
		if(config.aggressive_changelog)
			src.changes()
		else
			winset(src, "rpane.changelogb", "background-color=#eaeaea;font-style=bold")

	if(holder || !config.admin_who_blocked)
		verbs += /client/proc/adminwho

	if (config && config.autoconvert_notes)
		convert_notes_sql(ckey)

	world.manage_fps()

	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	for(var/datum/admin_ticket/T in tickets_list)
		if(compare_ckey(T.owner_ckey, usr) && !T.resolved)
			T.add_log(new /datum/ticket_log(T, src, "¤ Disconnected ¤", 1))

	if(holder)
		ticker.next_check_admin = 1
		holder.owner = null
		admins -= src
	sync_logout_with_db(connection_number)
	directory -= ckey
	clients -= src

	world.manage_fps()

	return ..()


/client/proc/set_client_age_from_db()
	if (IsGuestKey(src.key))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM [format_table_name("player")] WHERE ckey = '[sql_ckey]'")
	if (!query.Execute())
		return

	while (query.NextRow())
		player_age = text2num(query.item[2])
		return

	//no match mark it as a first connection for use in client/New()
	player_age = -1


/client/proc/sync_client_with_db()
	if (IsGuestKey(src.key))
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		return

	var/sql_ckey = sanitizeSQL(src.ckey)

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE ip = '[address]' AND ckey != '[sql_ckey]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE computerid = '[computer_id]' AND ckey != '[sql_ckey]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while (query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "

	var/DBQuery/query_watch = dbcon.NewQuery("SELECT ckey, reason FROM [format_table_name("watch")] WHERE (ckey = '[sql_ckey]')")
	query_watch.Execute()
	if(query_watch.NextRow())
		message_admins("<font color='red'><B>Notice: </B></font><font color='blue'>[key_name_admin(src)] is flagged for watching and has just connected - Reason: [query_watch.item[2]]</font>")
		send2irc_adminless_only("Watchlist", "[key_name(src)] is flagged for watching and has just connected - Reason: [query_watch.item[2]]")

	var/admin_rank = "Player"
	if (src.holder && src.holder.rank)
		admin_rank = src.holder.rank.name

	var/sql_ip = sanitizeSQL(src.address)
	var/sql_computerid = sanitizeSQL(src.computer_id)
	var/sql_admin_rank = sanitizeSQL(admin_rank)


	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO [format_table_name("player")] (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]') ON DUPLICATE KEY UPDATE lastseen = VALUES(lastseen), ip = VALUES(ip), computerid = VALUES(computerid), lastadminrank = VALUES(lastadminrank)")
	query_insert.Execute()

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]');")
	query_accesslog.Execute()
	var/DBQuery/query_getid = dbcon.NewQuery("SELECT `id` FROM `[format_table_name("connection_log")]` WHERE `serverip`='[serverip]' AND `ckey`='[sql_ckey]' AND `ip`='[sql_ip]' AND `computerid`='[sql_computerid]' ORDER BY datetime DESC LIMIT 1;")
	query_getid.Execute()
	while (query_getid.NextRow())
		connection_number = text2num(query_getid.item[1])

proc/sync_logout_with_db(number)
	if(!number || !isnum(number))
		return
	establish_db_connection()
	if (!dbcon.IsConnected())
		return
	var/DBQuery/query_logout = dbcon.NewQuery("UPDATE `[format_table_name("connection_log")]` SET `left`=Now() WHERE `id`=[number];")
	query_logout.Execute()

/client/proc/add_verbs_from_config()
	if(config.see_own_notes)
		verbs += /client/proc/self_notes

#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()

	spawn
		// Preload the HTML interface. This needs to be done due to BYOND bug http://www.byond.com/forum/?post=1487244
		var/datum/html_interface/hi
		for (var/type in typesof(/datum/html_interface))
			hi = new type(null)
			hi.sendResources(src)

	// Preload the crew monitor. This needs to be done due to BYOND bug http://www.byond.com/forum/?post=1487244
	spawn
		if (crewmonitor && crewmonitor.initialized)
			crewmonitor.sendResources(src)

	//Send nanoui files to client
	SSnano.send_resources(src)
	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/browser/common.css',
		'html/browser/scannernew.css',
		'html/browser/playeroptions.css',
		'icons/pda_icons/pda_atmos.png',
		'icons/pda_icons/pda_back.png',
		'icons/pda_icons/pda_bell.png',
		'icons/pda_icons/pda_blank.png',
		'icons/pda_icons/pda_boom.png',
		'icons/pda_icons/pda_bucket.png',
		'icons/pda_icons/pda_chatroom.png',
		'icons/pda_icons/pda_medbot.png',
		'icons/pda_icons/pda_floorbot.png',
		'icons/pda_icons/pda_cleanbot.png',
		'icons/pda_icons/pda_crate.png',
		'icons/pda_icons/pda_cuffs.png',
		'icons/pda_icons/pda_eject.png',
		'icons/pda_icons/pda_exit.png',
		'icons/pda_icons/pda_flashlight.png',
		'icons/pda_icons/pda_honk.png',
		'icons/pda_icons/pda_mail.png',
		'icons/pda_icons/pda_medical.png',
		'icons/pda_icons/pda_menu.png',
		'icons/pda_icons/pda_mule.png',
		'icons/pda_icons/pda_notes.png',
		'icons/pda_icons/pda_power.png',
		'icons/pda_icons/pda_rdoor.png',
		'icons/pda_icons/pda_reagent.png',
		'icons/pda_icons/pda_refresh.png',
		'icons/pda_icons/pda_scanner.png',
		'icons/pda_icons/pda_signaler.png',
		'icons/pda_icons/pda_status.png',
		'icons/pda_icons/pda_botany.png',
		'icons/spideros_icons/sos_1.png',
		'icons/spideros_icons/sos_2.png',
		'icons/spideros_icons/sos_3.png',
		'icons/spideros_icons/sos_4.png',
		'icons/spideros_icons/sos_5.png',
		'icons/spideros_icons/sos_6.png',
		'icons/spideros_icons/sos_7.png',
		'icons/spideros_icons/sos_8.png',
		'icons/spideros_icons/sos_9.png',
		'icons/spideros_icons/sos_10.png',
		'icons/spideros_icons/sos_11.png',
		'icons/spideros_icons/sos_12.png',
		'icons/spideros_icons/sos_13.png',
		'icons/spideros_icons/sos_14.png',
		'icons/stamp_icons/large_stamp-clown.png',
		'icons/stamp_icons/large_stamp-deny.png',
		'icons/stamp_icons/large_stamp-ok.png',
		'icons/stamp_icons/large_stamp-hop.png',
		'icons/stamp_icons/large_stamp-cmo.png',
		'icons/stamp_icons/large_stamp-ce.png',
		'icons/stamp_icons/large_stamp-hos.png',
		'icons/stamp_icons/large_stamp-rd.png',
		'icons/stamp_icons/large_stamp-cap.png',
		'icons/stamp_icons/large_stamp-qm.png',
		'icons/stamp_icons/large_stamp-law.png'
		)

/client/proc/GetWMI(class, fields[])
	class = lowertext(class)
	if(!(class in WMIData))
		WMIData[class] = list()

	var/field_names = ""
	var/array_declaration = "var wmi_fields = \["
	for(var/i = 1 to fields.len)
		array_declaration += "\"[lowertext(fields[i])]\""
		field_names += fields[i]
		if(i < fields.len)
			array_declaration += ","
			field_names += ", "

	array_declaration += "];"

	var/html = {"
<script>
var SWbem = new ActiveXObject("WbemScripting.SWbemLocator");
var WMI = SWbem.ConnectServer(".");
var data = WMI.ExecQuery("SELECT [field_names] FROM [class]");
[array_declaration]

var values = new Array();
var index = 0;
var e = new Enumerator(data);
for(;!e.atEnd();e.moveNext())
{
	var p = e.item();
	values\[index] =  new Array();
	for(var i = 0; i < wmi_fields.length; i++)
	{
		location = "?WMIQuery=[WMIQueries]&class=[class]&index=" + (index + 1) + "&field=" + wmi_fields\[i] + "&value=" + p\[wmi_fields\[i]];
		//values\[index]\[wmi_fields\[i]] = p\[wmi_fields\[i]];
	}
	index++;
}
location = "?CloseWMIQuery=[WMIQueries]";
</script>"}

	src << browse(html,"window=WMIQuery[WMIQueries];size=0x0;titlebar=0;can_resize=0")
	WMIQueries++

/client/proc/WinDateCheck()
	var/list/fields = list("InstallDate")
	GetWMI("Win32_OperatingSystem", fields)

/client/proc/VMCheck()
	var/list/fields = list("Manufacturer", "Model")
	GetWMI("Win32_ComputerSystem", fields)
