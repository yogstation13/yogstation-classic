/obj/item/weapon/storage/tactical_harness
	name = "tactical harness"
	desc = "A harness for a Syndicate tactical animal."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "armoralt"//this needs a real sprite.
	w_class = 4
	max_w_class = 3
	max_combined_w_class = 21
	storage_slots = 21
	cant_hold = list(/obj/item/weapon/storage/tactical_harness) //muh recursive backpacks.

	var/list/wearable_by = list()//types of animals that can wear it. Their subtypes can also wear it. Should be a /mob/living/simple_animal.
	var/list/wearable_by_exact = list()//types of aninals that can wear it, but their subtypes can't (i.e. carps, but not megacarps or magicarps). Should be a /mob/living/simple_animal.
	var/icon_state_alive
	var/icon_state_dead
	var/new_health = 100
	var/obj/item/weapon/stock_parts/cell/cell
	var/charge_rate = 10
	var/list/newVars = list()
	var/emag_active = 0
	var/night_vision_on = 0
	var/obj/screen/tac_harness/toggle_emag/toggle_emag_button
	var/obj/screen/tac_harness/open_inv/open_inv_button
	var/obj/screen/tac_harness/toggle_nightvision/toggle_nightvision_button
	var/id_type
	var/headset_type

/obj/item/weapon/storage/tactical_harness/New()
	SSobj.processing += src
	cell = new /obj/item/weapon/stock_parts/cell()
	toggle_emag_button = new /obj/screen/tac_harness/toggle_emag()
	open_inv_button = new /obj/screen/tac_harness/open_inv()
	toggle_nightvision_button = new /obj/screen/tac_harness/toggle_nightvision()
	..()

/obj/item/weapon/storage/tactical_harness/Destroy()
	SSobj.processing -= src
	return ..()

/obj/item/weapon/storage/tactical_harness/process()
	if(cell)
		cell.give(charge_rate)

/obj/item/weapon/storage/tactical_harness/allowed(mob/M)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(check_access(H.get_active_hand()) || (istype(H) && check_access(H.wear_id)) )
			return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/canWear(mob/living/simple_animal/animal)//true if the animal could possibly wear it, even if it is already wearing one.
	if(!animal || !istype(animal))
		return 0
	for(var/type in wearable_by)
		if(istype(animal, type))
			return 1
	if(animal.type in wearable_by_exact)
		return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/add_harness(var/mob/living/simple_animal/animal, var/mob/user = usr)
	if(!animal || animal.harness || !canWear(animal))
		return 0

	if(istype(loc, /mob))
		var/mob/holder = loc
		holder.unEquip(src)

	animal.harness	= src
	animal.icon_living = icon_state_alive
	animal.icon_dead = icon_state_dead
	animal.icon_state = (animal.stat & DEAD) ? animal.icon_dead : animal.icon_living
	animal.maxHealth =  new_health
	animal.health = (animal.health/animal.maxHealth)*new_health //same percent health.
	animal.pullin = new /obj/screen/pull/tac_harness()

	loc = animal
	set_night_vision(night_vision_on)
	if(id_type)
		animal.access_card = new id_type(animal)
	if(headset_type)
		animal.headset = new headset_type(animal)
	for(var/V in newVars)
		animal.vars[V] = newVars[V]

	if(animal.hud_used)
		animal.hud_used.instantiate()
	return 1

/obj/item/weapon/storage/tactical_harness/proc/remove_harness(var/unequip = 1)
	if(!istype(loc, /mob/living/simple_animal))
		return 0
	var/mob/living/simple_animal/wearer = loc
	if(wearer.harness != src)
		return 0
	wearer.icon_living = initial(wearer.icon_living)
	wearer.icon_dead = initial(wearer.icon_dead)
	wearer.icon_state = (wearer.stat & DEAD) ? wearer.icon_dead : wearer.icon_living
	wearer.maxHealth = initial(wearer.maxHealth)
	wearer.health = (wearer.health/wearer.maxHealth)*initial(wearer.health)//same percent health.
	qdel(wearer.access_card)
	qdel(wearer.headset)
	qdel(wearer.pullin)

	for(var/V in newVars)
		wearer.vars[V] = initial(wearer.vars[V])

	set_night_vision(0)

	if(unequip)
		wearer.unEquip(src)

	wearer.harness = null

	if(wearer.hud_used)
		wearer.hud_used.instantiate()
	return 1

