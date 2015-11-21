/obj/item/medical/bandage
	name = "Bandage"
	desc = "A generic bandage of unknown origin and use. What does it cover? Is it a trendy accessory? Will I ever know?."
	icon = 'icons/obj/items.dmi'
	icon_state = "improv_bandage"
	var/healtype = "brute" //determines what damage type the item heals
	var/healamount = 70 //determines how much it heals OVERALL (over duration)
	var/staunch_bleeding = 600 //does it stop bleeding and if so, how much?
	var/duration = 40 //duration in ticks of healing effect (these roughly equate to 1.5s each)
	var/activefor = 1
	var/used = 0 //has the bandage been used or not?
	var/obj/item/organ/limb/healing_limb = null
	//bandages unwrap bloodied after the duration ends and fall to the floor with the user's blood on them

/obj/item/medical/bandage/proc/handle_bandage(mob/living/carbon/human/H)
	//handles bandage healing per tick, called in life
	if (!src.used)
		if (src.healing_limb && src.healing_limb.status == ORGAN_ORGANIC)
			var/success = 0
			switch (src.healtype)
				if ("brute")
					success = src.healing_limb.heal_damage(src.healamount/src.duration, 0, 0)
				if ("burn")
					success = src.healing_limb.heal_damage(0, src.healamount/src.duration, 0)
			if (success)
				H.update_damage_overlays(0)
			if (src.staunch_bleeding && !H.bleedsuppress)
				H.suppress_bloodloss(src.staunch_bleeding)
			if (src.activefor <= src.duration)
				src.activefor += 1
			else
				src.used = 1
	else
		//eject the bandage onto the floor with
		H << "You loosen the bandage around [healing_limb.name] and let it fall to the floor, its usefulness spent."
		src.name = "used [src.name]"
		src.desc = "Bloodied and crusted, these bandages have clearly been used and aren't fit for much anymore."
		src.color = "red"
		src.loc = H.loc
		H.bandaged = 0

/obj/item/medical/bandage/proc/apply(mob/living/user, mob/tar, obj/item/organ/limb/lt)
	var/mob/living/carbon/human/temphuman
	if (!ishuman(user))
		user << "<span class='warning'>You don't have the dexterity to use this!</span>"
		return 0

	if (ishuman(tar))
		temphuman = tar
		if (!temphuman.bandaged)
			if (user == tar)
				user.visible_message("<span class='notice'>[user] begins winding [src] about their [lt.name]..</span>", "<span class='notice'>You begin winding [src] around your [lt.name]..</span>")
			else
				user.visible_message("<span class='notice'>[user] begins winding [src] about [tar]'s [lt.name]..</span>", "<span class='notice'>You begin winding [src] around [tar]'s [lt.name]..</span>")

			if (do_after(user, 50, target = tar))
				if(!user.drop_item())
					return 0
				src.blood_DNA = temphuman.dna.unique_enzymes
				src.healing_limb = lt
				temphuman.bandaged = src
				src.loc = temphuman
				user.visible_message("[user] has applied [src] successfully.", "You have applied [src] successfully.")
				return 1
			else
				src.loc = temphuman.loc
				user.visible_message("<span class='warning'>Interrupted, [user] fumbles and drops [src] to the floor!</span>", "<span class='warning'>Losing your concentration, you find yourself unable to apply [src] and let it slip through your fingers to pool upon the floor!</span>")
				return 0
		else
			user << "[tar] is already bandaged for the moment."
			return 0
	else
		user << "This doesn't look like it'll work."
		return 0

/obj/item/medical/bandage/proc/wash(obj/O, mob/user)
	if (src.used)
		user << "You clean [src] fastidiously washing away as much of the detritus and residue as you can. The bandage can probably be used again now."
		src.name = "reused bandages"
		src.desc = "Whatever quality these bandages once were, there's no sign of it any more. Not like the wounds you put this stuff over care, though."
		src.healamount = src.healamount * 0.85
		src.duration = src.duration * 1.15
		src.activefor = 1
		src.blood_DNA = 0
		src.color = 0
		src.used = 0
	else
		user << "There's no real need to wash this - it's perfectly clean!"

/obj/item/medical/bandage/attack(mob/living/carbon/human/T, mob/living/carbon/human/U)
	if (src.used)
		U << "These bandages have already been used. They're worthless as they are. Maybe if they had the blood washed out of them with running water?"
		return
	else
		src.apply(U, T, T.get_organ(check_zone(U.zone_sel.selecting)))
		return

/obj/item/medical/bandage/improvised
	name = "improvised bandage"
	desc = "A primitive bandage fashioned from some torn cloth and leftover elastic. Will do in a pinch, but is nowhere near as effective as actual medical-grade bandages."
	healtype = "brute"
	healamount = 40
	duration = 120
	staunch_bleeding = 240

/obj/item/medical/bandage/improvised_soaked
	name = "soaked improvised bandage"
	desc = "Primitive bandage thoroughly soaked in water, Probably decent for a burn wound, but definitely isn't sterile. Useless at stopping bleeding."
	healtype = "burn"
	healamount = 40
	duration = 120
	staunch_bleeding = 0

/obj/item/medical/bandage/destitute
	name = "beggar's bandage"
	desc = "Aptly named. These tattered shreds of cloth look about as useful as their namesake."
	healamount = 15
	duration = 120
	staunch_bleeding = 120

/obj/item/medical/bandage/quality
	name = "RB-ST brand medicinal bandages"
	desc = "Quality bandages with a novel toolbox-icon weave. Comes with a polymer stabilizing agent built into the fabric to stiffen and secure broken limbs. Smells like cough syrup and pine needles."
	color = "blue"
	healamount = 90
	duration = 35
	staunch_bleeding = 1200
