/obj/item/weapon/reagent_containers/spray/waterflower/lube
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist. A <i>slippery</i> twist."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 10
	spray_maxrange = 1
	spray_currentrange = 1
	volume = 100
	list_reagents = list("lube" = 100)

//COMBAT CLOWN SHOES
//Clown shoes with combat stats and noslip. Of course they still squeek.
/obj/item/clothing/shoes/clown_shoes/combat
	name = "combat clown shoes"
	desc = "advanced clown shoes that protect the wearer and render them nearly immune to slipping on their own peels. They also squeek at 100% capacity."
	flags = SUPERNOSLIP
	slowdown = SHOES_SLOWDOWN
	armor = list(melee = 25, bullet = 25, laser = 25, energy = 25, bomb = 50, bio = 10, rad = 0)
	strip_delay = 70
	burn_state = -1

//The super annoying version
/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat
	name = "mk-honk combat shoes"
	desc = "The culmination of years of clown combat research, these shoes leave a trail of chaos in their wake."
	flags = SUPERNOSLIP
	slowdown = SHOES_SLOWDOWN
	armor = list(melee = 25, bullet = 25, laser = 25, energy = 25, bomb = 50, bio = 10, rad = 0)
	strip_delay = 70
	burn_state = -1
	banana_potency = 50

/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat/New()
	..()
	var/obj/item/stack/sheet/mineral/bananium/B = new /obj/item/stack/sheet/mineral/bananium()
	B.amount = 5000 //50 peels worth
	bananium.insert_stack(B)

//BANANIUM SWORD

/obj/item/weapon/melee/energy/sword/bananium
	name = "bananium sword"
	desc = "An elegant weapon, for a more civilized age."
	force = 0
	throwforce = 0
	force_on = 0
	throwforce_on = 0
	hitsound = null
	attack_verb_on = list("slipped")

/obj/item/weapon/melee/energy/sword/bananium/New()
	..()
	item_color = "yellow"

/obj/item/weapon/melee/energy/sword/bananium/attack(mob/vict, mob/usr)
	if (istype(vict, /mob/living/carbon))
		var/blockable = 0
		var/blockitem = null
		if (vict == usr)
			doSlip(vict)
			return ..()
		if (istype(vict.get_active_hand(), /obj/item/weapon/melee/energy))
			var/obj/item/weapon/melee/energy/blocktool = vict.get_active_hand()
			if (blocktool.active)
				blockable = blockable + blockchance
				blockitem = blocktool
		if(istype(vict.get_inactive_hand(), /obj/item/weapon/melee/energy))
			var/obj/item/weapon/melee/energy/blocktool = vict.get_inactive_hand()
			if (blocktool.active)
				blockable = blockable + blockchance * 0.75
				if (blockitem==null || rand(1, 3)<=1)
					blockitem = vict.get_inactive_hand()

		if ((rand(0, blockable*100)/100)>0.5)
			vict.visible_message("<span class='warning'>[vict] expertly blocks [src] with [blockitem]!</span>", "<span class='notice'>You block [src] with [blockitem] with amazing skill!</span>")
			playsound(vict, 'sound/weapons/blade1.ogg', 35, 1)
			return 0
	doSlip(vict)
	..()

/obj/item/weapon/melee/energy/sword/bananium/Crossed(atom/movable/AM)
	doSlip(AM)

/obj/item/weapon/melee/energy/sword/bananium/throw_impact(atom/target)
	doSlip(target)

/obj/item/weapon/melee/energy/sword/bananium/proc/doSlip(mob/living/carbon/M)
	if (!active || !istype(M))
		return
	M.slip(8, 5, src, GALOSHES_DONT_HELP)

/obj/item/weapon/melee/energy/sword/bananium/attack_self(mob/living/carbon/user)
	active = !active
	if (active)
		if(attack_verb_on.len)
			attack_verb = attack_verb_on
		if(!item_color)
			icon_state = icon_state_on
		else
			icon_state = "sword[item_color]"
		w_class = w_class_on
		playsound(user, 'sound/weapons/saberon.ogg', 35, 1)
		user << "<span class='notice'>[src] is now active.</span>"
	else
		if(attack_verb_on.len)
			attack_verb = list()
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		playsound(user, 'sound/weapons/saberoff.ogg', 35, 1)
		user << "<span class='notice'>[src] can now be concealed.</span>"
	add_fingerprint(user)
	return

/obj/item/weapon/melee/energy/sword/bananium/attackby(obj/item/weapon/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/weapon/melee/energy/sword/bananium/))
		user << "You slap the two swords together. Sadly, they do not seem to fit."
		playsound(src, 'sound/misc/sadtrombone.ogg', 50)
/*
//not dealing with this at the moment.
/obj/item/weapon/twohanded/dualsaber/bananium
	name = "double-bladed toy sword"
	desc = "A cheap, plastic replica of TWO energy swords.  Double the fun!"
	force = 0
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	force_unwielded = 0
	force_wielded = 0
	origin_tech = null
	attack_verb = list("attacked", "struck", "hit")
*/

//BANANIUM SHIELD