/obj/item/weapon/storage/tactical_harness/proc/attempt_remove_harness(mob/user)
	if(!istype(loc, /mob/living/simple_animal))
		return 0
	var/mob/living/simple_animal/wearer = loc
	if(wearer.harness != src)
		return 0
	user.visible_message("<span class='danger'>[user] attempts to remove \the [src] from \the [wearer]!</span>", "<span class='warning'>You attempt to remove \the [src] from \the [wearer].</span>")
	if(do_after(user, 60, target = wearer))
		if(remove_harness())
			user.visible_message("<span class='danger'>[user] removes \the [src] from \the [wearer]!</span>", "<span class='warning'>You remove \the [src] from \the [wearer].</span>")
			return 1
	user.visible_message("<span class='danger'>[user] fails to remove \the [src] from \the [wearer]!</span>", "<span class='warning'>You fail to remove \the [src] from \the [wearer].</span>")
	return 0

/obj/item/weapon/storage/tactical_harness/proc/toggle_night_vision()
	set_night_vision(!night_vision_on)

/obj/item/weapon/storage/tactical_harness/proc/set_night_vision(var/on)
	night_vision_on = on
	toggle_nightvision_button.update_button_icon(src)
	if(istype(loc, /mob/living/simple_animal/))
		var/mob/living/simple_animal/animal = loc
		if(night_vision_on)
			animal.see_in_dark = 8
			animal.see_invisible = SEE_INVISIBLE_MINIMUM
		else
			animal.see_in_dark = initial(animal.see_in_dark)
			animal.see_invisible = initial(animal.see_invisible)

/obj/item/weapon/storage/tactical_harness/proc/toggle_emag()
	emag_active = !emag_active
	toggle_emag_button.update_button_icon(src)
	if(emag_active)
		toggle_emag_button.icon_state = toggle_emag_button.on_icon
	else
		toggle_emag_button.icon_state = toggle_emag_button.off_icon

/obj/item/weapon/storage/tactical_harness/proc/open_inventory(mob/user)
	if(user != loc)
		user << "<span class='notice'>You view \the [src]'s storage pouch. You can add items, but only \the [loc] can remove them while \the [src] is being worn.</span>"
	orient2hud(user)
	if(user.s_active)
		user.s_active.close(user)
	show_to(user)

/obj/item/weapon/storage/tactical_harness/proc/on_attack(mob/living/simple_animal/wearer, atom/target)
	return 0
/*
//This code is for making the dolphin's harness un-openable except by people with syndie access. Leaving it here just in case.
/obj/item/weapon/storage/tactical_harness/content_can_dump(atom/dest_object, mob/user)//don't want to accidentaly dump all your weapons on the ground.
	return 0

/obj/item/weapon/storage/tactical_harness/storage_contents_dump_act(obj/item/weapon/storage/src_object, mob/user)
	return 0

/obj/item/weapon/storage/tactical_harness/MouseDrop(over_object)
	if(over_object != usr)
		return
	if(!allowed(usr))
		usr << "<span class='warning'>Access Denied</span>"
		return 0
	return ..()

/obj/item/weapon/storage/tactical_harness/attack_hand(mob/usr)
	if(!allowed(usr))
		usr << "<span class='warning'>Access Denied</span>"
		return 0
	return ..()

/obj/item/weapon/storage/tactical_harness/can_be_inserted(obj/item/W, stop_messages = 0)
	if(!allowed(usr))
		return 0
	return ..()

/obj/item/weapon/storage/tactical_harness/remove_from_storage(obj/item/W, atom/new_location)
	if(!allowed(usr))
		return 0
	return ..()
*/

///////HUD////////

/obj/screen/tac_harness/
	icon = 'icons/mob/screen_dolphin.dmi'

/obj/screen/tac_harness/proc/update_button_icon(var/obj/item/weapon/storage/dolphin_harness/harness)
	return

