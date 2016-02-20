/obj/structure
	icon = 'icons/obj/structures.dmi'
	pressure_resistance = 8
	var/datum/queue/adm_action_log = new /datum/queue(20)

/obj/structure/New()
	..()
	if(smooth)
		smooth_icon(src)
		smooth_icon_neighbors(src)
		icon_state = ""
	var/mob/user = usr
	if(ticker.current_state == GAME_STATE_PLAYING)
		src.builtby = "This was created by [user.ckey]/[user.name]."
	else
		src.builtby = "This was loaded by the map, nerd."
		return

/obj/structure/blob_act()
	if(prob(50))
		qdel(src)

/obj/structure/Destroy()
	if(opacity)
		UpdateAffectingLights()
	if(smooth)
		smooth_icon_neighbors(src)
	..()

/obj/structure/mech_melee_attack(obj/mecha/M)
	if(M.damtype == "brute")
		visible_message("<span class='danger'>[M.name] has hit [src].</span>")
		return 1
	return 0