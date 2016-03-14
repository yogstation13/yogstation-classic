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
	req_access = list(access_syndicate)
	var/obj/item/weapon/stock_parts/cell/cell
	var/shot_cost = 150
	var/charge_rate = 10

	var/list/wearable_by = list()//types of animals that can wear it. Their subtypes can also wear it. Should be a /mob/living/simple_animal/hostile.
	var/list/wearable_by_exact = list()//types of aninals that can wear it, but their subtypes can't (i.e. carps, but not megacarps or magicarps). Should be a /mob/living/simple_animal/hostile.
	var/icon_state_alive
	var/icon_state_dead
	var/animal_new_name
	var/animal_new_desc
	var/attack_cooldown_cap = 1
	var/rapid_fire = 0
	var/new_speed = 0
	var/new_health = 100
	var/new_melee_damage = 15

	var/emag_active = 0
	var/weapon_safety = 1
	var/night_vision_on = 0
	var/obj/item/projectile/selected_weapon
	var/list/obj/item/projectile/ranged_attacks = list()
	var/obj/screen/tac_harness/toggle_weapon/toggle_weapon_button
	var/obj/screen/tac_harness/toggle_safety/toggle_safety_button
	var/obj/screen/tac_harness/toggle_emag/toggle_emag_button
	var/obj/screen/tac_harness/open_inv/open_inv_button
	var/obj/screen/tac_harness/toggle_nightvision/toggle_nightvision_button

/obj/item/weapon/storage/tactical_harness/New()
	SSobj.processing += src
	cell = new /obj/item/weapon/stock_parts/cell()
	toggle_weapon_button = new /obj/screen/tac_harness/toggle_weapon()
	toggle_safety_button = new /obj/screen/tac_harness/toggle_safety()
	toggle_emag_button = new /obj/screen/tac_harness/toggle_emag()
	open_inv_button = new /obj/screen/tac_harness/open_inv()
	toggle_nightvision_button = new /obj/screen/tac_harness/toggle_nightvision()
	if(ranged_attacks.len)
		selected_weapon = ranged_attacks[1]
	for(var/i=0,i<5;i++)
		new /obj/item/weapon/reagent_containers/food/snacks/syndicake(src)
	..()

/obj/item/weapon/storage/tactical_harness/Destroy()
	SSobj.processing -= src
	return ..()

/obj/item/weapon/storage/tactical_harness/proc/can_shoot()
	if(cell && cell.charge >= shot_cost)
		return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/handle_shoot()
	cell.use(shot_cost)

/obj/item/weapon/storage/tactical_harness/process()
	if(cell)
		cell.give(charge_rate)

/obj/item/weapon/storage/tactical_harness/allowed(mob/M)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(check_access(H.get_active_hand()) || (istype(H) && check_access(H.wear_id)) )
			return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/canWear(mob/living/simple_animal/hostile/animal)//true if the animal could possibly wear it, even if it is already wearing one.
	if(!animal || !istype(animal))
		return 0
	for(var/type in wearable_by)
		if(istype(animal, type))
			return 1
	if(animal.type in wearable_by_exact)
		return 1
	return 0

/obj/item/weapon/storage/tactical_harness/proc/add_harness(var/mob/living/simple_animal/hostile/animal, var/mob/user = usr)
	if(!animal || animal.harness || !canWear(animal))
		return 0
	if(!(/obj/item/weapon/reagent_containers/food/snacks/syndicake in animal.eats))
		animal.eats += /obj/item/weapon/reagent_containers/food/snacks/syndicake
		animal.eats[/obj/item/weapon/reagent_containers/food/snacks/syndicake] = 5

	animal.harness	= src
	animal.icon_living = icon_state_alive
	animal.icon_dead = icon_state_dead
	animal.icon_state = (animal.stat & DEAD) ? animal.icon_dead : animal.icon_living
	animal.name = animal_new_name
	animal.desc = animal_new_desc
	animal.maxHealth =  new_health
	animal.health = (animal.health/animal.maxHealth)*new_health //same percent health.
	animal.melee_damage_lower = initial(new_melee_damage)
	animal.melee_damage_upper = initial(new_melee_damage)
	animal.access_card = new /obj/item/weapon/card/id/syndicate(animal)
	animal.headset = new /obj/item/device/radio/headset/syndicate(animal)
	animal.pullin = new /obj/screen/pull/tac_harness()
	if(istype(loc, /mob))
		var/mob/holder = loc
		holder.unEquip(src)
	loc = animal
	animal.ranged = !weapon_safety
	animal.projectiletype = selected_weapon
	animal.ranged_cooldown_cap = attack_cooldown_cap
	animal.rapid = rapid_fire
	animal.speed = new_speed
	animal.projectilesound = 'sound/weapons/sear.ogg'

	set_night_vision(night_vision_on)

	if(animal.hud_used)
		animal.hud_used.instantiate()
	return 1