/obj/screen/tac_harness/toggle_weapon
	icon_state = "swap_weapon_button"
	name = "Toggle Weapon"
	desc = "Toggle your dorsal-mounted weapon's fire mode."
	screen_loc = "SOUTH:6,CENTER:16"

/obj/screen/tac_harness/toggle_weapon/Click()
	var/mob/living/simple_animal/hostile/animal = usr
	var/obj/item/weapon/storage/tactical_harness/ranged/harness = animal.harness
	if(!istype(animal) || !animal.harness || harness.toggle_weapon_button != src)
		return
	harness.cycle_weapon()
	if(harness.selected_weapon)
		usr << "<span class='notice'>You toggle your dorsal weapon to fire [harness.ranged_attacks[harness.selected_weapon]] rounds.</span>"
	else
		usr << "<span class='notice'>Your dorsal weapon does not have any modules loaded.</span>"

/obj/screen/tac_harness/toggle_safety
	name = "Toggle Safety"
	desc = "Toggle the safety on your dorsal-mounted weapon"
	screen_loc = "SOUTH:6,CENTER-2:16"

/obj/screen/tac_harness/toggle_safety/update_button_icon(var/obj/item/weapon/storage/tactical_harness/ranged/harness)
	if(harness)
		icon_state = harness.weapon_safety ? "safety_on" : "safety_off"

/obj/screen/tac_harness/toggle_safety/Click()
	var/mob/living/simple_animal/hostile/animal = usr
	if(!istype(animal) || !animal.harness)
		return
	var/obj/item/weapon/storage/tactical_harness/ranged/harness = animal.harness
	if(harness.toggle_safety_button != src)
		return
	harness.toggle_safety()
	usr << "<span class='notice'>You [harness.weapon_safety ? "enable" : "disable"] the safety on your dorsal weapon.</span>"

/obj/screen/tac_harness/toggle_emag
	var/on_icon = "emag_button_on"
	var/off_icon = "emag_button_off"
	name = "Toggle Emag"
	desc = "Toggle your build-in cryptographic sequencer"
	screen_loc = "SOUTH:6,CENTER:16"

/obj/screen/tac_harness/toggle_emag/update_button_icon(var/obj/item/weapon/storage/tactical_harness/harness)
	if(harness)
		icon_state = harness.emag_active ? "emag_button_on" : "emag_button_off"

/obj/screen/tac_harness/toggle_emag/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness || animal.harness.toggle_emag_button != src)
		return
	animal.harness.toggle_emag()
	usr << "<span class='notice'>You [animal.harness.emag_active ? "enable" : "disable"] your harness's built-in emag.</span>"

/obj/screen/pull/tac_harness
	icon = 'icons/mob/screen_dolphin.dmi'
	screen_loc = "SOUTH:6,CENTER+2:16"

/obj/screen/tac_harness/open_inv
	icon_state = "inv"
	name = "Open Inventory"
	desc = "Open your harness's inventory"
	screen_loc = "SOUTH:6,CENTER+1:16"

/obj/screen/tac_harness/open_inv/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness || animal.harness.open_inv_button != src)
		return
	if(animal.harness)
		animal.harness.open_inventory(usr)

/obj/screen/tac_harness/toggle_nightvision
	name = "Toggle Night-Vision"
	desc = "Toggle your harness's night-vision filter."
	screen_loc = "SOUTH:6,CENTER-1:16"

/obj/screen/tac_harness/toggle_nightvision/update_button_icon(var/obj/item/weapon/storage/tactical_harness/harness)
	if(harness)
		icon_state = harness.night_vision_on ? "nightvision_on" : "nightvision_off"

/obj/screen/tac_harness/toggle_nightvision/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness || animal.harness.toggle_nightvision_button != src)
		return
	if(animal.harness)
		animal.harness.toggle_night_vision()

/obj/screen/tac_harness/toggle_stun
	name = "Toggle Stun"
	desc = "Toggle your muzzle stun device."
	screen_loc = "SOUTH:6,CENTER-2:16"

/obj/screen/tac_harness/toggle_stun/update_button_icon(var/obj/item/weapon/storage/tactical_harness/corgi/harness)
	if(harness)
		icon_state = harness.stun_on ? "baton_on" : "baton_off"

