/obj/item/weapon/gun/projectile/automatic/toy
	name = "foam force SMG"
	desc = "A prototype three-round burst toy submachine gun. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "saber"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/toy/smg
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	force = 0
	throwforce = 0
	burst_size = 3
	can_suppress = 0
	clumsy_check = 0
	needs_permit = 0

/obj/item/weapon/gun/projectile/automatic/toy/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/toy/pistol
	name = "foam force pistol"
	desc = "A small, easily concealable toy handgun. Ages 8 and up."
	icon_state = "pistol"
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	fire_sound = 'sound/weapons/Gunshot.ogg'
	can_suppress = 0
	burst_size = 1
	fire_delay = 0
	action_button_name = null

/obj/item/weapon/gun/projectile/automatic/toy/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/toy/pistol/riot
	mag_type = /obj/item/ammo_box/magazine/toy/pistol/riot

/obj/item/weapon/gun/projectile/automatic/toy/pistol/riot/New()
	magazine = new /obj/item/ammo_box/magazine/toy/pistol/riot(src)
	..()

/obj/item/weapon/gun/projectile/shotgun/toy
	name = "foam force shotgun"
	desc = "A toy shotgun with wood furniture and a four-shell capacity underneath. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	force = 0
	throwforce = 0
	origin_tech = null
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy
	clumsy_check = 0
	needs_permit = 0

/obj/item/weapon/gun/projectile/shotgun/toy/process_chamber()
	..()
	if(chambered && !chambered.BB)
		qdel(chambered)

/obj/item/weapon/gun/projectile/shotgun/toy/crossbow
	name = "foam force crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamcrossbow"
	item_state = "crossbow"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy/crossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	slot_flags = SLOT_BELT
	w_class = 2

/obj/item/weapon/gun/projectile/shotgun/toy/awp
	name = "AWP"
	desc = "MLG approved for 360 degree noscopes. This one appears to be a toy"
	icon = 'icons/obj/guns/awp.dmi'
	icon_state = "awpdefault"
	item_state = "awpdefault"
	fire_sound = "sound/weapons/AWP.ogg"
	slot_flags = 0
	w_class = 4
	lefthand_file = 'icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/guns_righthand.dmi'
	l_item_state = "moistnugget"
	r_item_state = "moistnugget"

/obj/item/weapon/gun/projectile/shotgun/toy/awp/asiimov
	name = "AWP Asiimov"
	icon_state = "awpasiimov"
	item_state = "awpasiimov"

/obj/item/weapon/gun/projectile/shotgun/toy/awp/dragonlore
	name = "AWP Dragonlore"
	icon_state = "awpdragonlore"
	item_state = "awpdragonlore"

/obj/item/weapon/gun/projectile/automatic/c20r/toy
	name = "donksoft SMG"
	desc = "A bullpup two-round burst toy SMG, designated 'C-20r'. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	can_suppress = 0
	needs_permit = 0
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45

/obj/item/weapon/gun/projectile/automatic/c20r/toy/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/toy
	name = "donksoft LMG"
	desc = "A heavily modified toy light machine gun, designated 'L6 SAW'. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	can_suppress = 0
	needs_permit = 0
	mag_type = /obj/item/ammo_box/magazine/toy/m762

/obj/item/weapon/gun/projectile/automatic/l6_saw/toy/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()