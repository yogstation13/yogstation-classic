
/mob/living/carbon/human/predator
	name = "predator"
	voice_name = "predator"
	verb_say = "clicks"
	icon = 'icons/mob/human.dmi'
	icon_state = "pred_s"
	languages_understood = PREDATOR
	languages_spoken = PREDATOR
	gender = NEUTER
	ventcrawler = 0

/mob/living/carbon/human/predator/New()
	..()

	name = text("predator ([rand(1, 1000)])")
	real_name = name
	icon_state = "pred_s"
	hair_color = "000"
	hair_style = "Bald"
	facial_hair_color = "000"
	facial_hair_style = "Shaved"
	update_hair()

	equip_to_slot_if_possible(new /obj/item/clothing/head/helmet/space/hardsuit/predator, slot_head)
	equip_to_slot_if_possible(new /obj/item/clothing/suit/space/hardsuit/predator, slot_wear_suit)
	equip_to_slot_if_possible(new /obj/item/clothing/under/predator, slot_w_uniform)
	equip_to_slot_if_possible(new /obj/item/weapon/shuriken, slot_l_store)
	equip_to_slot_if_possible(new /obj/item/weapon/twohanded/spear/combistick, slot_r_store)

/proc/is_predator(mob/user)
	if(istype(user, /mob/living/carbon/human/predator))
		return 1
	else
		return 0

/mob/living/carbon/human/predator/Stat()
	..()
	statpanel("Status")
	stat(null, text("Intent: []", a_intent))
	stat(null, text("Move Mode: []", m_intent))
	return

/mob/living/carbon/human/predator/IsAdvancedToolUser()
	return 1

/mob/living/carbon/human/predator/canBeHandcuffed()
	return 1

/mob/living/carbon/human/predator/assess_threat(var/obj/machinery/bot/secbot/judgebot, var/lasercolor)

/mob/living/carbon/human/predator/say(message, bubble_type)
	return ..(message, bubble_type)

/mob/living/carbon/human/predator/say_quote(var/text)
	return "[verb_say], \"[text]\"";
