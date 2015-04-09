/obj/item/weapon/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos"
	name = "syndicate minibomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "syndicate"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=4"

/obj/item/weapon/grenade/syndieminibomb/prime()
	if(iscarbon(loc))
		var/mob/living/carbon/meatbag = loc
		if(src in meatbag.internal_organs)
			meatbag.ex_act(1)
	update_mob()
	explosion(src.loc,0,3,5,flame_range = 4)
	qdel(src)