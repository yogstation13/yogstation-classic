/obj/effect/proc_holder/changeling/sting
	name = "Tiny Prick"
	desc = "Stabby stabby"
	var/sting_icon = null

/obj/effect/proc_holder/changeling/sting/Click()
	var/mob/user = usr
	if(!user || !user.mind || !user.mind.changeling)
		return
	if(!(user.mind.changeling.chosen_sting))
		set_sting(user)
	else
		unset_sting(user)
	return

/obj/effect/proc_holder/changeling/sting/proc/set_sting(mob/user)
	user << "<span class='notice'>We prepare our sting, use alt+click or middle mouse button on target to sting them.</span>"
	user.mind.changeling.chosen_sting = src
	user.hud_used.lingstingdisplay.icon_state = sting_icon
	user.hud_used.lingstingdisplay.invisibility = 0

/obj/effect/proc_holder/changeling/sting/proc/unset_sting(mob/user)
	user << "<span class='warning'>We retract our sting, we can't sting anyone for now.</span>"
	user.mind.changeling.chosen_sting = null
	user.hud_used.lingstingdisplay.icon_state = null
	user.hud_used.lingstingdisplay.invisibility = 101

/mob/living/carbon/proc/unset_sting()
	if(mind && mind.changeling && mind.changeling.chosen_sting)
		src.mind.changeling.chosen_sting.unset_sting(src)

/obj/effect/proc_holder/changeling/sting/can_sting(mob/user, mob/target)
	if(!..())
		return
	if(!user.mind.changeling.chosen_sting)
		user << "We haven't prepared our sting yet!"
	if(!iscarbon(target))
		return
	if(!isturf(user.loc))
		return
	if(get_dist(user, target) > (user.mind.changeling.sting_range))
		return //sanity check as AStar is still throwing insane stunts
	if(!AStar(user.loc, target.loc, null, /turf/proc/Distance, user.mind.changeling.sting_range))
		return //hope this ancient magic still works
	if(target.mind && target.mind.changeling)
		sting_feedback(user,target)
		take_chemical_cost(user.mind.changeling)
		return
	return 1

/obj/effect/proc_holder/changeling/sting/sting_feedback(mob/user, mob/target)
	if(!target)
		return
	user << "<span class='notice'>We stealthily sting [target.name].</span>"
	if(target.mind && target.mind.changeling)
		target << "<span class='warning'>You feel a tiny prick.</span>"
	return 1


/obj/effect/proc_holder/changeling/sting/transformation
	name = "Transformation Sting"
	desc = "We silently sting a human, injecting a retrovirus that forces them to transform."
	helptext = "The victim will transform much like a changeling would. The effects will be obvious to the victim, and the process will damage our genomes."
	sting_icon = "sting_transform"
	chemical_cost = 40
	dna_cost = 3
	genetic_damage = 100
	//var/datum/dna/selected_dna = null
	var/datum/changelingprofile/selected_dna = null

/obj/effect/proc_holder/changeling/sting/transformation/Click()
	var/mob/user = usr
	var/datum/changeling/changeling = user.mind.changeling
	if(changeling.chosen_sting)
		unset_sting(user)
		return
	selected_dna = changeling.select_dna("Select the target DNA: ", "Target DNA")
	if(!selected_dna)
		return
	..()

/obj/effect/proc_holder/changeling/sting/transformation/can_sting(mob/user, mob/target)
	if(!..())
		return
	if((target.disabilities & HUSK) || !check_dna_integrity(target))
		user << "<span class='warning'>Our sting appears ineffective against its DNA.</span>"
		return 0
	return 1

