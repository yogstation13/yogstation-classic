// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---
// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---
// --- WEAPONS ---  --- WEAPONS ---  --- WEAPONS ---

/obj/item/weapon/shuriken
	name = "yautja shuriken"
	desc = "A thrown Yautja weapon which is constructed with six retractable blades"
	//icon = 'icons/mob/predators.dmi'
	icon_state = "pred_disk_closed"
	item_state = "pred_disk_closed"
	force = 12
	throwforce = 120
	throw_speed = 6
	embedded_pain_multiplier = 32
	w_class = 2
	embed_chance = 100
	embedded_fall_chance = 0

/obj/item/weapon/shuriken/attack_self(mob/user)
	if(icon_state == "pred_disk_closed")
		icon_state = "pred_disk_open"
		item_state = "pred_disk_open"
		force = 12
		throwforce = 120
		slot_flags = SLOT_BACK
		throw_speed = 3
		embedded_pain_multiplier = 32
		w_class = 2
		embed_chance = 100
	else
		icon_state = "pred_disk_closed"
		item_state = "pred_disk_closed"
		force = 3
		throwforce = 30
		throw_speed = 2
		slot_flags = SLOT_BELT
		embedded_pain_multiplier = 0
		w_class = 1
		embed_chance = 0

/obj/item/weapon/twohanded/spear/combistick
	name = "yautja combistick"
	desc = "The Combistick is telescopic, making it relatively small and easy to store when not in use but extending to its full length when required in combat. It is made of incredibly light, sharp, thin but strong material. It can be used both as a close-quarters hand-to-hand weapon and thrown like a spear"
	icon_state = "pred_spear_off"
	item_state = "pred_spear_off"
	force = 3
	w_class = 1
	slot_flags = SLOT_BELT
	force_unwielded = 3
	force_wielded = 7
	throwforce = 3
	throw_speed = 1
	embedded_impact_pain_multiplier = 0

/obj/item/weapon/twohanded/spear/combistick/attack_self(mob/user)
	if(icon_state == "pred_spear_off")
		icon_state = "pred_spear_on"
		item_state = "pred_spear_on"
		force = 15
		w_class = 4
		slot_flags = SLOT_BACK
		force_unwielded = 20
		force_wielded = 40
		throwforce = 150
		throw_speed = 4
		embedded_impact_pain_multiplier = 3
	else
		icon_state = "pred_spear_off"
		item_state = "pred_spear_off"
		force = 3
		w_class = 1
		slot_flags = SLOT_BELT
		force_unwielded = 3
		force_wielded = 7
		throwforce = 3
		throw_speed = 1
		embedded_impact_pain_multiplier = 0



// --- HELMET ---  --- HELMET ---  --- HELMET ---
// --- HELMET ---  --- HELMET ---  --- HELMET ---
// --- HELMET ---  --- HELMET ---  --- HELMET ---

/obj/item/clothing/head/helmet/space/hardsuit/predator
	name = "yautja bio-mask"
	desc = "A specialized mask incorporating a breathing apparatus and diagnostics. It is composed of unknown materials and appears to be resistant to all forms of damage."
	//icon = 'icons/mob/predators.dmi'
	icon_state = "hardsuit0-pred"
	item_state = "hardsuit0-pred"
	armor = list(melee = 15, bullet = 15, laser = 15, energy = 15, bomb = 15, bio = 100, rad = 75)
	//basestate = "helmet"
	brightness_on = 0 //luminosity when on
	on = 0
	blockTracking = 1
	item_color = "pred" //Determines used sprites: hardsuit[on]-[color] and hardsuit[on]-[color]2 (lying down sprite)
	action_button_name = "Toggle Bio-Mask Light"
	flags = BLOCKHAIR | STOPSPRESSUREDMAGE | THICKMATERIAL | NODROP
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/helmet/space/hardsuit/predator/toggle_helmlight()
	set category = "Object"
	name = "Toggle visor"
	desc = "Click to toggle your masks's visor."

	var/mob/living/carbon/human/user = usr
	user.nightvision = !user.nightvision
	user.handle_vision()

	return


// --- SUIT ---  --- SUIT ---  --- SUIT ---
// --- SUIT ---  --- SUIT ---  --- SUIT ---
// --- SUIT ---  --- SUIT ---  --- SUIT ---

/obj/item/clothing/suit/space/hardsuit/predator
	name = "yautja plate armour"
	desc = "A special multi-layer suit capable of resisting all forms of damage. It is extremely light and is composed of unknown materials."
	//icon = 'icons/mob/predators.dmi'
	icon_state = "hardsuit_pred"
	item_state = "hardsuit_pred"
	slowdown = 0
	armor = list(melee = 15, bullet = 15, laser = 15, energy = 15, bomb = 15, bio = 100, rad = 75)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals, /obj/item/device/t_scanner, /obj/item/weapon/rcd)
	//var/obj/item/clothing/head/helmet/space/hardsuit/helmet
	action_button_name = "Toggle Bio-Mask"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/predator
	//var/obj/item/weapon/tank/jetpack/suit/jetpack = null

/obj/item/clothing/under/predator
	desc = "It's a Yautja Skinsuit capable of resisting small amounts of damage, it has multiple slots for storing equipment."
	name = "yautja skinsuit"
	icon_state = "pred"
	item_state = "pred"
	armor = list(melee = 3, bullet = 3, laser = 3, energy = 3, bomb = 3, bio = 3, rad = 3)
	has_sensor = 0
	random_sensor = 0
	can_adjust = 0

