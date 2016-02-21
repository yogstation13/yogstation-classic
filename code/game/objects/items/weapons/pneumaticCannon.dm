/obj/item/weapon/pneumatic_cannon
	name = "improved-pneumatic cannon"
	desc = "A gas-powered cannon that can fire any object loaded into it."
	w_class = 4
	force = 8 //Very heavy
	attack_verb = list("bludgeoned", "smashed", "beaten")
	icon = 'icons/obj/pneumaticCannon.dmi'
	icon_state = "pneumaticCannon"
	item_state = "bulldog"
	lefthand_file = 'icons/mob/inhands/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/guns_righthand.dmi'
	var/maxWeightClass = 20 //The max weight of items that can fit into the cannon
	var/loadedWeightClass = 0 //The weight of items currently in the cannon
	var/obj/item/weapon/tank/internals/tank = null //The gas tank that is drawn from to fire things
	var/gasPerThrow = 3 //How much gas is drawn from a tank's pressure to fire
	var/list/loadedItems = list() //The items loaded into the cannon that will be fired out
	var/pressureSetting = 1 //How powerful the cannon is - higher pressure = more gas but more powerful throws

/datum/table_recipe/pneumatic_cannon //now you can actually get one
	name = "Improved Pneumatic Cannon"
	result = /obj/item/weapon/pneumatic_cannon
	tools = list(/obj/item/weapon/weldingtool,
				 /obj/item/weapon/wrench)
	reqs = list(/obj/item/stack/sheet/metal = 8,
				/obj/item/pipe = 2,
				/obj/item/weapon/stock_parts/compartmentalizer = 1,
				/obj/item/weaponcrafting/reciever = 1//,
				/*/obj/item/ducttape = 1*/)
	time = 300
	category = CAT_WEAPON

/obj/item/weapon/pneumatic_cannon/examine(mob/user)
	..()
	if(!in_range(user, src))
		user << "<span class='notice'>You'll need to get closer to see any more.</span>"
		return
	for(var/obj/item/I in loadedItems)
		spawn(0)
			user << "<span class='info'>\icon [I] It has \the [I] loaded.</span>"
	if(tank)
		user << "<span class='notice'>\icon [tank] It has \the [tank] mounted onto it.</span>"


/obj/item/weapon/pneumatic_cannon/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(istype(W, /obj/item/weapon/tank/internals/) && !tank)
		if(istype(W, /obj/item/weapon/tank/internals/emergency_oxygen))
			user << "<span class='warning'>\The [W] is too small for \the [src].</span>"
			return
		updateTank(W, 0, user)
		return
	if(istype(W, /obj/item/weapon/wrench))
		switch(pressureSetting)
			if(1)
				pressureSetting = 2
				user << "<span class='notice'>You tweak \the [src]'s pressure output to [pressureSetting].</span>"
			if(2)
				pressureSetting = 3
				user << "<span class='notice'>You tweak \the [src]'s pressure output to [pressureSetting].</span>"
			if(3)
				pressureSetting = 1
				user << "<span class='notice'>You tweak \the [src]'s pressure output to [pressureSetting].</span>"
			else
				user << "<span class='notice'>You probably shouldn't mess with \the [src]'s pressure output.</span>"
		return
	if(istype(W, /obj/item/weapon/screwdriver) && tank)
		updateTank(tank, 1, user)
		return
	if(loadedWeightClass >= maxWeightClass)
		user << "<span class='warning'>\The [src] can't hold any more items!</span>"
		return
	if(istype(W, /obj/item))
		var/obj/item/IW = W
		if((loadedWeightClass + IW.w_class) > maxWeightClass)
			user << "<span class='warning'>\The [IW] won't fit into \the [src]!</span>"
			return
		if(IW.w_class > src.w_class)
			user << "<span class='warning'>\The [IW] is too large to fit into \the [src]!</span>"
			return
		if(!user.unEquip(W))
			return
		user << "<span class='notice'>You load \the [IW] into \the [src].</span>"
		loadedItems.Add(IW)
		loadedWeightClass += IW.w_class
		IW.loc = src
		return


/obj/item/weapon/pneumatic_cannon/afterattack(atom/target as mob|obj|turf, mob/living/carbon/human/user as mob|obj, flag, params)
	if(user.a_intent == "harm" || !ishuman(user))
		return ..()
	if(!loadedItems || !loadedWeightClass)
		user << "<span class='warning'>\The [src] has nothing loaded.</span>"
		return
	if(!tank)
		user << "<span class='warning'>\The [src] can't fire without a source of gas.</span>"
		return
	if(tank && !tank.air_contents.remove(gasPerThrow * pressureSetting))
		user << "<span class='warning'>\The [src] lets out a weak hiss and doesn't react!</span>"
		return
	user.visible_message("<span class='danger'>[user] fires \the [src]!</span>", \
			     "<span class='warning'>You fire \the [src]!</span>")
	add_logs(user, target, "fired at", src)
	playsound(src.loc, 'sound/weapons/sonic_jackhammer.ogg', (50 * pressureSetting), 1)
	for(var/obj/item/ITD in loadedItems) //Item To Discharge
		spawn(0)
			loadedItems.Remove(ITD)
			loadedWeightClass -= ITD.w_class
			ITD.throw_speed = pressureSetting * 2
			ITD.loc = get_turf(src)
			ITD.throw_at(target, pressureSetting * 5, pressureSetting * 2,user)
	if(pressureSetting >= 3)
		user << "<span class='boldannounce'>\The [src]'s recoil knocks you down!</span>"
		user.Weaken(2)


