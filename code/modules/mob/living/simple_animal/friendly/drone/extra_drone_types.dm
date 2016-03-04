
////////////////////
//MORE DRONE TYPES//
////////////////////
//Drones with custom laws
//Drones with custom shells
//Drones with overriden procs


//More types of drones
/mob/living/simple_animal/drone/syndrone
	name = "Syndrone"
	desc = "A modified maintenance drone. This one brings with it the feeling of terror."
	icon_state = "drone_synd"
	icon_living = "drone_synd"
	picked = TRUE //the appearence of syndrones is static, you don't get to change it.
	health = 30
	maxHealth = 120 //If you murder other drones and cannibalize them you can get much stronger
	faction = list("syndicate")
	heavy_emp_damage = 10
	laws = \
	"1. Interfere.\n"+\
	"2. Kill.\n"+\
	"3. Destroy."
	default_storage = /obj/item/device/radio/uplink
	default_hatmask = /obj/item/clothing/head/helmet/space/hardsuit/syndi
	seeStatic = 0 //Our programming is superior.


/mob/living/simple_animal/drone/syndrone/New()
	..()
	if(internal_storage && internal_storage.hidden_uplink)
		internal_storage.hidden_uplink.uses = (initial(internal_storage.hidden_uplink.uses) / 2)
		internal_storage.name = "syndicate uplink"


/mob/living/simple_animal/drone/syndrone/Login()
	..()
	src << "<span class='notice'>You can kill and eat other drones to increase your health!</span>" //Inform the evil lil guy


/obj/item/drone_shell/syndrone
	name = "syndrone shell"
	desc = "A shell of a syndrone, a modified maintenance drone designed to infiltrate and annihilate."
	icon_state = "syndrone_item"
	drone_type = /mob/living/simple_animal/drone/syndrone

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /mob/living/simple_animal/drone/minedrone
 	name = "Mining Drone"
 	desc = "A specialized drone. This type has been created to mine and endure the arduous environment of some asteroids."
 	icon_state = "drone_mine"
 	icon_living = "drone_mine"
 	health = 90
 	maxHealth = 120
 	laws = \
 	"1. You may not in any way shape or form interact with any non-hostile, non-xenobiological life-forms on the asteroid or anywhere else, even in self defense, unless that being is another drone.\n"+\
 	"2. You may not harm or impede any non-xenobiological asteroid creatures, regardless of intent or circumstance.\n"+\
 	"3. Your goals are to mine, harvest, explore, and refine materials to the best of your abilities. You must never actively work against these goals."
 	sight = (SEE_TURFS | SEE_OBJS)
 	see_invisible = SEE_INVISIBLE_MINIMUM
 	picked = TRUE
 	light_on = 1
 	heavy_emp_damage = 20
 	health_repair_max = 0
 	alarms = list()
 	var/obj/item/scanner_storage
 	default_storage = /obj/item/weapon/storage/backpack/drone
 	default_hatmask = /obj/item/clothing/head/helmet/space/hardsuit
 	var/obj/item/scanner = /obj/item/device/t_scanner/adv_mining_scanner
 	seeStatic = 0

 /obj/item/drone_shell/minedrone
 	name = "minedrone shell"
 	desc = "A shell of a mining drone- a specialized drone that has been designed for working in the mines."
 	icon_state = "minedrone_item"
 	drone_type = /mob/living/simple_animal/drone/minedrone

 /mob/living/simple_animal/drone/minedrone/New()
 	..()

 	if(scanner)
 		var/obj/item/I = new scanner(src)
 		equip_to_slot_or_del(I, "internal_storage_2")

 /mob/living/simple_animal/drone/minedrone/Login()
 	..()
 	update_inv_internal_storage_2()

 /mob/living/simple_animal/drone/minedrone/Destroy()
 	qdel(default_storage)
 	qdel(scanner_storage)
 	..()

 /mob/living/simple_animal/drone/minedrone/unEquip(obj/item/I, force)
 	if(..(I,force))
 		update_inv_hands()
 		if(I == scanner_storage)
 			scanner_storage = null
 			update_inv_internal_storage_2()
 		return 1
 	return 0

 /mob/living/simple_animal/drone/minedrone/can_equip(obj/item/I, slot)
 	if (slot == "internal_storage_2")
 		if(scanner_storage)
 			return 0
 		return 1
 	return ..()

 /mob/living/simple_animal/drone/minedrone/get_item_by_slot(slot_id)
 	if (slot_id == "internal_storage_2")
 		return scanner_storage
 	return ..()

 /mob/living/simple_animal/drone/minedrone/equip_to_slot(obj/item/I, slot)
 	if(!slot)	return
 	if(!istype(I))	return

 	if(I == l_hand)
 		l_hand = null
 	else if(I == r_hand)
 		r_hand = null
 	update_inv_hands()

 	I.screen_loc = null
 	I.loc = src
 	I.equipped(src, slot)
 	I.layer = 20

 	if (slot == "internal_storage_2")
 		scanner_storage = I
 		update_inv_internal_storage_2()
 	return ..()

 /mob/living/simple_animal/drone/minedrone/quick_equip()
 	var/obj/item/I = get_active_hand()
 	if(istype(I, /obj/item/device))
 		equip_to_slot(I, "internal_storage_2")
 else ..()