/mob/living/carbon/human/attack_hulk(mob/living/carbon/human/user)
	var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
	var/obj/item/organ/limb/affecting = get_organ(ran_zone(dam_zone))
	if(user.a_intent == "harm")
		..(user, 1)
		apply_damage(15, BRUTE, affecting, run_armor_check(affecting, "melee"))
		//Weaken(4)

/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
	if(..())	//to allow surgery to return properly.
		return

	if(dna)
		dna.species.spec_attack_hand(M, src)

	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return