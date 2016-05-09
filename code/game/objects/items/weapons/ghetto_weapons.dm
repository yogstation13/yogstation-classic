
/obj/item/ducttape
	icon = 'icons/obj/ghetto_armoury.dmi'
	name = "duct tape"
	icon_state = "ductape"
	desc = "Used in the the crafting of various items."

/obj/item/weapon/ghetto
	icon = 'icons/obj/ghetto_armoury.dmi'
	lefthand_file = 'icons/obj/ghetto_armoury.dmi'
	righthand_file = 'icons/obj/ghetto_armoury.dmi'
	desc = "You should not see this. #AdminBus"

/obj/item/weapon/ghetto/glass
	var/smashable = 1
	var/uses = 10
	lefthand_file = 'icons/obj/ghetto_armoury.dmi'
	righthand_file = 'icons/obj/ghetto_armoury.dmi'

/obj/item.weapon/ghetto/glass/attack(mob/target, mob/living/carbon/human/user)
	..()
	if(smashable)
		uses--
		if(uses <= 0)
			if(prob(40))
				user.visible_message("<span class='notice'>You hear a slight tinkle as [src] smashes!</span>")
				qdel(src)
				if(istype(target, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = target
					if(prob(80))
						H.blood_max += rand(0.5, 3)

/obj/item/weapon/ghetto/glass/shank
	name = "glass shank"
	icon_state = "shank"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	l_item_state = "shard-glass"
	r_item_state = "shard-glass"
	desc = "A shard of glass with duct tape wrapped around the bottom to create a handle."
	force = 5.0
	w_class = 2.0
	throwforce = 4.0
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/ghetto/glass/sword
	name = "glass sword"
	icon_state = "glass_sword"
	desc = "A sword made out of shiny glass. Perfect for slashing."
	force = 13.0
	w_class = 4.0
	throwforce = 10.0
	hitsound = 'sound/weapons/bladeslice.ogg'
	l_item_state = "glass_sword_l"
	r_item_state = "glass_sword_r"

/obj/item/weapon/ghetto/glass/sword/black
	name = "black glass sword"
	icon_state = "black_sword"
	desc = "A sword made out of shiny black glass. Perfect for slashing."
	l_item_state = "black_sword_l"
	r_item_state = "black_sword_r"

/obj/item/weapon/ghetto/glass/sword/refined
	name = "refined glass sword"
	lefthand_file = 'icons/obj/ghetto_armoury.dmi'
	righthand_file = 'icons/obj/ghetto_armoury.dmi'
	l_item_state = "black_sword_l"
	r_item_state = "black_sword_r"
	icon_state = "glass_refined"
	desc = "A sword made out of refined black glass. Can be placed on your back and its perfect for slashing."
	force = 16.0
	throwforce = 12.0
	slot_flags = SLOT_BACK
	smashable = 0

/obj/item/weapon/ghetto/airspear
	icon_state = "spear_detached"
	name = "pneumatic spear"
	desc = "A spear with a canister of tank of gas ductaped to it to allow extra thrust."
	slot_flags = SLOT_BACK
	throwforce = 19
	throw_speed = 3
	flags = NOSHIELD

	l_item_state = "spearglass0"
	r_item_state = "spearglass0"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	var/obj/item/weapon/tank/tank = null

	var/old_throw_speed = 3
	var/old_throw_force = 19

	var/max_throw_force = 24
	var/minimum_kpi = 100
	var/divise_constant = 100
	var/fraction_decrease_gas = 7

/obj/item/weapon/ghetto/airspear/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/tank))
		if(tank)
			user << "<span class='notice'>You need to take the current tank out to put a new one in.</span>"
		else
			if(!user.unEquip(W))
				return
			user << "<span class='notice'>You insert a new tank.</span>"
			src.tank = W
			W.loc = src
			icon_state = "spear_off"

/obj/item/weapon/ghetto/airspear/throw_at(atom/target, range, speed, mob/thrower, spin, diagonals_first)
	if(tank && tank.air_contents && tank.air_contents.return_pressure() >= minimum_kpi)

		throw_speed = old_throw_speed+tank.air_contents.return_pressure()/divise_constant
		throwforce = old_throw_force+tank.air_contents.return_pressure()/(divise_constant/2)

		if(throwforce > max_throw_force) throwforce = max_throw_force

		icon_state = "spear_on"

		var/datum/gas_mixture/removed = tank.air_contents.remove(tank.air_contents.total_moles()/fraction_decrease_gas)
		loc.assume_air(removed)
		air_update_turf()

		spawn(40)
			if(tank)
				icon_state = "spear_off"
			throw_speed = old_throw_speed
			throwforce = old_throw_force
	..()

/obj/item/weapon/ghetto/airspear/attack_self(mob/user)
	if(tank)
		src.tank.loc = get_turf(user)
		user.put_in_hands(tank)
		src.tank = null
		user << "<span class='notice'>You take the tank out.</span>"
		icon_state = "spear_detached"
	else
		user << "<span class='notice'>Theres no tank installed yet.</span>"


/obj/item/clothing/suit/robustcoat
	name = "robust coat"
	desc = "Senpai am i robust yet?"
	icon = 'icons/obj/ghetto_armoury.dmi'
	alternate_worn_icon = 'icons/obj/ghetto_armoury.dmi'
	icon_state = "coat"
	item_state = "coat"
	burn_state = -1
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/weapon/gun/projectile/automatic/pistol,/obj/item/weapon/gun/projectile/revolver,/obj/item/weapon/gun/projectile/revolver/detective)
	armor = list(melee = 4, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/armouredjumpsuit
	name = "armoured jumpsuit"
	desc = "A jumpsuit modified with metal plates... And ductape..."
	icon = 'icons/obj/ghetto_armoury.dmi'
	alternate_worn_icon = 'icons/obj/ghetto_armoury.dmi'
	item_state = "armoured_suit"
	item_color = "armoured_suit"
	icon_state = "suit_icon"
	armor = list(melee = 2, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	strip_delay = 40