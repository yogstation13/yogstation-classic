/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(0))	return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("[key_name(src)] : [msg]")
	spawn(-1) send_discord_message("**[key_name(usr)]** said: [msg]", DISCORD_ASAY)
	msg = keywords_lookup(msg)

	var/regex/R = new("\[^&\]#(\\d+)", "ig")
	msg = R.Replace(msg, "<a href='?src=\ref[src];view_admin_ticket=$1'>Ticket #$1</a>")

	if(check_rights(R_ADMIN,0))
		msg = "<span class='adminobserver'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=holder;adminplayerobservefollow=\ref[mob]'>FLW</A>): <span class='message'>[msg]</span></span>"
		admins << msg
	else
		msg = "<span class='adminobserver'><span class='prefix'>OBSERVER:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=holder;adminplayerobservefollow=\ref[mob]'>FLW</A>): <span class='message'>[msg]</span></span>"
		admins << msg

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique , ensure the 2nd parameter is unique to the new proc!