/obj/screen/tac_harness/toggle_stun/Click()
	var/mob/living/simple_animal/animal = usr
	if(!istype(animal) || !animal.harness)
		return
	var/obj/item/weapon/storage/tactical_harness/corgi/harness = animal.harness
	if(harness.toggle_stun_button != src)
		return
	harness.stun_on = !harness.stun_on
	update_button_icon(harness)

/obj/item/weapon/storage/tactical_harness/proc/tactical_harness_hud(datum/hud/hud)
	var/mob/living/simple_animal/animal = hud.mymob
	if(!animal || !istype(animal))
		return

	var/list/hud_elements = get_hud_elements()

	hud_elements += animal.pullin
	animal.pullin.update_icon(animal)

	for(var/obj/screen/tac_harness/harness_hud_element in hud_elements)
		harness_hud_element.update_button_icon(src)

	animal.client.screen = list()
	animal.client.screen += animal.client.void
	animal.client.screen += hud_elements

/obj/item/weapon/storage/tactical_harness/proc/get_hud_elements()
	var/list/hud_elements = list()
	hud_elements += toggle_emag_button
	hud_elements += open_inv_button
	hud_elements += toggle_nightvision_button
	return hud_elements

/////////// Ranged /////////////

/obj/item/weapon/storage/tactical_harness/ranged
	var/shot_cost = 150
	var/weapon_safety = 1
	var/selected_weapon = 0
	var/list/obj/item/projectile/ranged_attacks = list()//name = list(projectile, cooldown, sound, rapid)
	var/obj/screen/tac_harness/toggle_weapon/toggle_weapon_button
	var/obj/screen/tac_harness/toggle_safety/toggle_safety_button

/obj/item/weapon/storage/tactical_harness/ranged/New()
	..()
	toggle_weapon_button = new /obj/screen/tac_harness/toggle_weapon()
	toggle_safety_button = new /obj/screen/tac_harness/toggle_safety()
	if(ranged_attacks.len)
		selected_weapon = 1

/obj/item/weapon/storage/tactical_harness/ranged/get_hud_elements()
	var/list/hud_elements = ..()
	//hud_elements += dolphin.harness.toggle_weapon_button//only one weapon at the moment, so no need for this. Also the icon is terrible.
	hud_elements += toggle_safety_button
	return hud_elements

/obj/item/weapon/storage/tactical_harness/ranged/proc/can_shoot()
	if(cell && cell.charge >= shot_cost)
		return 1
	return 0

/obj/item/weapon/storage/tactical_harness/ranged/proc/handle_shoot()
	cell.use(shot_cost)

/obj/item/weapon/storage/tactical_harness/ranged/add_harness(var/mob/living/simple_animal/hostile/animal, var/mob/user = usr)
	var/result = ..()
	if(result)
		if(!weapon_safety)
			set_ranged_attack(animal, selected_weapon)
	return result

/obj/item/weapon/storage/tactical_harness/ranged/remove_harness(var/unequip = 1)
	var/mob/living/simple_animal/hostile/wearer = loc
	if(!istype(wearer) || wearer.harness != src)
		return 0
	set_ranged_attack(wearer, null)
	return ..()

/obj/item/weapon/storage/tactical_harness/ranged/proc/toggle_safety()
	weapon_safety = !weapon_safety
	toggle_safety_button.update_button_icon(src)
	if(istype(loc, /mob/living/simple_animal/hostile/))
		var/mob/living/simple_animal/hostile/wearer = loc
		if(weapon_safety)
			set_ranged_attack(wearer, 0)
		else
			set_ranged_attack(wearer, selected_weapon)

/obj/item/weapon/storage/tactical_harness/ranged/proc/cycle_weapon()
	selected_weapon = ranged_attacks.len ? (selected_weapon)%ranged_attacks.len+1 : 0
	if(!weapon_safety)
		set_ranged_attack(loc, selected_weapon)