/obj/item/weapon/storage/tactical_harness/proc/remove_harness(var/unequip = 1)
	if(!istype(loc, /mob/living/simple_animal/hostile))
		return 0
	var/mob/living/simple_animal/hostile/wearer = loc
	if(wearer.harness != src)
		return 0
	wearer.icon_living = initial(wearer.icon_living)
	wearer.icon_dead = initial(wearer.icon_dead)
	wearer.icon_state = (wearer.stat & DEAD) ? wearer.icon_dead : wearer.icon_living
	wearer.name = initial(wearer.name)
	wearer.desc = initial(wearer.desc)
	wearer.maxHealth = initial(wearer.maxHealth)
	wearer.health = (wearer.health/wearer.maxHealth)*initial(wearer.health)//same percent health.
	wearer.melee_damage_lower = initial(wearer.melee_damage_lower)
	wearer.melee_damage_upper = initial(wearer.melee_damage_upper)
	qdel(wearer.access_card)
	qdel(wearer.headset)
	qdel(wearer.pullin)

	wearer.ranged = initial(wearer.ranged)
	wearer.projectiletype = initial(wearer.projectiletype)
	wearer.ranged_cooldown_cap = initial(wearer.ranged_cooldown_cap)
	wearer.rapid = initial(wearer.rapid)
	wearer.speed = initial(wearer.speed)
	wearer.projectilesound = initial(wearer.projectilesound)

	set_night_vision(0)

	if(wearer.hud_used)
		wearer.hud_used.instantiate()

	if(unequip)
		wearer.unEquip(src)

	wearer.harness = null
	return 1

/obj/item/weapon/storage/tactical_harness/proc/attempt_remove_harness(mob/user)
	if(!istype(loc, /mob/living/simple_animal/hostile))
		return 0
	var/mob/living/simple_animal/hostile/wearer = loc
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
	if(istype(loc, /mob/living/simple_animal/hostile/))
		var/mob/living/simple_animal/hostile/animal = loc
		if(night_vision_on)
			animal.see_in_dark = 8
			animal.see_invisible = SEE_INVISIBLE_MINIMUM
		else
			animal.see_in_dark = initial(animal.see_in_dark)
			animal.see_invisible = initial(animal.see_invisible)

/obj/item/weapon/storage/tactical_harness/proc/toggle_safety()
	weapon_safety = !weapon_safety
	toggle_safety_button.update_button_icon(src)
	if(istype(loc, /mob/living/simple_animal/hostile/))
		var/mob/living/simple_animal/hostile/animal = loc
		if(weapon_safety)
			animal.ranged = 0
		else
			animal.ranged = 1
			animal.projectiletype = selected_weapon

/obj/item/weapon/storage/tactical_harness/proc/cycle_weapon()
	if(ranged_attacks.len == 0)
		selected_weapon = null
	else
		var/index = ranged_attacks.Find(selected_weapon)
		if(!index)
			selected_weapon = ranged_attacks[1]
		else
			selected_weapon = ranged_attacks[((index) % ranged_attacks.len) + 1]
	if(istype(loc, /mob/living/simple_animal/hostile/))
		var/mob/living/simple_animal/hostile/animal = loc
		animal.projectiletype = selected_weapon

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
//All of these Icons need real sprites.
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
	if(!istype(animal) || !animal.harness || animal.harness.toggle_weapon_button != src)
		return
	animal.harness.cycle_weapon()
	if(animal.harness.selected_weapon)
		usr << "<span class='notice'>You toggle your dorsal weapon to fire [animal.harness.ranged_attacks[animal.harness.selected_weapon]] rounds.</span>"
	else
		usr << "<span class='notice'>Your dorsal weapon does not have any modules loaded.</span>"

/obj/screen/tac_harness/toggle_safety
	name = "Toggle Safety"
	desc = "Toggle the safety on your dorsal-mounted weapon"
	screen_loc = "SOUTH:6,CENTER-1:16"

/obj/screen/tac_harness/toggle_safety/update_button_icon(var/obj/item/weapon/storage/tactical_harness/harness)
	if(harness)
		icon_state = harness.weapon_safety ? "safety_on" : "safety_off"

/obj/screen/tac_harness/toggle_safety/Click()
	var/mob/living/simple_animal/hostile/animal = usr
	if(!istype(animal) || !animal.harness || animal.harness.toggle_safety_button != src)
		return
	animal.harness.toggle_safety()
	usr << "<span class='notice'>You [animal.harness.weapon_safety ? "enable" : "disable"] the safety on your dorsal weapon.</span>"

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
	var/mob/living/simple_animal/hostile/animal = usr
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
	var/mob/living/simple_animal/hostile/animal = usr
	if(!istype(animal) || !animal.harness || animal.harness.open_inv_button != src)
		return
	if(animal.harness)
		animal.harness.open_inventory(usr)

/obj/screen/tac_harness/toggle_nightvision
	name = "Toggle Night-Vision"
	desc = "Toggle your harness's night-vision filter."
	screen_loc = "SOUTH:6,CENTER-2:16"

/obj/screen/tac_harness/toggle_nightvision/update_button_icon(var/obj/item/weapon/storage/tactical_harness/harness)
	if(harness)
		icon_state = harness.night_vision_on ? "nightvision_on" : "nightvision_off"

