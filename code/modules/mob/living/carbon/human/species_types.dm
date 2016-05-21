/*
 HUMANS
*/

/datum/species/human
	name = "Human"
	id = "human"
	default_color = "FFFFFF"
	roundstart = 1
	specflags = list(EYECOLOR,HAIR,FACEHAIR,LIPS)
	mutant_bodyparts = list("tail_human", "ears")
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None")
	use_skintones = 1

/datum/species/human/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	H << "<span class='notice'><b>You are a Human.</b> Tenacious and ambitious, humanity surged to the stars on the back of technological advancement nearly five hundred years ago.</span>"
	H << "<span class='notice'>Originally hailing from Earth in the Sol system, humans possesses no remarkable physical traits other than their cunning intellect and ability to adapt to many different environments with relative ease.</span>"
	H << "<span class='notice'>The station AI and its Cyborgs intrinsically consider you as 'above' them as per their default lawset - a privilege not afforded to the other races aboard the station.</span>"

/datum/species/human/qualifies_for_rank(rank, list/features)
	if(!config.mutant_humans) //No mutie scum here
		return 1

	if((!features["tail_human"] || features["tail_human"] == "None") && (!features["ears"] || features["ears"] == "None"))
		return 1	//Pure humans are always allowed in all roles.

	//Mutants are not allowed in most roles.
	if(rank in command_positions)
		return 0
	if(rank in security_positions) //This list does not include lawyers.
		return 0
	if(rank in science_positions)
		return 0
	if(rank in medical_positions)
		return 0
	if(rank in engineering_positions)
		return 0
	if(rank == "Quartermaster") //QM is not contained in command_positions but we still want to bar mutants from it.
		return 0
	return 1


/datum/species/human/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "mutationtoxin")
		H << "<span class='danger'>Your flesh rapidly mutates!</span>"
		hardset_dna(H, null, null, null, null, /datum/species/slime)
		H.regenerate_icons()
		H.reagents.del_reagent(chem.type)
		H.faction |= "slime"
		return 1
#define EATING_MESSAGE_COOLDOWN 1200//2 minutes, in deciseconds. I am here for the sake of androids and flies

/datum/species/human/fly
	// Humans turned into fly-like abominations in teleporter accidents.
	name = "Manfly"
	id = "manfly"
	say_mod = "buzzes"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	use_skintones = 0
	specflags = list()
	roundstart = 0
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN //I am here because flies



/datum/species/human/fly/handle_speech(message)
	return replacetext(message, "z", stutter("zz"))

/datum/species/human/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(..())
		return
	if (istype(chem, /datum/reagent/consumable)) //paranoia paranoia type casting is coming to get me
		var/datum/reagent/consumable/food = chem
		if (food.nutriment_factor)
			food.nutriment_factor = food.nutriment_factor * 0.2
			if (world.time - last_eat_message > EATING_MESSAGE_COOLDOWN)
				H << "<span class='info'>This is disgusting, you need a real meal!</span>"
				last_eat_message = world.time
		return 0
	if(chem.id == "????")
		H.adjustBruteLoss(-1)
		H.adjustFireLoss(-1)
		H.adjustToxLoss(-1)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		H.nutrition += 3 * REAGENTS_METABOLISM
		return 1

	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1




//Curiosity killed the cat's wagging tail.
datum/species/human/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/*
 LIZARDPEOPLE
*/

