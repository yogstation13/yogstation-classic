/*
	TODO

	* Break glass instead of knocking [DONE]
	* Venting slower
	* Drop clothes [DONE]
	* Give icon

	* Level up predators
	* Multiple predators working together to open doors and break down structures
*/

/mob/living/carbon/human/predator
	name = "predator"
	voice_name = "predator"
	verb_say = "clicks"
	icon = 'icons/mob/human.dmi'
	icon_state = "skeleton_s"
	gender = NEUTER
	languages = predator
	ventcrawler = 0

/mob/living/carbon/human/predator/New()
	..()

	name = text("predator ([rand(1, 1000)])")
	real_name = name
	gender = pick(MALE, FEMALE)

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