/obj/screen/tac_harness/toggle_nightvision/Click()
	var/mob/living/simple_animal/hostile/animal = usr
	if(!istype(animal) || !animal.harness || animal.harness.toggle_nightvision_button != src)
		return
	if(animal.harness)
		animal.harness.toggle_night_vision()

/datum/hud/proc/tactical_harness_hud()
	var/mob/living/simple_animal/hostile/animal = mymob
	if(!animal || !istype(animal) || !animal.harness)
		return

	var/list/hud_elements = list()

	//hud_elements += dolphin.harness.toggle_weapon_button//only one weapon at the moment, so no need for this. Also the icon is terrible.
	hud_elements += animal.harness.toggle_safety_button
	hud_elements += animal.harness.toggle_emag_button
	hud_elements += animal.harness.open_inv_button
	hud_elements += animal.harness.toggle_nightvision_button

	hud_elements += mymob.pullin
	mymob.pullin.update_icon(mymob)

	for(var/obj/screen/tac_harness/harness_hud_element in hud_elements)
		harness_hud_element.update_button_icon(animal.harness)

	mymob.client.screen = list()
	mymob.client.screen += mymob.client.void
	mymob.client.screen += hud_elements


///////////Tactical Dolphin////////////////

/obj/item/weapon/storage/tactical_harness/universal
	name = "tactical animal harness"
	desc = "A harness for a Syndicate tactical animal. This one will mold itself to the first valid animal it is placed on."
	wearable_by = list(/mob/living/simple_animal/hostile/retaliate/dolphin, /mob/living/simple_animal/hostile/carp/tactical)
	wearable_by_exact = list(/mob/living/simple_animal/hostile/carp)
	var/refund_TC = 0
	var/failed_to_find_player = -1 //-1 means it hasn't tried to find a player yet, 1 means it has tried to find a player and failed, 0 means it has tried to find a player and succeeded. Here to prevent the creation of infinite sentient animals.

/obj/item/weapon/storage/tactical_harness/universal/add_harness(var/mob/living/simple_animal/hostile/animal, var/mob/user = usr)
	if(failed_to_find_player && !animal.ckey)
		var/list/carp_candidates = get_candidates(BE_OPERATIVE, 3000, "operative")
		if(carp_candidates.len > 0)
			var/client/C = pick(carp_candidates)
			animal.ckey = C.key
			failed_to_find_player = 0
			animal << "<span class='notice'>You are a space [istype(animal, /mob/living/simple_animal/hostile/retaliate/dolphin) ? "dolphin" : "carp"] trained by the syndicate to assist their elite commando teams. Obey and assist your syndicate masters at all costs.</span>"
			animal.faction += "syndicate"
			animal.can_speak_human = 0
		else
			user << "<span class='warning'>\The [animal] refuses to cooperate, it looks like it won't be helping you on this mission. You can refund the harness by using it on your uplink.</span>"
			failed_to_find_player = 1
			return

	if(istype(animal, /mob/living/simple_animal/hostile/retaliate/dolphin))
		user << "<span class='notice'>\The [src] molds itself to the shape of \the [animal].</span>"
		qdel(src)
		var/obj/item/weapon/storage/tactical_harness/the_harness = new /obj/item/weapon/storage/tactical_harness/dolphin()
		the_harness.add_harness(animal, user)
	else if(animal.type == /mob/living/simple_animal/hostile/carp)
		user << "<span class='notice'>\The [src] molds itself to the shape of \the [animal].</span>"
		qdel(src)
		var/obj/item/weapon/storage/tactical_harness/the_harness = new /obj/item/weapon/storage/tactical_harness/carp()
		the_harness.add_harness(animal, user)
	else
		user << "<span class='notice'>\The [src] does nothing. It looks like it is not compatible with this type of creature.</span>"

/obj/item/weapon/storage/tactical_harness/dolphin
	name = "tactical dolphin harness"
	desc = "A harness for a Syndicate tactical dolphin."
	wearable_by = list(/mob/living/simple_animal/hostile/retaliate/dolphin)
	icon_state_alive = "tactical_dolphin"
	icon_state_dead = "tactical_dolphin_dead"
	animal_new_name = "tactical dolphin"
	animal_new_desc = "A highly trained space dolphin used by the syndicate to provide light fire support and space superiority for elite commando teams."
	new_speed = -0.3 //faster than an unencumbered human, but not too much faster.
	rapid_fire = 1
	shot_cost = 75
	ranged_attacks = list(/obj/item/projectile/beam = "laser")

///////////Tactical Carp///////////////////
/obj/item/weapon/storage/tactical_harness/carp
	name = "tactical carp harness"
	desc = "A harness for a Syndicate tactical carp."
	wearable_by = list(/mob/living/simple_animal/hostile/carp/tactical)
	wearable_by_exact = list(/mob/living/simple_animal/hostile/carp)
	icon_state_alive = "tactical_carp"
	icon_state_dead = "tactical_carp_dead"
	animal_new_name = "tactical space carp"
	animal_new_desc = "A highly trained space carp used by the syndicate to provide heavy fire support and space superiority for elite commando teams."
	ranged_attacks = list(/obj/item/projectile/beam/heavylaser = "heavy laser")
	new_health = 150