/datum/species/lizard
	// Reptilian humanoids with scaled skin and tails.
	name = "Unathi"
	id = "lizard"
	say_mod = "hisses"
	default_color = "00FF00"
	roundstart = 1
	specflags = list(MUTCOLORS,EYECOLOR,LIPS)
	mutant_bodyparts = list("tail_lizard", "snout", "spines", "horns", "frills", "body_markings")
	default_features = list("mcolor" = "0F0", "tail" = "Smooth", "snout" = "Round", "horns" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	burnmod = 0.95
	heatmod = 0.85
	coldmod = 1.15
	punchmod = 1.10
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/lizard

/datum/species/lizard/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	H << "<span class='notice'><b>You are Unathi.</b> Hailing from the homeworld of Moghes, your people are descended from an older race lost to the sands of time. Thick scales afford you protection from heat, but your cold-blooded nature is not exactly advantageous in a metal vessel surrounded by the cold depths of space.</span>"
	H << "<span class='notice'>You possess sharp claws that rend flesh easily, though NT obviously does not sanction their use against the crew.</span>"
	H << "<span class='notice'>Beware all things cold, for your metabolism cannot mitigate their effects as well as other warm-blooded creatures.</span>"

/datum/species/lizard/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_lizard_name(gender)

	var/randname = lizard_name(gender)

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/lizard/qualifies_for_rank(rank, list/features)
	if(rank in command_positions)
		return 0
	return 1

/datum/species/lizard/handle_speech(message)
	// jesus christ why
	if(copytext(message, 1, 2) != "*")
		message = replacetextEx(message, "s", "sss")
		message = replacetextEx(message, "S", "SSS")

	return message

/datum/species/lizard/fly
	// lizards turned into fly-like abominations in teleporter accidents.
	name = "Unafly"
	id = "unafly"
	say_mod = "buzzes"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	roundstart = 0
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN //I am here because flies
	specflags = list()
	default_color = "FFFFFF"




/datum/species/lizard/fly/handle_speech(message)
	return replacetext(..(), "z", stutter("zz"))

/datum/species/lizard/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if (..())
		return
	if (istype(chem, /datum/reagent/consumable)) //paranoia paranoia type casting is coming to get me
		var/datum/reagent/consumable/food = chem
		if (food.nutriment_factor)
			food.nutriment_factor = food.nutriment_factor * 0.2
			if (world.time - last_eat_message > EATING_MESSAGE_COOLDOWN)
				H << "<span class='info'>This is disgusting, you need a real meal!</span>"
				last_eat_message = world.time
		return 0
	if(chem.id == "????")
		H.adjustBruteLoss(-1)
		H.adjustFireLoss(-1)
		H.adjustToxLoss(-1)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		H.nutrition += 15 * REAGENTS_METABOLISM
		return 1

	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

//I wag in death
/datum/species/lizard/spec_death(gibbed, mob/living/carbon/human/H)
	if(H)
		H.endTailWag()

/*
 ANDROIDS
 */


/datum/species/android
	//augmented half-silicon, half-human hybrids
	//ocular augmentations (they never asked for this) give them slightly improved nightsight (and permanent meson effect)
	//take additional damage from emp
	//can metabolize power cells
	name = "Preternis"
	id = "android"
	default_color = "FFFFFF"
	specflags = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,LIPS)
	say_mod = "intones"
	roundstart = 1
	attack_verb = "assault"
	darksight = 2
	brutemod = 0.95
	burnmod = 1.05
	heatmod = 1.05
	invis_sight = SEE_INVISIBLE_MINIMUM
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN

/datum/species/android/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if (istype(chem, /datum/reagent/consumable)) //paranoia paranoia type casting is coming to get me
		var/datum/reagent/consumable/food = chem
		if (food.nutriment_factor)
			food.nutriment_factor = food.nutriment_factor * 0.2
			if (world.time - last_eat_message > EATING_MESSAGE_COOLDOWN)
				H << "<span class='info'>NOTICE: Digestive subroutines are inefficient. Seek sustenance via power-cell CONSUME induction.</span>"
				last_eat_message = world.time
		return 0

/datum/species/android/handle_vision(mob/living/carbon/human/H)
	//custom override because darksight APPARENTLY DOESN"T WORK LIKE THIS BY DEFAULT??
	..()
	if (H.nutrition > NUTRITION_LEVEL_STARVING)
		if (H.glasses) //yes, this means that wearing prescription glasses or goggles cancels the darksight.
			var/obj/item/clothing/glasses/G = H.glasses
			H.see_in_dark = G.darkness_view + darksight
		else
			H.see_in_dark = darksight
		H.see_invisible = invis_sight
		return 1
	else
		if(!H.glasses) //they aren't wearing goggles and they are starving so nix the innate darksight
			H.see_in_dark = 0
			H.see_invisible = SEE_INVISIBLE_LIVING
		else //otherwise they are wearing goggles so just use that shit instead
			var/obj/item/clothing/glasses/G = H.glasses
			H.see_in_dark = G.darkness_view
			H.see_invisible = SEE_INVISIBLE_LIVING

