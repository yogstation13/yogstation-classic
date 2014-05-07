/*
Yog Custom
*/

/datum/job/ra
	title = "Recovery Agent"
	flag = RA
	department_head = list("Captain")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain and Space Law. Failure to comply with the Law will result in immediate contract termination"
	selection_color = "#FF0000"
	req_admin_notify = 1
	minimal_player_age = 14
	whitelisted = 1

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

	default_pda_slot = slot_l_store
	default_id = /obj/item/weapon/card/id/gold
	default_backpack = /obj/item/weapon/storage/backpack/security
	default_satchel = /obj/item/weapon/storage/backpack/satchel_sec

/datum/job/ra/equip_items(var/mob/living/carbon/human/H)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/really_black(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/navywarden(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/device/radio/security(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun(H), slot_belt)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/bodybags(H), slot_l_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/bodybags(H.back), slot_in_backpack)

	//Implant him
	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1

	var/obj/item/weapon/implant/tracking/T = new/obj/item/weapon/implant/tracking(H)
	T.imp_in = H

/datum/job/ra/get_access()
	return get_all_accesses()