/obj/effect/proc_holder/changeling/sting/transformation/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "transformation sting", " new identity is [selected_dna.dna.real_name]")
	var/datum/dna/NewDNA = selected_dna.dna
	if(ismonkey(target))
		user << "<span class='notice'>Our genes cry out as we sting [target.name]!</span>"

	if(iscarbon(target) && (target.status_flags & CANWEAKEN))
		var/mob/living/carbon/C = target
		C.do_jitter_animation(500)
		C.take_organ_damage(20, 0) //The process is extremely painful

	target.visible_message("<span class='danger'>[target] begins to violenty convulse!</span>","<span class='userdanger'>You feel a tiny prick and a begin to uncontrollably convulse!</span>")
	spawn(10)
		hardset_dna(target, NewDNA.uni_identity, NewDNA.struc_enzymes, NewDNA.real_name, NewDNA.blood_type, NewDNA.species.type, NewDNA.features)
		if(ishuman(target))
			var/mob/living/carbon/human/T = target
			//Setting manually, because updateappearance() doesn't seem to properly make cosmetic changes based on DNA
			T.gender = selected_dna.gender
			T.skin_tone = selected_dna.skin_tone
			T.hair_color = selected_dna.hair_color
			T.hair_style = selected_dna.hair_style
			T.facial_hair_color = selected_dna.facial_hair_color
			T.facial_hair_style = selected_dna.facial_hair_style
			T.eye_color = selected_dna.eye_color
			T.features = selected_dna.features
			T.update_body()
			T.update_hair()
		else //Fallback option for non humans
			updateappearance(target)
	feedback_add_details("changeling_powers","TS")
	return 1


/*/obj/effect/proc_holder/changeling/sting/false_armblade
	name = "False Armblade Sting"
	desc = "We silently sting a human, injecting a retrovirus that mutates their arm to temporarily appear as an armblade."
	helptext = "The victim will form an armblade much like a changeling would, except the armblade is dull and useless."
	sting_icon = "sting_armblade"
	chemical_cost = 20
	dna_cost = 1
	genetic_damage = 20
	max_genetic_damage = 10

/obj/item/weapon/melee/arm_blade/false
	desc = "A grotesque mass of flesh that used to be your arm. Although it looks dangerous at first, you can tell it's actually quite dull and useless."
	force = 5 //Basically as strong as a punch

/obj/item/weapon/melee/arm_blade/false/afterattack(atom/target, mob/user, proximity)
	return

/obj/effect/proc_holder/changeling/sting/false_armblade/can_sting(mob/user, mob/target)
	if(!..())
		return
	if((target.disabilities & HUSK) || !check_dna_integrity(target))
		user << "<span class='warning'>Our sting appears ineffective against its DNA.</span>"
		return 0
	return 1

/obj/effect/proc_holder/changeling/sting/false_armblade/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", object="false armblade sting")

	if(!target.drop_item())
		user << "<span class='warning'>The [target.get_active_hand()] is stuck to their hand, you cannot grow a false armblade over it!</span>"
		return

	if(ismonkey(target))
		user << "<span class='notice'>Our genes cry out as we sting [target.name]!</span>"

	var/obj/item/weapon/melee/arm_blade/false/blade = new(target,1)
	target.put_in_hands(blade)
	target.visible_message("<span class='warning'>A grotesque blade forms around [target.name]\'s arm!</span>", "<span class='userdanger'>Your arm twists and mutates, transforming into a horrific monstrosity!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
	playsound(target, 'sound/effects/blobattack.ogg', 30, 1)

	spawn(600)
		playsound(target, 'sound/effects/blobattack.ogg', 30, 1)
		target.visible_message("<span class='warning'>With a sickening crunch, [target] reforms their [blade.name] into an arm!</span>", "<span class='warning'>[blade] reforms back to normal.</span>", "<span class='italics>You hear organic matter ripping and tearing!</span>")
		qdel(blade)
		user.update_inv_l_hand()
		user.update_inv_r_hand()

	feedback_add_details("changeling_powers","AS")
	return 1*/


/obj/effect/proc_holder/changeling/sting/extract_dna
	name = "Extract DNA Sting"
	desc = "We stealthily sting a target and extract their DNA."
	helptext = "Will give you the DNA of your target, allowing you to transform into them."
	sting_icon = "sting_extract"
	chemical_cost = 25
	dna_cost = 0

/obj/effect/proc_holder/changeling/sting/extract_dna/can_sting(mob/user, mob/target)
	if(..())
		return user.mind.changeling.can_absorb_dna(user, target)