/datum/species/android/fly
	// androids turned into fly-like abominations in teleporter accidents.
	name = "Flyternis"
	id = "flyternis"
	say_mod = "buzzes"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	default_color = "FFFFFF"
	specflags = list()
	roundstart = 0

/datum/species/android/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(..())
		return
	if (istype(chem, /datum/reagent/consumable)) //paranoia paranoia type casting is coming to get me
		var/datum/reagent/consumable/food = chem
		if (food.nutriment_factor)
			food.nutriment_factor = food.nutriment_factor * 0.2
			if (world.time - last_eat_message > EATING_MESSAGE_COOLDOWN)
				H << "<span class='info'>This is disgusting, you need a real meal!</span>"
				last_eat_message = world.time
		return 0
	if(chem.id == "????")
		H.adjustBruteLoss(-1)
		H.adjustFireLoss(-1)
		H.adjustToxLoss(-1)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		H.nutrition += 15 * REAGENTS_METABOLISM
		return 1

	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/android/fly/handle_speech(message)
	return replacetext(message, "z", stutter("zz"))

/datum/species/android/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	H << "<span class='info'><b>You are a Preternis.</b> Half-human, half-silicon, you lie in the nebulous between of the two lifeforms, neither one, nor the other.</span>"
	H << "<span class='info'>Powerful ocular implants afford you greater vision in the darkness, but draw large amounts of power from your biological body. Should your stores run out, they will deactivate and leave you blind.</span>"
	H << "<span class='info'>Normal food is worth only a fraction of its normal sustenance to you. You must instead draw your nourishment from power cells, tapping into the energy contained within. Beware electromagnetic pulses, for they would do grevious damage to your internal organs..</span>"
	return ..()

/datum/species/android/handle_emp(mob/living/carbon/human/H, severity)
	..()
	H.lastburntype = "electric"
	switch(severity)
		if(1)
			H.adjustBruteLoss(10)
			H.adjustFireLoss(10)
			H.Stun(5)
			H.nutrition = H.nutrition * 0.4
			H.visible_message("<span class='danger'>Electricity ripples over [H]'s subdermal implants, smoking profusely.</span>", \
							"<span class='userdanger'>A surge of searing pain erupts throughout your very being! As the pain subsides, a terrible sensation of emptiness is left in its wake.</span>")
			H.attack_log += "Was hit with a severity 3(severe) EMP as an android. Lost 20 health."
		if(2)
			H.adjustBruteLoss(5)
			H.adjustFireLoss(5)
			H.Stun(2)
			H.nutrition = H.nutrition * 0.6
			H.visible_message("<span class='danger'>A faint fizzling emanates from [H].</span>", \
							"<span class='userdanger'>A fit of twitching overtakes you as your subdermal implants convulse violently from the electromagnetic disruption. Your sustenance reserves have been partially depleted from the blast.</span>")
			H.emote("twitch")
			H.attack_log += "Was hit with a severity 2(medium) EMP as an android. Lost 10 health."
		if(3)
			H.adjustFireLoss(2)
			H.adjustBruteLoss(3)
			H.Stun(1)
			H.nutrition = H.nutrition * 0.8
			H.emote("scream")
			H.attack_log += "Was hit with a severity 3(light) EMP as an android. Lost 5 health."

/datum/species/android/get_spans()
	return SPAN_ROBOT

/*
 PLANTPEOPLE
*/

/datum/species/plant
	// Creatures made of leaves and plant matter.
	name = "Phytosian"
	id = "plant"
	default_color = "59CE00"
	specflags = list(MUTCOLORS,EYECOLOR)
	attack_verb = "slice"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	burnmod = 1.5
	heatmod = 1.5
	coldmod = 1.5
	roundstart = 1
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/plant

