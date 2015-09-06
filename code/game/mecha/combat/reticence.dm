/obj/mecha/combat/reticence
	desc = "A silent, fast, and nigh-invisible miming exosuit. Popular among mimes and mime assassins."
	name = "\improper reticence"
	icon_state = "reticence"
	step_in = 2
	dir_in = 1 //Facing North.
	health = 100
	deflect_chance = 3
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1)
	max_temperature = 15000
	wreckage = /obj/structure/mecha_wreckage/reticence
	operation_req_access = list(access_theatre)
	add_req_access = 0
	internal_damage_threshold = 25
	max_equip = 2
	step_energy_drain = 3
	color = "#878787"
	var/invis = 0
	var/cloaking = 0
	stepsound = null
	turnsound = null

/obj/mecha/combat/reticence/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/silenced
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/rcd //HAHA IT MAKES WALLS GET IT
	ME.attach(src)
	return

/obj/mecha/combat/reticence/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];invis=1'><span id="invis_command">[invis?"Dis":"En"]able cloak</span></a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/reticence/Topic(href, href_list)
	..()
	if (href_list["invis"])
		if(cloaking)
			return
		cloak(!invis)

/obj/mecha/combat/reticence/proc/cloak(var/on = 0)
	if(on != invis)
		cloaking = 1
		send_byjax(src.occupant,"exosuit.browser","invis_command","Please wait...")
		invis = on
		alpha = invis ? 21 : 255
		sleep(2)
		if(!src)
			return
		alpha = invis ? 255 : 21
		sleep(2)
		if(!src)
			return
		alpha = invis ? 21 : 255
		sleep(2)
		if(!src)
			return
		alpha = invis ? 255 : 21
		sleep(2)
		if(!src)
			return
		alpha = invis ? 21 : 255
		opacity = invis ? 0 : 1
		send_byjax(src.occupant,"exosuit.browser","invis_command","[invis?"Dis":"En"]able cloak")
		src.occupant_message("<font color=\"[invis?"#00f\">En":"#f00\">Dis"]abled cloak.</font>")
		cloaking = 0
	return

/obj/mecha/combat/reticence/eject()
	if(usr != src.occupant)	return
	cloak(0)
	..()
