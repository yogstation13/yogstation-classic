/mob/dead/observer/Login()
	..()
	if(client.prefs.unlock_content)
		var/form = client.prefs.ghost_form
		if (form=="Corpse")
			if(mind && mind.current)
				icon = mind.current.icon
				icon_state = mind.current.icon_state;
				overlays.Cut()
				overlays += mind.current.overlays
				alpha = 127
		else
			icon = initial(icon)
			icon_state = client.prefs.ghost_form
			alpha = 255
		if (ghostimage)
			ghostimage.icon_state = src.icon_state
			//ghost_orbit = client.prefs.ghost_orbit
			ghostimage.overlays = overlays
			ghostimage.alpha = alpha
	if(client.holder)
		verbs += /mob/dead/observer/proc/toggleninjahud
	updateghostimages()


	update_interface()