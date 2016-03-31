/datum/hud/proc/unplayer_hud()
	return

/datum/hud/proc/ghost_hud()
	return

/datum/hud/proc/brain_hud(ui_style = 'icons/mob/screen_midnight.dmi')
	mymob.client.screen = list()
	mymob.client.screen += mymob.client.void