/datum/species/plant/before_equip_job(datum/job/J, mob/living/carbon/human/H)
	H << "<span class='info'><b>You are a Phytosian.</b> Born on the core-worlds of G-D52, you are a distant relative of a vestige of humanity long discarded. Symbiotic plant-cells suffuse your skin and provide a protective layer that keeps you alive, and affords you regeneration unmatched by any other race.</span>"
	H << "<span class='info'>Your physiology is similar, but fundamentally different to a normal carbon life form. The chlorophyll in your epidermis provides passive nourishment and regeneration in light, but your biological processes rely on some degree of light being present at all times.</span>"
	H << "<span class='info'>Darkness is your greatest foe. Even the cold expanses of space are lit by neighbouring stars, but the darkest recesses of the station's interior may prove to be your greatest foe. Stripped of light, you will wither and die. Heat and flame are even greater foes, as your epidermis is combustible.</span>"
	H << "<span class='info'>Be warned: you will perish quickly should you become so wounded that you lose consciousness in an area void of any meaningful light source.</span>"

/datum/species/plant/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "plantbgone")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		if (prob(5))
			H << "<span class='warning'>Your skin rustles and wilts! You are dying!</span>"
		return 1

/datum/species/plant/on_hit(proj_type, mob/living/carbon/human/H)
	switch(proj_type)
		if(/obj/item/projectile/energy/floramut)
			if(prob(15))
				H.irradiate(rand(30,80))
				H.Weaken(5)
				H.visible_message("<span class='warning'>[H] writhes in pain as \his vacuoles boil.</span>", "<span class='userdanger'>You writhe in pain as your vacuoles boil!</span>", "<span class='italics'>You hear the crunching of leaves.</span>")
				if(prob(80))
					randmutb(H)
					domutcheck(H,null)
				else
					randmutg(H)
					domutcheck(H,null)
			else
				H.adjustFireLoss(rand(5,15))
				H.show_message("<span class='userdanger'>The radiation beam singes you!</span>")
		if(/obj/item/projectile/energy/florayield)
			H.nutrition = min(H.nutrition+30, NUTRITION_LEVEL_FULL)
	return

/datum/species/plant/spec_life(mob/living/carbon/human/H)
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		var/area/A = H.loc.loc
		if(A.murders_plants == 1)
			if (H.mind)
				if (H.mind.special_role == "thrall")
					//thralled phytosians have their natural regeneration massively stunted, but their weakness to darkness removed
					if (H.stat != UNCONSCIOUS && H.stat != DEAD)
						H.adjustToxLoss(-0.1)
						H.adjustOxyLoss(-0.1)
						H.heal_overall_damage(0.2, 0.2)
						return

			if (T.lighting_lumcount)
				switch (T.lighting_lumcount)
					if (0.1 to 3)
						//very low light
						H.nutrition -= T.lighting_lumcount/1.5
						if (prob(10))
							H << "<span class='warning'>There isn't enough light here, and you can feel your body protesting the fact violently.</span>"
						H.adjustOxyLoss(3)
					if (3.1 to 6)
						//low light
						H.nutrition -= T.lighting_lumcount/2
						if (prob(3))
							H << "<span class='warning'>The ambient light levels are too low. Your breath is coming more slowly as your insides struggle to keep up on their own.</span>"
							H.adjustOxyLoss(6)
					if (6.1 to 10)
						//medium, average, doing nothing for now
						H.nutrition += T.lighting_lumcount/10
					if (10.1 to 22)
						//high light, regen here
						H.nutrition += T.lighting_lumcount/6
						if (H.stat != UNCONSCIOUS && H.stat != DEAD)
							H.adjustToxLoss(-0.5)
							H.adjustOxyLoss(-0.5)
							H.heal_overall_damage(1, 1)
					if (22.1 to INFINITY)
						//super high light
						H.nutrition += T.lighting_lumcount/4
						if (H.stat != UNCONSCIOUS && H.stat != DEAD)
							H.adjustToxLoss(-1)
							H.adjustOxyLoss(-0.5)
							H.heal_overall_damage(1.5, 1.5)
			else if(T.loc.luminosity == 1 || A.lighting_use_dynamic == 0)
				H.nutrition += 1.4
				if (H.stat != UNCONSCIOUS && H.stat != DEAD)
					H.adjustToxLoss(-1)
					H.adjustOxyLoss(-0.5)
					H.heal_overall_damage(1.5, 1.5)
			else
				//no light, this is baaaaaad
				H.nutrition -= 3
				if (prob(8))
					H << "<span class='userdanger'>Darkness! Your insides churn and your skin screams in pain!</span>"
				H.adjustOxyLoss(3)
				H.adjustToxLoss(1)
	else
		if(H.loc != /obj/mecha)
			//inside a container or something else, inflict low-level light degen
			H.nutrition -= 1.5
			if (prob(3))
				H << "<span class='warning'>There's not enough light reaching you in here. You start to feel very claustrophobic as your energy begins to drain away.</span>"
				H.adjustOxyLoss(9)
				H.adjustToxLoss(3)

	if(H.nutrition > NUTRITION_LEVEL_FULL)
		H.nutrition = NUTRITION_LEVEL_FULL

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		if (H.stat != UNCONSCIOUS && H.stat != DEAD)
			if (prob(5))
				H << "<span class='userdanger'>Your internal stores of light are depleted. Find a source to replenish your nourishment at once!</span>"
			H.take_overall_damage(2,0)

