/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	player_list -= src
	log_access("Logout: [key_name(src)]")
	if(admin_datums[src.ckey])
		message_admins("Admin logout: [key_name(src)]")
		if(!config.allow_vote_restart)
			var/admins_number = 0
			for(var/client/admin in admins)
				if(check_rights_for(admin, R_SERVER))
					admins_number++
			if(admins_number == 0)
				log_admin("No admins left with +SERVER. Restart vote allowed.")
				message_admins("No admins left with +SERVER. Restart vote allowed.")
				config.allow_vote_restart = 1
				/*var/cheesy_message = pick( list(  \
					"I have no admins online!",\
					"I'm all alone :(",\
					"I'm feeling lonely :(",\
					"I'm so lonely :(",\
					"Why does nobody love me? :(",\
					"I want a man :(",\
					"Where has everyone gone?",\
					"I need a hug :(",\
					"Someone come hold me :(",\
					"I need someone on me :(",\
					"What happened? Where has everyone gone?",\
					"Forever alone :("\
				) )

				if(cheesy_message)
					cheesy_message += " (No admins online)"


				send2irc("Server", "[cheesy_message]")*/
	..()

	if(isobj(loc))
		var/obj/Loc=loc
		Loc.on_log()

	return 1