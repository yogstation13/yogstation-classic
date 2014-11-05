/client/var/bypass_ooc_approval = null
/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	if(!mob)	return
	if(IsGuestKey(key))
		src << "Guests may not use OOC."
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	if(!(prefs.toggles & CHAT_OOC))
		src << "<span class='danger'>You have OOC muted.</span>"
		return

	if(!(prefs.agree))
		src << "\red Agree to the rules before using OOC."
		return

	if(!holder)
		if(!ooc_allowed)
			src << "<span class='danger'>OOC is globally muted.</span>"
			return
		if(!dooc_allowed && (mob.stat == DEAD))
			usr << "<span class='danger'>OOC for dead mobs has been turned off.</span>"
			return
		if(prefs.muted & MUTE_OOC)
			src << "<span class='danger'>You cannot use OOC (muted).</span>"
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")

	var/keyname = key
	if(prefs.unlock_content && (prefs.toggles & MEMBER_PUBLIC))
		keyname = "<font color='[prefs.ooccolor]'>"
		if(prefs.unlock_content & 1)
			keyname += "<img style='width:9px;height:9px;' class=icon src=\ref['icons/member_content.dmi'] iconstate=blag>"
		if(prefs.unlock_content & 2)
			keyname += "<img style='width:9px;height:9px;' class=icon src=\ref['icons/member_content.dmi'] iconstate=yogdon>"
		keyname += "[key]</font>"

	//var/regex/R = new("/test/i")
	//var/regex/R = new("/^\[a-z\](?:\[-a-z0-9\\+\\.\])*:(?:\\/\\/(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:\])*@)?(?:\\\[(?:(?:(?:\[0-9a-f\]{1,4}:){6}(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4}|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3})|::(?:\[0-9a-f\]{1,4}:){5}(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4}|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3})|(?:\[0-9a-f\]{1,4})?::(?:\[0-9a-f\]{1,4}:){4}(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4}|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3})|(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4})?::(?:\[0-9a-f\]{1,4}:){3}(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4}|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3})|(?:(?:\[0-9a-f\]{1,4}:){0,2}\[0-9a-f\]{1,4})?::(?:\[0-9a-f\]{1,4}:){2}(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4}|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3})|(?:(?:\[0-9a-f\]{1,4}:){0,3}\[0-9a-f\]{1,4})?::\[0-9a-f\]{1,4}:(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4}|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3})|(?:(?:\[0-9a-f\]{1,4}:){0,4}\[0-9a-f\]{1,4})?::(?:\[0-9a-f\]{1,4}:\[0-9a-f\]{1,4}|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3})|(?:(?:\[0-9a-f\]{1,4}:){0,5}\[0-9a-f\]{1,4})?::\[0-9a-f\]{1,4}|(?:(?:\[0-9a-f\]{1,4}:){0,6}\[0-9a-f\]{1,4})?::)|v\[0-9a-f\]+\[-a-z0-9\\._~!\\$&'\\(\\)\\*\\+,;=:\]+)\\\]|(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])(?:\\.(?:\[0-9\]|\[1-9\]\[0-9\]|1\[0-9\]\[0-9\]|2\[0-4\]\[0-9\]|25\[0-5\])){3}|(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=@\])*)(?::\[0-9\]*)?(?:\\/(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\]))*)*|\\/(?:(?:(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\]))+)(?:\\/(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\]))*)*)?|(?:(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\]))+)(?:\\/(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\]))*)*|(?!(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\])))(?:\\?(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\])|\[\\x{E000}-\\x{F8FF}\\x{F0000}-\\x{FFFFD}|\\x{100000}-\\x{10FFFD}\\/\\?\])*)?(?:\\#(?:(?:%\[0-9a-f\]\[0-9a-f\]|\[-a-z0-9\\._~\\x{A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}\\x{10000}-\\x{1FFFD}\\x{20000}-\\x{2FFFD}\\x{30000}-\\x{3FFFD}\\x{40000}-\\x{4FFFD}\\x{50000}-\\x{5FFFD}\\x{60000}-\\x{6FFFD}\\x{70000}-\\x{7FFFD}\\x{80000}-\\x{8FFFD}\\x{90000}-\\x{9FFFD}\\x{A0000}-\\x{AFFFD}\\x{B0000}-\\x{BFFFD}\\x{C0000}-\\x{CFFFD}\\x{D0000}-\\x{DFFFD}\\x{E1000}-\\x{EFFFD}!\\$&'\\(\\)\\*\\+,;=:@\])|\[\\/\\?\])*)?$/i")
	var/regex/R = new("/(((https?):\\/\\/)?\[^\\s/$.?#\].\[^\\s\]*)/iS")

	if(bypass_ooc_approval != usr)
		while(R.FindNext(msg))
			var/hyperlink = copytext(msg,R.match,R.index)
			admin_link_approval(hyperlink)
			msg = "[copytext(msg,1,R.match)]<b>(Link being approved)</b>[copytext(msg,R.index)]"
	else
		bypass_ooc_approval = null

	for(var/client/C in clients)
		if(C.prefs.toggles & CHAT_OOC)
			if(holder)
				if(!holder.fakekey || C.holder)
					if(check_rights_for(src, R_ADMIN))
						C << "<font color=[config.allow_admin_ooccolor ? prefs.ooccolor :"#b82e00" ]><b><span class='prefix'>\[Admin\] OOC:</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></b></font>"
					else
						C << "<span class='adminobserverooc'><span class='prefix'>OOC:</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></span>"
				else
					C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message'>[msg]</span></span></font>"
			else
				C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[keyname]:</EM> <span class='message'>[msg]</span></span></font>"

/proc/toggle_ooc()
	ooc_allowed = !( ooc_allowed )
	if (ooc_allowed)
		world << "<B>The OOC channel has been globally enabled!</B>"
	else
		world << "<B>The OOC channel has been globally disabled!</B>"

/proc/auto_toggle_ooc(var/on)
	if(!config.ooc_during_round && ooc_allowed != on)
		toggle_ooc()

var/global/normal_ooc_colour = "#002eb8"

/client/proc/set_ooc(newColor as color)
	set name = "Set Player OOC Colour"
	set desc = "Set to yellow for eye burning goodness."
	set category = "Fun"
	normal_ooc_colour = newColor

/client/verb/colorooc()
	set name = "OOC Text Color"
	set category = "Preferences"

	if(!holder || check_rights_for(src, R_ADMIN))
		if(!is_content_unlocked())	return

	var/new_ooccolor = input(src, "Please select your OOC colour.", "OOC colour", prefs.ooccolor) as color|null
	if(new_ooccolor)
		prefs.ooccolor = sanitize_ooccolor(new_ooccolor)
		prefs.save_preferences()
	feedback_add_details("admin_verb","OC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

//Checks admin notice
/client/verb/admin_notice()
	set name = "Adminnotice"
	set category = "Admin"
	set desc ="Check the admin notice if it has been set"

	if(admin_notice)
		src << "<span class='boldnotice'>Admin Notice:</span>\n \t [admin_notice]"
	else
		src << "<span class='notice'>There are no admin notices at the moment.</span>"

/client/verb/motd()
	set name = "MOTD"
	set category = "OOC"
	set desc ="Check the Message of the Day"

	if(join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"
	else
		src << "<span class='notice'>The Message of the Day has not been set.</span>"