/obj/item/weapon/shield/energy/bananium
	name = "bananium energy shield"
	desc = "A shield that stops most melee attacks, protects user from almost all energy projectiles, and can be thrown to slip opponents."
	throw_speed = 1
	clumsy_check = 0
	icon_state = "bananaeshield0"
	icon_state_base = "bananaeshield"
	force = 0
	throwforce = 0
	throw_range = 5
	on_force = 0
	on_throwforce = 0
	on_throw_speed = 1

/obj/item/weapon/shield/energy/bananium/throw_at(atom/target, range, speed, mob/thrower, spin=1)
	if(active)
		if(iscarbon(thrower))
			var/mob/living/carbon/C = thrower
			C.throw_mode_on() //so they can catch it on the return.
	return ..()

/obj/item/weapon/shield/energy/bananium/throw_impact(atom/hit_atom)
	if(active)
		var/temp = hit_atom.hitby(src, 0, 0)
		if(iscarbon(hit_atom) && !temp)//if they are a carbon and they didn't catch it
			var/mob/living/carbon/C = hit_atom
			C.slip(8, 5, src, GALOSHES_DONT_HELP)
		if(thrownby && !temp)
			spawn(1) //This protects from a bug that would make it hit the thrower twice on the return in some circumstances.
				throw_at(thrownby, throw_range+2, throw_speed, null, 1)
	else
		return ..()

//BOMBANANA

/obj/item/weapon/reagent_containers/food/snacks/grown/banana/bombanana
	trash = /obj/item/weapon/grenade/syndieminibomb/bombanana_peel

/obj/item/weapon/grenade/syndieminibomb/bombanana_peel
	name = "banana peel"
	desc = "A peel from a banana. Why is it beeping?"
	icon = 'icons/obj/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"

/obj/item/weapon/grenade/syndieminibomb/bombanana_peel/New()
	..()
	playsound(get_turf(src), 'sound/weapons/armbomb.ogg', 60, 1)
	if(iscarbon(loc))
		loc << "\The [src] begins to beep."
		var/mob/living/carbon/C = loc
		C.throw_mode_on()
	spawn(det_time)
		prime()

/obj/item/weapon/grenade/syndieminibomb/bombanana_peel/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is deliberately slipping on the [src.name]! It looks like \he's trying to commit suicide.</span>")
	playsound(loc, 'sound/misc/slip.ogg', 50, 1, -1)
	if(active)
		prime()
	return (BRUTELOSS)

/obj/item/weapon/grenade/syndieminibomb/bombanana_peel/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		M.slip(10, 20, src)
		return 1

//TEARSTACHE GRENADE

/obj/item/weapon/grenade/chem_grenade/teargas/moustache
	name = "tear-stache grenade"
	desc = "A handsomely-attired teargas grenade, with a clownish twist."
	icon_state = "moustacheg"
	clumsy_check = 2

/obj/item/weapon/grenade/chem_grenade/teargas/moustache/prime()
	for(var/mob/living/carbon/M in oview(5, src))
		if(!istype(M.wear_mask, /obj/item/clothing/mask/gas/clown_hat) && !istype(M.wear_mask, /obj/item/clothing/mask/fakemoustache) && !istype(M.wear_mask,  /obj/item/clothing/mask/gas/mime) )//Regular fake moustaches block the effect, this is intentional. Mimes have their invisible magics to protect them.
			M.unEquip(M.wear_mask, 1)
			var/obj/item/clothing/mask/fakemoustache/the_stash = new /obj/item/clothing/mask/fakemoustache()
			the_stash.flags |= NODROP
			M.equip_to_slot_if_possible(the_stash, slot_wear_mask, 1, 1)
	..()

//DARK H.O.N.K. AND CLOWN MECH WEAPONS

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana
	name = "bombanana mortar"
	desc = "Equipment for clown exosuits. Launches exploding banana peels."
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/weapon/grenade/syndieminibomb/bombanana_peel
	projectiles = 8
	projectile_energy_cost = 1000

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache
	name = "\improper HONKeR-6 grenade launcher"
	desc = "A weapon for combat exosuits. Launches primed tear-stache grenades."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/weapon/grenade/chem_grenade/teargas/moustache
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 60
	det_time = 20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache/can_attach(obj/mecha/combat/honker/M)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/mecha/combat/honker/dark
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. This one has been painted black for maximum fun. HONK!"
	name = "\improper Dark H.O.N.K"
	icon_state = "darkhonker"
	operation_req_access = list(access_theatre, access_syndicate)
	wreckage = /obj/structure/mecha_wreckage/honker/dark
	health = 200 //the standard HONK mech has amazing damage_absorption so I'm not messing with it.


/obj/mecha/combat/honker/dark/add_cell(obj/item/weapon/stock_parts/cell/C = null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000

/obj/mecha/combat/honker/dark/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/honker()
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana()//Needed more offensive weapons.
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache()//The mousetrap mortar was not up-to-snuff.
	ME.attach(src)
	return

/obj/structure/mecha_wreckage/honker/dark
	name = "\improper Dark H.O.N.K wreckage"
	icon_state = "darkhonker-broken"