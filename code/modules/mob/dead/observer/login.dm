/mob/dead/observer/Login()
	..()
	if(client.prefs.unlock_content)
		icon_state = client.prefs.ghost_form
	if(client.holder)
		verbs += /mob/dead/observer/proc/toggleninjahud