/obj/item/weapon/pneumatic_cannon/ghetto //Obtainable by improvised methods; more gas per use, less capacity, but smaller
	name = "improvised pneumatic cannon"
	desc = "A gas-powered, object-firing cannon made out of common parts."
	force = 5
	w_class = 3
	maxWeightClass = 10
	gasPerThrow = 5

/datum/table_recipe/improvised_pneumatic_cannon //Pretty easy to obtain but
	name = "Pneumatic Cannon"
	result = /obj/item/weapon/pneumatic_cannon/ghetto
	tools = list(/obj/item/weapon/weldingtool,
				 /obj/item/weapon/wrench)
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/packageWrap = 8,
				/obj/item/pipe = 2)
	time = 300
	category = CAT_WEAPON

/obj/item/weapon/pneumatic_cannon/proc/updateTank(obj/item/weapon/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	if (istype(src, /obj/item/weapon/pneumatic_cannon/bluespace))
		return 0
	if(removing)
		if(!src.tank)
			return
		user << "<span class='notice'>You detach \the [thetank] from \the [src].</span>"
		src.tank.loc = get_turf(user)
		user.put_in_hands(tank)
		src.tank = null
	if(!removing)
		if(src.tank)
			user << "<span class='warning'>\The [src] already has a tank.</span>"
			return
		if(!user.unEquip(thetank))
			return
		user << "<span class='notice'>You hook \the [thetank] up to \the [src].</span>"
		src.tank = thetank
		thetank.loc = src
	src.update_icons()

/obj/item/weapon/pneumatic_cannon/proc/update_icons()
	src.overlays.Cut()
	if(!tank)
		return
	src.overlays += image('icons/obj/pneumaticCannon.dmi', "[tank.icon_state]")
	src.update_icon()


//Because adam said so
/obj/item/weapon/pneumatic_cannon/bluespace
	name = "bluespace cannon"
	desc = "An enigmatic, infinitely deep cannon that can fire any object loaded into it. Pulling the trigger will discharge the bluespace compartmentalizer, handle with care."
	w_class = 5
	maxWeightClass = 999999
	gasPerThrow = 0
	obj/item/weapon/tank/internals/tank = 1
	icon_state = "bluespaceCannon"
	pressureSetting = 4

/datum/table_recipe/bluespace_cannon //Pretty easy to obtain but not really!
	name = "Bluespace Cannon"
	result = /obj/item/weapon/pneumatic_cannon/bluespace
	tools = list(/obj/item/weapon/weldingtool/experimental,
				 /obj/item/weapon/wrench)
	reqs = list(/obj/item/stack/sheet/mineral/plasma = 10,
				/obj/item/weapon/pneumatic_cannon = 1,
				/obj/item/weapon/stock_parts/compartmentalizer/bluespace = 1,
				/obj/item/weaponcrafting/reciever = 1//,
				/*/obj/item/ducttape = 1*/)
	time = 300
	category = CAT_WEAPON

/obj/item/weapon/pneumatic_cannon/bluespace/afterattack(atom/target as mob|obj|turf, mob/living/carbon/human/user as mob|obj, flag, params)
	if(user.a_intent == "harm" || !ishuman(user))
		return ..()
	if(!loadedItems || !loadedWeightClass)
		user << "<span class='warning'>\The [src] has nothing loaded.</span>"
		return
	user.visible_message("<span class='danger'>[user] fires \the [src]!</span>", \
			     "<span class='warning'>You fire \the [src]!</span>")
	add_logs(user, target, "fired at", src)
	playsound(src.loc, 'sound/weapons/sonic_jackhammer.ogg', (50 * pressureSetting), 1)
	for(var/obj/item/ITD in loadedItems) //Item To Discharge
		spawn(0)
			loadedItems.Remove(ITD)
			loadedWeightClass -= ITD.w_class
			ITD.throw_speed = pressureSetting * 2
			ITD.loc = get_turf(src)
			ITD.throw_at(target, pressureSetting * 5, pressureSetting * 2,user)
	if(pressureSetting >= 4)
		user << "<span class='boldannounce'>\The [src]'s compartmentalizer churns loudly before discharging, recoil flinging you away like a soggy wad!</span>"
		user.adjustBruteLoss(99)
		var/atom/movable/M = target
		var/atom/throw_target = get_edge_target_turf(M, get_dir(src, get_step_away(src, M)))
		user.throw_at(throw_target, 200, 2)