/obj/effect/proc_holder/changeling/sting/extract_dna/sting_action(mob/user, mob/living/carbon/human/target)
	add_logs(user, target, "stung", "extraction sting")
	if((user.mind.changeling.has_dna(target.dna)))
		user.mind.changeling.remove_profile(target)
		user.mind.changeling.absorbedcount--
	user.mind.changeling.add_profile(target, user)
	feedback_add_details("changeling_powers","ED")
	return 1

/obj/effect/proc_holder/changeling/sting/mute
	name = "Mute Sting"
	desc = "We silently sting a human, completely silencing them for a short time."
	helptext = "Does not provide a warning to the victim that they have been stung, until they try to speak and cannot."
	sting_icon = "sting_mute"
	chemical_cost = 20
	dna_cost = 2

/obj/effect/proc_holder/changeling/sting/mute/sting_action(mob/user, mob/living/carbon/target)
	add_logs(user, target, "stung", "mute sting")
	if(target.reagents)
		target.reagents.add_reagent("mutetoxin", 15)
	feedback_add_details("changeling_powers","MS")
	return 1

/obj/effect/proc_holder/changeling/sting/blind
	name = "Blind Sting"
	desc = "Temporarily blinds the target."
	helptext = "This sting completely blinds a target for a short time."
	sting_icon = "sting_blind"
	chemical_cost = 25
	dna_cost = 1

/obj/effect/proc_holder/changeling/sting/blind/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "blind sting")
	target << "<span class='danger'>Your eyes burn horrifically!</span>"
	target.disabilities |= NEARSIGHT
	target.eye_blind = 20
	target.eye_blurry = 40
	feedback_add_details("changeling_powers","BS")
	return 1

/obj/effect/proc_holder/changeling/sting/hallucinationpathogen
	name = "Hallucinogenic Pathogen Sting"
	desc = "Unleashes a potent hallucinogenic pathogen upon the crew."
	helptext = "We invite a pathogenic genome to take residence in our target, rendering them a host to a virulent hallucinogenic disease that is transmissable by air."
	sting_icon = "sting_lsd"
	chemical_cost = 50
	dna_cost = 5

/obj/effect/proc_holder/changeling/sting/hallucinationpathogen/sting_action(mob/user, mob/living/carbon/target)
	add_logs(user, target, "stung", "hallucination pathogen")
	spawn(rand(300,600))
		if(target)
			if(!target.resistances.Find(/datum/disease/lingvirus))
				var/datum/disease/welp = new /datum/disease/lingvirus(0)
				target.ContractDisease(welp)
	feedback_add_details("changeling_powers","HS")
	return 1

/*
/obj/effect/proc_holder/changeling/sting/stamina
	name = "Enfeebling Sting"
	desc = "Exhausts, then causes the victim to collapse for a medium duration."
	helptext = "We secrete and administer a potent exhausting toxin to our victim, sapping them of their strength, before rendering them unconscious. The toxin is difficult to maintain, and infecting a target with it will damage our genomes slightly."
	sting_icon = "sting_cryo"
	chemical_cost = 30
	dna_cost = 2
	genetic_damage = 50

/obj/effect/proc_holder/changeling/sting/stamina/sting_action(mob/user, mob/target)
	target << "<span class='danger'>You feel a tiny prick.</span>"
	add_logs(user, target, "stung", "knockout sting")
	if(target.reagents)
		target.reagents.add_reagent("tirizene", 22)
	feedback_add_details("changeling_powers", "KS")
	return 1


/obj/effect/proc_holder/changeling/sting/cryo
	name = "Cryogenic Sting"
	desc = "We silently sting a human with a cocktail of chemicals that freeze them."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing."
	sting_icon = "sting_cryo"
	chemical_cost = 15
	dna_cost = 2

/obj/effect/proc_holder/changeling/sting/cryo/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", "cryo sting")
	if(target.reagents)
		target.reagents.add_reagent("frostoil", 30)
	feedback_add_details("changeling_powers","CS")
	return 1*/