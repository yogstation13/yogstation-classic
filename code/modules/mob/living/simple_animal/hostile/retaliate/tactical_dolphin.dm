/mob/living/simple_animal/hostile/retaliate/dolphin/tactical
	//don't put the name or desc here, leave that in add_harness and remove_harness
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	speed = 0
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/dolphinmeat = 2, /obj/item/weapon/reagent_containers/food/snacks/syndicake = 1)

	ranged_cooldown_cap = 2
	projectilesound = 'sound/weapons/sear.ogg'
	var/obj/item/weapon/storage/dolphin_harness/harness//please please please do not add to or remove from this var, use add_harness() and remove_harness(). I warned you.
	var/obj/item/device/radio/headset/headset

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/New()
	..()
	AIStatus = AI_OFF
	add_harness(new /obj/item/weapon/storage/dolphin_harness(), null)
	access_card = new /obj/item/weapon/card/id/syndicate(src)
	pullin = new /obj/screen/pull/dolphin()
	headset = new /obj/item/device/radio/headset/syndicate(src)

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/Life()
	if(!headset.emped)
		headset.on = 1

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/UnarmedAttack(obj/item/W, mob/user, params)
	if(stat)
		return
	if(harness && (W.loc == harness))
		harness.remove_from_storage(W, loc)
	else if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/syndicake) && Adjacent(W))
		eat_syndiecake(W)
	else if(istype(W, /obj/item/weapon/storage/dolphin_harness))
		if(harness)
			usr << "<span class='warning'>You are already wearing a harness!</span>"
		else
			visible_message("<span class='danger'>\The [src] begins to wriggle into \the [W].</span>", "<span class='warning'>You begin to wriggle into \the [W]. You must stay still.</span>")
			if(do_after(usr, 80, target = W))
				add_harness(W, src)
			return
	else if(harness && harness.emag_active && Adjacent(W))
		W.emag_act(usr)
	else
		..()

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/unEquip(obj/item/W)
	if(istype(W, /obj/item/weapon/storage/dolphin_harness))
		remove_harness(0)
	return ..()

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/syndicake) && !stat)
		eat_syndiecake(W, user)
	else if(istype(W, /obj/item/weapon/storage/dolphin_harness))
		if(harness)
			user << "<span class='warning'>That dolphin is already wearing a harness!</span>"
		else
			src << "<span class='warning'>[user] attempts to put \the [W] on you!</span>"
			user.visible_message("<span class='warning'>[user] starts putting \the [W] on \the [src].</span>", "<span class='notice'>You start putting \the [W] on the dolphin.</span>")
			if(do_after(user, 40, target = src))
				add_harness(W, user)
			return
	else
		..()

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/put_in_hands(obj/item/W)//need this so syndicake wrappers stay on the ground. Otherwise, the dolphin tries to put them in its hand, which is unreachable outside of varedit.
	W.loc = loc
	W.layer = initial(W.layer)
	W.dropped(src)
	return 0

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/radio(message, message_mode, list/spans)
	. = ..()
	if(. != 0)
		return .
	if((message_mode in radiochannels) || (message_mode == MODE_HEADSET))
		if(headset)
			headset.talk_into(src, message, message_mode, spans)
			return 0//can't tell if the dolphin is using its radio.

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/show_inv(mob/user)
	if(!harness)
		return
	if(user.stat)
		return
	user.set_machine(src)

	var/dat = {"<div align='center'><b>[name]</b></div><p><br>
	<a href='?src=\ref[src];action=remove_harness'>Remove Harness</a><br>
	<a href='?src=\ref[src];action=open_inventory'>Show Inventory</a><br>
	<a href='?src=\ref[src];action=add_inventory'>Add to Inventory</a>
	"}

	user << browse(dat, text("window=mob[];size=325x500", real_name))
	onclose(user, "mob[real_name]")
	return

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/Topic(href, href_list)
	if(!usr.canUseTopic(src, 1, 0))
		return
	switch(href_list["action"])
		if("remove_harness")
			attempt_remove_harness(usr)
		if("open_inventory")
			if(harness)
				if(harness.allowed(usr) || (stat & DEAD))
					harness.open_inventory(usr)
				else
					usr << "<span class='warning'>Access Denied</span>"
		if("add_inventory")
			if(harness)
				harness.attackby(usr.get_active_hand(), usr)

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/proc/add_harness(var/obj/item/weapon/storage/dolphin_harness/H, var/mob/user = usr)
	if(!H || harness || !istype(H))
		return 0
	harness	= H
	icon_state = (stat & DEAD) ? "tactical_dolphin_dead" : "tactical_dolphin"
	icon_living = "tactical_dolphin"
	icon_dead = "tactical_dolphin_dead"
	name = "tactical dolphin"
	desc = "A highly trained space dolphin used by the syndicate to provide light fire support and space superiority for elite commando teams."
	if(user && user != src)
		user.unEquip(H)
	H.loc = src
	ranged = !harness.weapon_safety
	projectiletype = harness.selected_weapon

	harness.set_night_vision(harness.night_vision_on)

	if(hud_used)
		hud_used.instantiate()
	return 1

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/proc/remove_harness(var/unequip = 1)
	icon_state = (stat & DEAD) ? "dolphin_dead" : "dolphin"
	icon_living = "dolphin"
	icon_dead = "dolphin_dead"
	name = initial(name)//same name and desc as a regular dolphin, for stealthdolphinops.
	desc = initial(desc)
	ranged = 0

	harness.set_night_vision(0)

	if(hud_used)
		hud_used.instantiate()

	if(!harness)
		return 0

	if(unequip)
		unEquip(harness)
	harness = null
	return 1

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/proc/attempt_remove_harness(mob/user)
	if(!harness)
		return
	user.visible_message("<span class='danger'>[user] attempts to remove \the [harness] from \the [src]!</span>", "<span class='warning'>You attempt to remove \the [harness] from \the [src].</span>")
	if(do_after(usr, 60, target = src))
		if(remove_harness())
			user.visible_message("<span class='danger'>[user] removes \the [harness] from \the [src]!</span>", "<span class='warning'>You remove \the [harness] from \the [src].</span>")
			return
	user.visible_message("<span class='danger'>[user] fails to remove \the [harness] from \the [src]!</span>", "<span class='warning'>You fail to remove \the [harness] from \the [src].</span>")


/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/proc/eat_syndiecake(var/obj/item/weapon/reagent_containers/food/snacks/syndicake/cake, var/mob/user = usr)
	if(health >= maxHealth)
		if(user == src)
			user << "<span class='warning'>You do not need to eat \the [cake] right now.</span>"
		else
			user << "<span class='warning'>\The [src] refuses to eat \the [cake]!</span>"
	else
		if(user == src)
			user.visible_message("<span class='warning'>You eat \the [cake].</span>", "<span class='warning'>You eat \the [cake].</span>")
		else
			user.visible_message("<span class='warning'>[usr] feeds \the [cake] to the [src].</span>", "<span class='warning'>You feed \the [cake] to \the [src]!</span>")
		//eat dat cake
		playsound(loc, 'sound/items/eatfood.ogg', rand(10,50), 1)
		if(cake.reagents.total_volume)//sadly copypasta.
			var/fraction = min(cake.bitesize/cake.reagents.total_volume, 1)
			cake.reagents.reaction(src, INGEST, fraction)
			cake.reagents.trans_to(src, cake.bitesize)
			cake.bitecount++
			cake.On_Consume()

		adjustBruteLoss(-5)
		updatehealth()

///////HARNESS//////

/obj/item/weapon/storage/dolphin_harness
	name = "tactical dolphin harness"
	desc = "A harness for a Syndicate Tactical Dolphin."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "armoralt"//this needs a real sprite.
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 21
	storage_slots = 21
	cant_hold = list(/obj/item/weapon/storage/dolphin_harness) //muh recursive backpacks.
	req_access = list(access_syndicate)
	var/emag_active = 0
	var/weapon_safety = 1
	var/night_vision_on = 0
	var/obj/item/projectile/selected_weapon
	var/list/obj/item/projectile/ranged_attacks = list(/obj/item/projectile/beam = "laser")//, /obj/item/projectile/beam/scatter = "scattershot")//gotta figure out how to do multiple shots at once for this.
	var/obj/screen/tac_dolphin/toggle_weapon/toggle_weapon_button
	var/obj/screen/tac_dolphin/toggle_safety/toggle_safety_button
	var/obj/screen/tac_dolphin/toggle_emag/toggle_emag_button
	var/obj/screen/tac_dolphin/open_inv/open_inv_button
	var/obj/screen/tac_dolphin/toggle_nightvision/toggle_nightvision_button

/obj/item/weapon/storage/dolphin_harness/New()
	toggle_weapon_button = new /obj/screen/tac_dolphin/toggle_weapon()
	toggle_safety_button = new /obj/screen/tac_dolphin/toggle_safety()
	toggle_emag_button = new /obj/screen/tac_dolphin/toggle_emag()
	open_inv_button = new /obj/screen/tac_dolphin/open_inv()
	toggle_nightvision_button = new /obj/screen/tac_dolphin/toggle_nightvision()
	if(ranged_attacks.len)
		selected_weapon = ranged_attacks[1]
	for(var/i=0,i<5;i++)
		new /obj/item/weapon/reagent_containers/food/snacks/syndicake(src)
	..()

/obj/item/weapon/storage/dolphin_harness/allowed(mob/M)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(check_access(H.get_active_hand()) || (istype(H) && check_access(H.wear_id)) )
			return 1
	return 0

/obj/item/weapon/storage/dolphin_harness/proc/toggle_night_vision()
	set_night_vision(!night_vision_on)

/obj/item/weapon/storage/dolphin_harness/proc/set_night_vision(var/on)
	night_vision_on = on
	toggle_nightvision_button.update_button_icon(src)
	if(istacdolphin(loc))
		var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = loc
		if(night_vision_on)
			dolphin.see_in_dark = 8
			dolphin.see_invisible = SEE_INVISIBLE_MINIMUM
		else
			dolphin.see_in_dark = initial(dolphin.see_in_dark)
			dolphin.see_invisible = initial(dolphin.see_invisible)

/obj/item/weapon/storage/dolphin_harness/proc/toggle_safety()
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = usr
	weapon_safety = !weapon_safety
	toggle_safety_button.update_button_icon(src)
	if(weapon_safety)
		if(istype(dolphin))
			dolphin.ranged = 0
	else
		if(istype(dolphin))
			dolphin.ranged = 1
			dolphin.projectiletype = selected_weapon

/obj/item/weapon/storage/dolphin_harness/proc/cycle_weapon()
	if(ranged_attacks.len == 0)
		selected_weapon = null
	else
		var/index = ranged_attacks.Find(selected_weapon)
		if(!index)
			selected_weapon = ranged_attacks[1]
		else
			selected_weapon = ranged_attacks[((index) % ranged_attacks.len) + 1]
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = usr
	if(istype(dolphin))
		dolphin.projectiletype = selected_weapon

/obj/item/weapon/storage/dolphin_harness/proc/toggle_emag()
	emag_active = !emag_active
	toggle_emag_button.update_button_icon(src)
	if(emag_active)
		toggle_emag_button.icon_state = toggle_emag_button.on_icon
	else
		toggle_emag_button.icon_state = toggle_emag_button.off_icon

/obj/item/weapon/storage/dolphin_harness/proc/open_inventory(mob/user)
	if(!istacdolphin(user) && istacdolphin(loc) )
		user << "<span class='notice'>You view \the [src]'s storage pouch. You can add items, but only \the [loc] can remove them while \the [src] is being worn.</span>"
	orient2hud(user)
	if(user.s_active)
		user.s_active.close(user)
	show_to(user)

/*
//This code is for making the dolphin's harness un-openable except by people with syndie access. Leaving it here just in case.
/obj/item/weapon/storage/dolphin_harness/content_can_dump(atom/dest_object, mob/user)//don't want to accidentaly dump all your weapons on the ground.
	return 0

/obj/item/weapon/storage/dolphin_harness/storage_contents_dump_act(obj/item/weapon/storage/src_object, mob/user)
	return 0

/obj/item/weapon/storage/dolphin_harness/MouseDrop(over_object) //attackby
	if(over_object != usr)
		return
	if(!allowed(usr))
		usr << "<span class='warning'>Access Denied</span>"
		return 0
	return ..()

/obj/item/weapon/storage/dolphin_harness/attack_hand(mob/usr)
	if(!allowed(usr))
		usr << "<span class='warning'>Access Denied</span>"
		return 0
	return ..()

/obj/item/weapon/storage/dolphin_harness/can_be_inserted(obj/item/W, stop_messages = 0)
	if(!allowed(usr))
		return 0
	return ..()

/obj/item/weapon/storage/dolphin_harness/remove_from_storage(obj/item/W, atom/new_location)
	if(!allowed(usr))
		return 0
	return ..()
*/

///////HUD////////
//All of these Icons need real sprites.
/obj/screen/tac_dolphin/
	icon = 'icons/mob/screen_dolphin.dmi'

/obj/screen/tac_dolphin/proc/update_button_icon(var/obj/item/weapon/storage/dolphin_harness/harness)
	return

/obj/screen/tac_dolphin/toggle_weapon
	icon_state = "swap_weapon_button"
	name = "Toggle Weapon"
	desc = "Toggle your dorsal-mounted weapon's fire mode."
	screen_loc = "SOUTH:6,CENTER:16"

/obj/screen/tac_dolphin/toggle_weapon/Click()
	if(!istacdolphin(usr))
		return
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = usr
	dolphin.harness.cycle_weapon()
	if(dolphin.harness.selected_weapon)
		usr << "<span class='notice'>You toggle your dorsal weapon to fire [dolphin.harness.ranged_attacks[dolphin.harness.selected_weapon]] rounds.</span>"
	else
		usr << "<span class='notice'>Your dorsal weapon does not have any modules loaded.</span>"

/obj/screen/tac_dolphin/toggle_safety
	name = "Toggle Safety"
	desc = "Toggle the safety on your dorsal-mounted weapon"
	screen_loc = "SOUTH:6,CENTER-1:16"

/obj/screen/tac_dolphin/toggle_safety/update_button_icon(var/obj/item/weapon/storage/dolphin_harness/harness)
	if(harness)
		icon_state = harness.weapon_safety ? "safety_on" : "safety_off"

/obj/screen/tac_dolphin/toggle_safety/Click()
	if(!istacdolphin(usr))
		return
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = usr
	dolphin.harness.toggle_safety()
	usr << "<span class='notice'>You [dolphin.harness.weapon_safety ? "enable" : "disable"] the safety on your dorsal weapon.</span>"

/obj/screen/tac_dolphin/toggle_emag
	var/on_icon = "emag_button_on"
	var/off_icon = "emag_button_off"
	name = "Toggle Emag"
	desc = "Toggle your build-in cryptographic sequencer"
	screen_loc = "SOUTH:6,CENTER:16"

/obj/screen/tac_dolphin/toggle_emag/update_button_icon(var/obj/item/weapon/storage/dolphin_harness/harness)
	if(harness)
		icon_state = harness.emag_active ? "emag_button_on" : "emag_button_off"

/obj/screen/tac_dolphin/toggle_emag/Click()
	if(!istacdolphin(usr))
		return
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = usr
	dolphin.harness.toggle_emag()
	usr << "<span class='notice'>You [dolphin.harness.emag_active ? "enable" : "disable"] your harness's built-in emag.</span>"

/obj/screen/pull/dolphin
	icon = 'icons/mob/screen_dolphin.dmi'
	screen_loc = "SOUTH:6,CENTER+2:16"

/obj/screen/tac_dolphin/open_inv
	icon_state = "inv"
	name = "Open Inventory"
	desc = "Open your harness's inventory"
	screen_loc = "SOUTH:6,CENTER+1:16"

/obj/screen/tac_dolphin/open_inv/Click()
	if(!istacdolphin(usr))
		return
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = usr
	if(dolphin.harness)
		dolphin.harness.open_inventory(usr)

/obj/screen/tac_dolphin/toggle_nightvision
	name = "Toggle Night-Vision"
	desc = "Toggle your harness's night-vision filter."
	screen_loc = "SOUTH:6,CENTER-2:16"

/obj/screen/tac_dolphin/toggle_nightvision/update_button_icon(var/obj/item/weapon/storage/dolphin_harness/harness)
	if(harness)
		icon_state = harness.night_vision_on ? "nightvision_on" : "nightvision_off"

/obj/screen/tac_dolphin/toggle_nightvision/Click()
	if(!istacdolphin(usr))
		return
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = usr
	if(dolphin.harness)
		dolphin.harness.toggle_night_vision()

/datum/hud/proc/tactical_dolpin_hud()
	var/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/dolphin = mymob
	if(!dolphin || !dolphin.harness)
		return

	var/list/hud_elements = list()

	//hud_elements += dolphin.harness.toggle_weapon_button//only one weapon at the moment, so no need for this. Also the icon is terrible.
	hud_elements += dolphin.harness.toggle_safety_button
	hud_elements += dolphin.harness.toggle_emag_button
	hud_elements += dolphin.harness.open_inv_button
	hud_elements += dolphin.harness.toggle_nightvision_button

	hud_elements += mymob.pullin
	mymob.pullin.update_icon(mymob)

	for(var/obj/screen/tac_dolphin/dolphin_hud_element in hud_elements)
		dolphin_hud_element.update_button_icon(dolphin.harness)

	mymob.client.screen = list()
	mymob.client.screen += mymob.client.void
	mymob.client.screen += hud_elements