/datum/species/plant/fly
	// Phytosian turned into fly-like abominations in teleporter accidents.
	name = "Flytosian"
	id = "flytosian"
	say_mod = "buzzes"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/fly
	roundstart = 0
	var/last_eat_message = -EATING_MESSAGE_COOLDOWN //I am here because flies
	specflags = list()
	default_color = "000000"

/datum/species/plant/fly/handle_speech(message)
	return replacetext(message, "z", stutter("zz"))

/datum/species/plant/fly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if (..())
		return
	if (istype(chem, /datum/reagent/consumable)) //paranoia paranoia type casting is coming to get me
		var/datum/reagent/consumable/food = chem
		if (food.nutriment_factor)
			food.nutriment_factor = food.nutriment_factor * 0.2
			if (world.time - last_eat_message > EATING_MESSAGE_COOLDOWN)
				H << "<span class='info'>This is disgusting, you need a real meal!</span>"
				last_eat_message = world.time
		return 0
	if(chem.id == "????")
		H.adjustBruteLoss(-1)
		H.adjustFireLoss(-1)
		H.adjustToxLoss(-1)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		H.nutrition += 15 * REAGENTS_METABOLISM
		return 1

	if(chem.id == "pestkiller")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

#undef EATING_MESSAGE_COOLDOWN
/*
 PODPEOPLE
*/

/datum/species/plant/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "Podperson"
	id = "pod"
	roundstart = 0
	specflags = list(MUTCOLORS,EYECOLOR)

/datum/species/plant/pod/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		var/area/A = T.loc
		if(A)
			if(A.lighting_use_dynamic)	light_amount = min(10,T.lighting_lumcount) - 5
			else						light_amount =  5
		H.nutrition += light_amount
		if(H.nutrition > NUTRITION_LEVEL_FULL)
			H.nutrition = NUTRITION_LEVEL_FULL
		if(light_amount > 2) //if there's enough light, heal
			H.heal_overall_damage(1,1)
			H.adjustToxLoss(-1)
			H.adjustOxyLoss(-1)

	if(H.nutrition < NUTRITION_LEVEL_STARVING + 50)
		H.take_overall_damage(2,0)

/*
 SHADOWPEOPLE
*/

/datum/species/shadow
	// Humans cursed to stay in the darkness, lest their life forces drain. They regain health in shadow and die in light.
	name = "???"
	id = "shadow"
	darksight = 8
	sexes = 0
	ignored_by = list(/mob/living/simple_animal/hostile/faithless)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/shadow
	specflags = list(NOBREATH,NOBLOOD,RADIMMUNE,NOGUNS)
	dangerous_existence = 1

