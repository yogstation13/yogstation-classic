/obj/effect/proc_holder/changeling/horrorform
	name = "Horror Form"
	desc = "We transform into a greater lifeform. We cannot maintain this form forever, though, and will return to normal once we lose our chemicals or sustain enough damage."
	chemical_cost = 0
	dna_cost = 0
	genetic_damage = 0
	req_human = 1
	max_genetic_damage = 0
	var/horrorform = 0


/obj/effect/proc_holder/changeling/horrorform/sting_action(mob/living/user)
	var/datum/changeling/changeling = user.mind.changeling
	if(user.stat || !ishuman(user))
		return
	if(changeling.absorbedcount < 5)
		user << "<span class='warning'>We must absorb five lifeforms before being able to use this ability.</span>"
		return
	if(user.health < 35)
		user << "<span class='warning'>We are too hurt to sustain such power.</span>"
		return
	var/transform_or_no=alert(user,"Are you sure you want to transform?",,"Yes","No")
	switch(transform_or_no)
		if("No")
			user << "<span class='warning'>You opt not to transform."
			return
		if("Yes")
			user.Stun(INFINITY)

			for(var/obj/item/I in user) //drops all items
				user.unEquip(I)
			user.visible_message("<span class='warning'>[user]'s body contorts unnaturally and they slip out of their clothes!</span>")
			user <<"<span class='warning'>You contort your body and drop any restrictive clothing.</span>"
			sleep(40)

			playsound(user.loc, 'sound/effects/creepyshriek.ogg', 100, 1, extrarange = 30)
			user.visible_message("<span class='warning'><b>[user] lets out an abhorrent screech as their height suddenly increases, their body parts splitting and deforming horribly!</span>")
			user <<"<span class='notice'>You are a shambling abomination! You are amazingly powerful and have new abilities, but you cannot use any other changeling abilities and lose chemicals extremely quickly. Remember, taking too much damage or running out of chemicals will revert you and leave you vulnerable. Check the 'Abomination' spell tab to use your abilities.</span>"
			var/mob/living/carbon/human/H = user
			H.underwear = "Nude"
			H.undershirt = "Nude"
			H.socks = "Nude"
			var/newNameId = "Shambling Abomination"
			user.real_name = newNameId
			user.name = usr.real_name
			user.SetStunned(0)
			for(var/obj/item/I in user) //in case any weird stuff happens with flesh clothing
				qdel(I)
			user.equip_to_slot_or_del(new /obj/item/clothing/shoes/abomination(user), slot_shoes)
			user.equip_to_slot_or_del(new /obj/item/clothing/suit/abomination(user), slot_wear_suit)
			user.equip_to_slot_or_del(new /obj/item/clothing/head/abomination(user), slot_head)
			user.equip_to_slot_or_del(new /obj/item/clothing/gloves/abomination(user), slot_gloves)
			user.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/abomination(user), slot_wear_mask)
			hardset_dna(user, null, null, null, null, /datum/species/abomination)
			changeling.chem_recharge_slowdown = 6

//horrorform vision
			H.weakeyes = 1
			H.sight |= SEE_MOBS
			H.permanent_sight_flags |= SEE_MOBS
			H.see_in_dark = 8
			H.dna.species.invis_sight = SEE_INVISIBLE_MINIMUM

//hulk
			var/datum/mutation/human/HM = mutations_list[HULK]
			if(H.dna && H.dna.mutations)
				HM.force_give(H)

//spells
				user.mind.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/screech
				user.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/abom_fleshmend
				user.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/devour
				user.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/abom_revert

//forced reversion

/datum/species/abomination/spec_life(mob/living/carbon/human/user)
	var/datum/changeling/changeling = user.mind.changeling
	if(user.health < 35)
		user.visible_message("<span class='warning'>[user] sustains too much damage to continue their transformation, and collapses!</span>")
		user << "<span class='notice'>You could not transform back correctly, which disfigures you and scrambles your genetic code!</span>"
		changeling.geneticdamage = 50
		var/newNameId = "Unknown"
		user.real_name = newNameId
		for(var/obj/item/I in user)
			qdel(I)
		changeling.chem_recharge_slowdown = 0
		hardset_dna(user, null, null, null, null, /datum/species/human)
		var/mob/living/carbon/human/H = user
		var/datum/mutation/human/HM = mutations_list[HULK]
		if(H.dna && H.dna.mutations)
			HM.force_lose(H)
		user.apply_damage(10, CLONE)
		user.Weaken(20)
		user.spellremove(user)
		user.weakeyes = 0
		user.sight &= ~SEE_MOBS
		user.permanent_sight_flags &= ~SEE_MOBS
		user.see_in_dark = 0
		user.dna.species.invis_sight = initial(user.dna.species.invis_sight)

	if(changeling.chem_charges == 0)
		user.visible_message("<span class='warning'>[user] suddenly shrinks back down to a normal size.</span>")
		user << "<span class='notice'>You ran out of chemicals before you could revert properly, disfiguring you!</span>"
		changeling.geneticdamage = 20
		var/newNameId = "Unknown"
		user.real_name = newNameId
		for(var/obj/item/I in user)
			qdel(I)
		changeling.chem_recharge_slowdown = 0
		hardset_dna(user, null, null, null, null, /datum/species/human)
		var/mob/living/carbon/human/H = user
		var/datum/mutation/human/HM = mutations_list[HULK]
		if(H.dna && H.dna.mutations)
			HM.force_lose(H)
		user.Weaken(10)
		user.spellremove(user)
		user.weakeyes = 0
		user.sight &= ~SEE_MOBS
		user.permanent_sight_flags &= ~SEE_MOBS
		user.see_in_dark = 0
		user.dna.species.invis_sight = initial(user.dna.species.invis_sight)








	feedback_add_details("changeling_powers","HF")
	return 1