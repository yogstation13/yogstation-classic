/*
Yog Custom
*/

/datum/job/ra
	title = "Recovery Agent"
	flag = RA
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "Nanotrasen officials and Space law"
	selection_color = "#FF0000"
	access = list(access_security, access_sec_doors, access_brig, access_armory, access_forensics_lockers, access_court,
	            access_medical, access_genetics, access_morgue, access_rd,
	            access_tox, access_tox_storage, access_chemistry, access_engine, access_engine_equip, access_maint_tunnels,
	            access_external_airlocks, access_change_ids, access_ai_upload,
	            access_teleporter, access_eva, access_heads, access_captain, access_all_personal_lockers,
	            access_tech_storage, access_chapel_office, access_atmospherics, access_kitchen,
	            access_bar, access_janitor, access_crematorium, access_robotics, access_cargo, access_construction,
	            access_hydroponics, access_library, access_lawyer, access_virology, access_cmo, access_qm, access_surgery,
	            access_theatre, access_research, access_mining, access_mailsorting,
	            access_heads_vault, access_mining_station, access_xenobiology, access_ce, access_hop, access_hos, access_RC_announce,
	            access_keycard_auth, access_tcomsat, access_gateway, access_mineral_storeroom)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_armory, access_forensics_lockers, access_court,
	            access_medical, access_genetics, access_morgue, access_rd,
	            access_tox, access_tox_storage, access_chemistry, access_engine, access_engine_equip, access_maint_tunnels,
	            access_external_airlocks, access_change_ids, access_ai_upload,
	            access_teleporter, access_eva, access_heads, access_captain, access_all_personal_lockers,
	            access_tech_storage, access_chapel_office, access_atmospherics, access_kitchen,
	            access_bar, access_janitor, access_crematorium, access_robotics, access_cargo, access_construction,
	            access_hydroponics, access_library, access_lawyer, access_virology, access_cmo, access_qm, access_surgery,
	            access_theatre, access_research, access_mining, access_mailsorting,
	            access_heads_vault, access_mining_station, access_xenobiology, access_ce, access_hop, access_hos, access_RC_announce,
	            access_keycard_auth, access_tcomsat, access_gateway, access_mineral_storeroom)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		if(H.backbag == 3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/really_black(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hos(H), slot_ears)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/sec/navywarden(H), slot_head)
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		var/obj/item/weapon/implant/tracking/T = new/obj/item/weapon/implant/tracking(H)
		T.imp_in = H
		T.implanted = 1
		return 1