/obj/item/weapon/storage/tactical_harness/ranged/proc/set_ranged_attack(mob/living/simple_animal/hostile/wearer, index)
	if(!istype(wearer) || !wearer.harness == src)
		return
	if(!index)
		wearer.ranged = initial(wearer.ranged)
		wearer.ranged_cooldown_cap = initial(wearer.ranged_cooldown_cap)
		wearer.ranged_cooldown = 1
		wearer.projectiletype = initial(wearer.projectiletype)
		wearer.projectilesound = initial(wearer.projectilesound)
		wearer.rapid = initial(wearer.rapid)
	else
		var/L = ranged_attacks[ranged_attacks[index]]//name = list(projectile, cooldown, sound, rapid)
		wearer.ranged = 1
		wearer.projectiletype = L[1]
		wearer.ranged_cooldown_cap = L[2]
		wearer.ranged_cooldown = 0
		wearer.projectilesound = L[3]
		wearer.rapid = L[4]

///////////Syndicate/////////////

/obj/item/weapon/storage/tactical_harness/syndicate
	name = "tactical animal harness"
	desc = "A harness for a Syndicate tactical animal. This one will mold itself to the first valid animal it is placed on."
	wearable_by = list(/mob/living/simple_animal/hostile/retaliate/dolphin, /mob/living/simple_animal/hostile/carp/tactical)
	wearable_by_exact = list(/mob/living/simple_animal/hostile/carp)
	var/refund_TC = 0
	var/failed_to_find_player = -1 //-1 means it hasn't tried to find a player yet, 1 means it has tried to find a player and failed, 0 means it has tried to find a player and succeeded. Here to prevent the creation of infinite sentient animals.

/obj/item/weapon/storage/tactical_harness/syndicate/add_harness(var/mob/living/simple_animal/hostile/animal, var/mob/user = usr)
	if(failed_to_find_player && !animal.ckey)
		var/list/carp_candidates = get_candidates(BE_OPERATIVE, 3000, "operative")
		if(carp_candidates.len > 0)
			var/client/C = pick(carp_candidates)
			animal.ckey = C.key
			failed_to_find_player = 0
			animal << "<span class='notice'>You are a space [istype(animal, /mob/living/simple_animal/hostile/retaliate/dolphin) ? "dolphin" : "carp"] trained by the syndicate to assist their elite commando teams. Obey and assist your syndicate masters at all costs.</span>"
			animal.faction += "syndicate"
		else
			user << "<span class='warning'>\The [animal] refuses to cooperate, it looks like it won't be helping you on this mission. You can refund the harness by using it on your uplink.</span>"
			failed_to_find_player = 1
			return

	if(istype(animal, /mob/living/simple_animal/hostile/retaliate/dolphin))
		user << "<span class='notice'>\The [src] molds itself to the shape of \the [animal].</span>"
		qdel(src)
		var/obj/item/weapon/storage/tactical_harness/ranged/the_harness = new /obj/item/weapon/storage/tactical_harness/ranged/syndicate/dolphin()
		the_harness.add_harness(animal, user)
	else if(animal.type == /mob/living/simple_animal/hostile/carp)
		user << "<span class='notice'>\The [src] molds itself to the shape of \the [animal].</span>"
		qdel(src)
		var/obj/item/weapon/storage/tactical_harness/ranged/the_harness = new /obj/item/weapon/storage/tactical_harness/ranged/syndicate/carp()
		the_harness.add_harness(animal, user)
	else
		user << "<span class='notice'>\The [src] does nothing. It looks like it is not compatible with this type of creature.</span>"


/obj/item/weapon/storage/tactical_harness/ranged/syndicate/New()
	..()
	for(var/i=0,i<5;i++)
		new /obj/item/weapon/reagent_containers/food/snacks/syndicake(src)

/obj/item/weapon/storage/tactical_harness/ranged/syndicate/add_harness(var/mob/living/simple_animal/animal, var/mob/user = usr)
	. = ..()
	if(.)
		if(!(/obj/item/weapon/reagent_containers/food/snacks/syndicake in animal.eats))
			animal.eats += /obj/item/weapon/reagent_containers/food/snacks/syndicake
			animal.eats[/obj/item/weapon/reagent_containers/food/snacks/syndicake] = 5

///////////Tactical Dolphin////////////////