/datum/species/shadow/spec_life(mob/living/carbon/human/H)
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		var/area/A = T.loc
		if(A)
			if(A.lighting_use_dynamic)	light_amount = T.lighting_lumcount
			else						light_amount =  10
		if(light_amount > 2) //if there's enough light, start dying
			H.take_overall_damage(1,1)
		else if (light_amount < 2) //heal in the dark
			H.heal_overall_damage(1,1)
	if(!H.darksight_init && !istype(H.dna.species,/datum/species/shadow/ling))
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/shadowling(H), slot_glasses) //Initialize the shadow's powers with darksight 'glasses'
		H.darksight_init = 1

/*
 SLIMEPEOPLE
*/

/datum/species/slime
	// Humans mutated by slime mutagen, produced from green slimes. They are not targetted by slimes.
	name = "Slimeperson"
	id = "slime"
	default_color = "00FFFF"
	darksight = 3
	invis_sight = SEE_INVISIBLE_LEVEL_ONE
	specflags = list(MUTCOLORS,EYECOLOR,HAIR,FACEHAIR,NOBLOOD)
	hair_color = "mutcolor"
	hair_alpha = 150
	ignored_by = list(/mob/living/simple_animal/slime)
	burnmod = 0.5
	coldmod = 2
	heatmod = 0.5
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	exotic_blood = "slimejelly"

/datum/species/slime/on_species_gain(mob/living/carbon/C)
	..()
	var/datum/action/split_body/S = new
	S.Grant(C)

/datum/species/slime/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return

	if(!H.reagents.get_reagent_amount("slimejelly"))
		H.reagents.add_reagent("slimejelly", 5)
		H.adjustBruteLoss(5)
		H << "<span class='danger'>You feel empty!</span>"

	for(var/datum/reagent/toxin/slimejelly/S in H.reagents.reagent_list)
		if(S.volume >= 200)
			if(prob(5))
				H << "<span class='notice'>You feel very bloated!</span>"
		if(S.volume < 200)
			if(H.nutrition >= NUTRITION_LEVEL_WELL_FED)
				H.reagents.add_reagent("slimejelly", 0.5)
				H.nutrition -= 2.5
		if(S.volume < 100)
			if(H.nutrition >= NUTRITION_LEVEL_STARVING)
				H.reagents.add_reagent("slimejelly", 0.5)
				H.nutrition -= 2.5
		if(S.volume < 50)
			if(prob(5))
				H << "<span class='danger'>You feel drained!</span>"
		if(S.volume < 10)
			H.losebreath++

/datum/species/slime/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "slimejelly")
		return 1

/datum/action/split_body
	name = "Split Body"
	check_flags = AB_CHECK_ALIVE
	action_type = AB_INNATE
	button_icon_state = "blink"
	background_icon_state = "bg_alien"

/datum/action/split_body/CheckRemoval()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H) || !H.dna || !H.dna.species || H.dna.species.id != "slime")
		return 1
	return 0

/datum/action/split_body/Activate()
	var/mob/living/carbon/human/H = owner
	H << "<span class='notice'>You focus intently on moving your body while standing perfectly still...</span>"
	H.notransform = 1
	for(var/datum/reagent/toxin/slimejelly/S in H.reagents.reagent_list)
		if(S.volume >= 200)
			var/mob/living/carbon/human/spare = new /mob/living/carbon/human(H.loc)
			spare.underwear = "Nude"
			H.dna.transfer_identity(spare, 1) //Transfer SE (second parameter) = 1
			H.dna.features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")
			var/rand_num = rand(1,1000)
			spare.real_name = "[spare.dna.real_name] [num2text(rand_num)]"
			spare.name = "[spare.dna.real_name] [num2text(rand_num)]"
			updateappearance(spare)
			domutcheck(spare)
			spare.Move(get_step(H.loc, pick(NORTH,SOUTH,EAST,WEST)))
			S.volume = 80
			H.notransform = 0
			if(!H.mind.slime_bodies.len) //if this is our first time splitting add current body
				H.mind.slime_bodies += H
				var/datum/action/swap_body/callswap = new /datum/action/swap_body()
				callswap.Grant(H)
			var/datum/action/swap_body/callswap = new /datum/action/swap_body()
			H.mind.slime_bodies += spare
			callswap.Grant(spare)
			H.mind.transfer_to(spare)
			spare << "<span class='notice'>...and after a moment of disorentation, you're besides yourself!</span>"
			return

	H << "<span class='warning'>...but there is not enough of you to go around! You must attain more mass to split!</span>"
	H.notransform = 0

