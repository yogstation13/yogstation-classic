


/obj/item/weapon/shuriken
	name = "yautja shuriken"
	desc = "A thrown Yautja weapon which is constructed with six retractable blades"
	//icon = 'icons/mob/predators.dmi'
	icon_state = "pred_disk_closed"
	item_state = "pred_disk_open"
	force = 12
	throwforce = 120
	throw_speed = 6
	embedded_pain_multiplier = 32
	w_class = 2
	embed_chance = 100
	embedded_fall_chance = 0

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