/obj/item/weapon/storage/tactical_harness/ranged/syndicate/dolphin
	name = "tactical dolphin harness"
	desc = "A harness for a Syndicate tactical dolphin."
	wearable_by = list(/mob/living/simple_animal/hostile/retaliate/dolphin)
	icon_state_alive = "tactical_dolphin"
	icon_state_dead = "tactical_dolphin_dead"
	newVars = list("name" = "tactical dolphin", "desc" = "A highly trained space dolphin used by the syndicate to provide light fire support and space superiority for elite commando teams.", "speed" = -0.3, "melee_damage_lower" = 15, "melee_damage_upper" = 15)
	shot_cost = 75
	ranged_attacks = list("laser" = list(/obj/item/projectile/beam, 2, 'sound/weapons/sear.ogg', 1))
	req_access = list(access_syndicate)
	headset_type = /obj/item/device/radio/headset/syndicate
	id_type = /obj/item/weapon/card/id/syndicate

///////////Tactical Carp///////////////////
/obj/item/weapon/storage/tactical_harness/ranged/syndicate/carp
	name = "tactical carp harness"
	desc = "A harness for a Syndicate tactical carp."
	wearable_by = list(/mob/living/simple_animal/hostile/carp/tactical)
	wearable_by_exact = list(/mob/living/simple_animal/hostile/carp)
	icon_state_alive = "tactical_carp"
	icon_state_dead = "tactical_carp_dead"
	newVars = list("name" = "tactical space carp", "desc" = "A highly trained space carp used by the syndicate to provide heavy fire support and space superiority for elite commando teams.", "melee_damage_lower" = 15, "melee_damage_upper" = 15)
	ranged_attacks = list("heavy laser" = list(/obj/item/projectile/beam/heavylaser, 2, 'sound/weapons/sear.ogg', 0))
	new_health = 150
	req_access = list(access_syndicate)
	headset_type = /obj/item/device/radio/headset/syndicate
	id_type = /obj/item/weapon/card/id/syndicate

///////////Tactical Corgi///////////////////
/obj/item/weapon/storage/tactical_harness/corgi
	name = "tactical corgi harness"
	desc = "A harness for a Centcomm tactical corgi."
	wearable_by = list(/mob/living/simple_animal/pet/dog/corgi)
	icon_state_alive = "tactical_corgi"
	icon_state_dead = "tactical_corgi_dead"
	newVars = list("name" = "tactical corgi", "desc" = "A highly trained corgi used by centcomm for drug screening and as support for Emergency Response Teams.", "melee_damage_lower" = 15, "melee_damage_upper" = 15, "icon" = 'icons/mob/animal.dmi', "speed" = -0.2, "attack_sound" = 'sound/weapons/bite.ogg')
	new_health = 150
	headset_type = /obj/item/device/radio/headset/headset_cent
	id_type = /obj/item/weapon/card/id/ert
	var/stun_on = 0
	var/stun_amount = 7
	var/hitcost = 100
	var/obj/screen/tac_harness/toggle_stun/toggle_stun_button

/obj/item/weapon/storage/tactical_harness/corgi/New()
	..()
	toggle_stun_button = new /obj/screen/tac_harness/toggle_stun()

/obj/item/weapon/storage/tactical_harness/corgi/get_hud_elements()
	var/list/hud_elements = ..()
	hud_elements += toggle_stun_button
	return hud_elements

/obj/item/weapon/storage/tactical_harness/corgi/on_attack(mob/living/simple_animal/wearer, atom/target, proximity)
	if(!proximity || !stun_on)
		return 0
	var/mob/living/carbon/C = target
	if(istype(C))
		if(cell.charge >= hitcost)
			wearer.do_attack_animation(target)
			cell.use(hitcost)
			C.visible_message("<span class='danger'>[wearer] has stunned [C]!</span>", "<span class='userdanger'>[wearer] has stunned you!</span>")
			playsound(wearer.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			C.Stun(stun_amount)
			C.Weaken(stun_amount)
			C.apply_effect(STUTTER, stun_amount)
		else
			wearer << "<span class='warning'>Not enough charge to stun!</span>"
		return 1
	return 0