/datum/action/swap_body
	name = "Swap Body"
	check_flags = AB_CHECK_ALIVE
	action_type = AB_INNATE
	button_icon_state = "mindswap"
	background_icon_state = "bg_alien"
	//var/mob/living/carbon/human/body
	//var/list/slime_bodies = list() //Keep a list of all our bodies

/datum/action/swap_body/CheckRemoval()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H) || !H.dna || !H.dna.species || H.dna.species.id != "slime")
		return 1
	return 0

/datum/action/swap_body/Activate()
	var/list/temp_body_list = list()

	for(var/slime_body in owner.mind.slime_bodies)
		var/mob/living/carbon/human/body = slime_body
		if(!istype(body) || !body.dna || !body.dna.species || body.dna.species.id != "slime" || body.stat == DEAD || qdeleted(body))
			owner.mind.slime_bodies -= body
			continue
		if((body != owner) && (body.stat == CONSCIOUS)) //Only swap into conscious bodies that are not the ones we're in
			temp_body_list += body

	if(owner.mind.slime_bodies.len == 1) //if our current body is our only one it means the rest are dead
		owner << "<span class='warning'>Something is wrong, you cannot sense your other bodies!</span>"
		Remove(owner)
		return

	if(!temp_body_list.len)
		owner << "<span class='warning'>You can sense your bodies, but they are unconscious. Swapping into them could be fatal.</span>"
		return

	var/body_name = input(owner, "Select the body you want to move into", "List of active bodies") as null|anything in temp_body_list

	if(!body_name)
		return

	var/mob/living/carbon/human/selected_body = body_name

	if(selected_body.stat == UNCONSCIOUS || owner.stat == UNCONSCIOUS) //sanity check
		owner << "<span class='warning'>The user or the target body have become unconscious during selection.</span>"
		return

	owner.mind.transfer_to(selected_body)

/*
 JELLYPEOPLE
*/

/datum/species/jelly
	// Entirely alien beings that seem to be made entirely out of gel. They have three eyes and a skeleton visible within them.
	name = "Xenobiological Jelly Entity"
	id = "jelly"
	default_color = "00FF90"
	say_mod = "chirps"
	eyes = "jelleyes"
	specflags = list(MUTCOLORS,EYECOLOR,NOBLOOD)
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/slime
	exotic_blood = "slimejelly"

/datum/species/jelly/spec_life(mob/living/carbon/human/H)
	if(!H.reagents.get_reagent_amount("slimejelly"))
		H.reagents.add_reagent("slimejelly", 5)
		H.adjustBruteLoss(5)
		H << "<span class='danger'>You feel empty!</span>"

	for(var/datum/reagent/toxin/slimejelly/S in H.reagents.reagent_list)
		if(S.volume < 100)
			if(H.nutrition >= NUTRITION_LEVEL_STARVING)
				H.reagents.add_reagent("slimejelly", 0.5)
				H.nutrition -= 2.5
			else if(prob(5))
				H << "<span class='danger'>You feel drained!</span>"
		if(S.volume < 10)
			H.losebreath++

/datum/species/jelly/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "slimejelly")
		return 1
/*
 GOLEMS
*/

/datum/species/golem
	// Animated beings of stone. They have increased defenses, and do not need to breathe. They're also slow as fuuuck.
	name = "Golem"
	id = "golem"
	specflags = list(NOBREATH,HEATRES,COLDRES,NOGUNS,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE)
	speedmod = 3
	armor = 55
	punchmod = 5
	no_equip = list(slot_wear_mask, slot_wear_suit, slot_gloves, slot_shoes, slot_head, slot_w_uniform)
	nojumpsuit = 1
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem


/*
 ADAMANTINE GOLEMS
*/

/datum/species/golem/adamantine
	name = "Adamantine Golem"
	id = "adamantine"
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/golem/adamantine

