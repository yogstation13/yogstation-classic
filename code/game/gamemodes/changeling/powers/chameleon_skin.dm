/obj/item/organ/internal/ability_organ/changeling/chameleon_skin
	name = "chameleon skin"
	desc = "A strange alien gland."
	slot = "chameleon_skin"
	zone = "chest"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/changeling/chameleon_skin)

/obj/effect/proc_holder/resource_ability/changeling/chameleon_skin
	name = "Chameleon Skin"
	desc = "Our skin pigmentation rapidly changes to suit our current environment."
	helptext = "Allows us to become invisible after a few seconds of standing still. Can be toggled on and off."
	dna_cost = 2
	resource_cost = 25
	req_human = 1
	genetic_damage = 10
	max_genetic_damage = 50
	organtype = /obj/item/organ/internal/ability_organ/changeling/chameleon_skin

/obj/effect/proc_holder/resource_ability/changeling/chameleon_skin/sting_action(mob/user)
	//whichever dumbfuck thought this was a good idea forgot the fact that
	//CHANGING A MOB'S DNA HAPPENS VIA TRANSFORM SO GIVING MUTATIONS WHICH APPLY STATIC EFFECTS
	//AND THEN PROVIDING A MEANS TO HARD SWAP DNA WITHOUT REVERSING THESE EFFECTS
	//MEANS DUMB SHIT HAPPENS
	var/mob/living/carbon/human/H = user //SHOULD always be human, because req_human = 1
	if(!istype(H))
		return
	var/datum/mutation/human/HM = mutations_list[CHAMELEON]
	if(H.dna && H.dna.mutations)
		if(HM in H.dna.mutations)
			HM.force_lose(H)
		else
			HM.force_give(H)

	feedback_add_details("changeling_powers","CS")
	return 1


