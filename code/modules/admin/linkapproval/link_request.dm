
/client/verb/admin_link_approval(hyperlink as text)
	set category = "Admin"
	set name = "Approve Link"

	// 30 second cool-down for link posting
	src.verbs -= /client/verb/admin_link_approval
	spawn(300)
		src.verbs += /client/verb/admin_link_approval

	for(var/client/X in admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			X << 'sound/effects/adminhelp.ogg'
		X << "<span class='boldnotice'>[src] would like to <a href='?poster=\ref[src];admin=\ref[X];link=[url_encode(hyperlink)];action=admin_link_approval;approved=1'>approve</a> | <a href='?poster=\ref[src];admin=\ref[X];link=[url_encode(hyperlink)];action=admin_link_approval;approved=0'>deny</a> this link: [hyperlink]</span>"

/client/Topic(href, href_list[])
	..()

	if(href_list["action"] == "admin_link_approval")
		var/client/poster = locate(href_list["poster"])
		var/client/admin = locate(href_list["admin"])
		var/link = url_decode(href_list["link"])
		var/approved = href_list["approved"]

		if(approved == "1")
			admin.ooc("Approved link from [poster]: [link]")
		else
			var/why = input("Reason (or leave empty):")

			poster << "<span class='boldnotice'>Your link was denied.[why ? " Reason: [why]." : ""]</span>"

			for(var/client/X in admins)
				X << "<span class='boldnotice'>[admin] denied [poster]'s link: [link].[why ? " Reason: [why]." : ""]</span>"