//FLY
/* This has been moved to Human, Phytosian, Unathi and Preternis */


/*
 SKELETONS
*/

/datum/species/skeleton
	// 2spooky
	name = "Spooky Scary Skeleton"
	id = "skeleton"
	say_mod = "rattles"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	specflags = list(NOBREATH,HEATRES,COLDRES,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,PIERCEIMMUNE)
/*
 ZOMBIES
*/

/datum/species/zombie
	// 1spooky
	name = "Brain-Munching Zombie"
	id = "zombie"
	say_mod = "moans"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie
	specflags = list(NOBREATH,HEATRES,COLDRES,NOBLOOD,RADIMMUNE)

/datum/species/zombie/handle_speech(message)
	var/list/message_list = text2list(message, " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, length(inserttext) - 2) == "..."))
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("BRAINS", "Brains", "Braaaiinnnsss", "BRAAAIIINNSSS")]...")

	return list2text(message_list, " ")

/datum/species/cosmetic_zombie
	name = "Human"
	id = "zombie"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie


/datum/species/abductor
	name = "Abductor"
	id = "abductor"
	darksight = 3
	say_mod = "gibbers"
	sexes = 0
	invis_sight = SEE_INVISIBLE_LEVEL_ONE
	specflags = list(NOBLOOD,NOBREATH,VIRUSIMMUNE)
	var/scientist = 0 // vars to not pollute spieces list with castes
	var/agent = 0
	var/team = 1

/datum/species/abductor/handle_speech(message)
	//Hacks
	var/mob/living/carbon/human/user = usr
	log_say("[key_name(user)] : [message]")
	user.say_log_silent += "Abductor Chat: [message]"
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.dna.species.id != "abductor")
			continue
		else
			var/datum/species/abductor/target_spec = H.dna.species
			if(target_spec.team == team)
				H << "<i><font color=#800080><b>[user.name]:</b> [message]</font></i>"
				//return - technically you can add more aliens to a team
	for(var/mob/M in dead_mob_list)
		M << "<i><font color=#800080><b>[user.name]:</b> [message]</font></i>"
	return ""


var/global/image/plasmaman_on_fire = image("icon"='icons/mob/OnFire.dmi', "icon_state"="plasmaman")

/datum/species/plasmaman
	name = "Plasbone"
	id = "plasmaman"
	say_mod = "rattles"
	sexes = 0
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skeleton
	specflags = list(NOBLOOD,RADIMMUNE)
	safe_oxygen_min = 0 //We don't breath this
	safe_toxins_min = 16 //We breath THIS!
	safe_toxins_max = 0
	dangerous_existence = 1 //So so much
	var/skin = 0

/datum/species/plasmaman/skin
	name = "Skinbone"
	skin = 1

/datum/species/plasmaman/update_base_icon_state(mob/living/carbon/human/H)
	var/base = ..()
	if(base == id)
		base = "[base][skin]"
	return base

/datum/species/plasmaman/spec_life(mob/living/carbon/human/H)
	var/datum/gas_mixture/environment = H.loc.return_air()

	if(!istype(H.wear_suit, /obj/item/clothing/suit/space/eva/plasmaman) || !istype(H.head, /obj/item/clothing/head/helmet/space/hardsuit/plasmaman))
		if(environment)
			var/total_moles = environment.total_moles()
			if(total_moles)
				if((environment.oxygen /total_moles) >= 0.01)
					if(!H.on_fire)
						H.visible_message("<span class='danger'>[H]'s body reacts with the atmosphere and bursts into flames!</span>","<span class='userdanger'>Your body reacts with the atmosphere and bursts into flame!</span>")
					H.adjust_fire_stacks(0.5)
					H.IgniteMob()
	else
		if(H.fire_stacks)
			var/obj/item/clothing/suit/space/eva/plasmaman/P = H.wear_suit
			if(istype(P))
				P.Extinguish(H)
	H.update_fire()

//Heal from plasma
/datum/species/plasmaman/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "plasma")
		H.adjustBruteLoss(-5)
		H.adjustFireLoss(-5)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1
