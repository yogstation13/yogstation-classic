/obj/item/organ/internal/ability_organ/alien
	origin_tech = "biotech=5"
	icon = 'icons/effects/blood.dmi'
	icon_state = "xgibmid2"

/obj/item/organ/internal/ability_organ/alien/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("sacid", 10)
	return S


/obj/item/organ/internal/ability_organ/alien/plasmavessel
	name = "plasma vessel"
	origin_tech = "biotech=5;plasma=2"
	w_class = 3
	zone = "chest"
	slot = "plasmavessel"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/alien/plant/weeds, /obj/effect/proc_holder/resource_ability/alien/transfer)

	var/storedPlasma = 100
	var/max_plasma = 250
	var/heal_rate = 5
	var/plasma_rate = 10

/obj/item/organ/internal/ability_organ/alien/plasmavessel/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent("plasma", storedPlasma/10)
	return S

/obj/item/organ/internal/ability_organ/alien/plasmavessel/large
	name = "large plasma vessel"
	w_class = 4
	storedPlasma = 200
	max_plasma = 500
	plasma_rate = 15

/obj/item/organ/internal/ability_organ/alien/plasmavessel/large/queen
	origin_tech = "biotech=6;plasma=3"
	plasma_rate = 20

/obj/item/organ/internal/ability_organ/alien/plasmavessel/small
	name = "small plasma vessel"
	w_class = 2
	storedPlasma = 100
	max_plasma = 150
	plasma_rate = 5

/obj/item/organ/internal/ability_organ/alien/plasmavessel/small/tiny
	name = "tiny plasma vessel"
	w_class = 1
	max_plasma = 100
	granted_powers = list(/obj/effect/proc_holder/resource_ability/alien/transfer)

/obj/item/organ/internal/ability_organ/alien/plasmavessel/on_life()
	//If there are alien weeds on the ground then heal if needed or give some plasma
	if(locate(/obj/structure/alien/weeds) in owner.loc)
		if(owner.health >= owner.maxHealth - owner.getCloneLoss())
			owner.adjustResource(RESOURCE_ALIEN, plasma_rate)
		else
			var/mod = 1
			if(!isalien(owner))
				mod = 0.2
			owner.adjustBruteLoss(-heal_rate*mod)
			owner.adjustFireLoss(-heal_rate*mod)
			owner.adjustOxyLoss(-heal_rate*mod)

/obj/item/organ/internal/ability_organ/alien/plasmavessel/Insert(mob/living/carbon/M, special = 0)
	..()
	if(isalien(M))
		var/mob/living/carbon/alien/A = M
		A.updatePlasmaDisplay()

/obj/item/organ/internal/ability_organ/alien/plasmavessel/Remove(mob/living/carbon/M, special = 0)
	..()
	if(isalien(M))
		var/mob/living/carbon/alien/A = M
		A.updatePlasmaDisplay()


/obj/item/organ/internal/ability_organ/alien/hivenode
	name = "hive node"
	zone = "head"
	slot = "hivenode"
	origin_tech = "biotech=5;magnets=4;bluespace=3"
	w_class = 1
	granted_powers = list(/obj/effect/proc_holder/resource_ability/alien/whisper)

/obj/item/organ/internal/ability_organ/alien/hivenode/Insert(mob/living/carbon/M, special = 0)
	..()
	M.faction |= "alien"

/obj/item/organ/internal/ability_organ/alien/hivenode/Remove(mob/living/carbon/M, special = 0)
	M.faction -= "alien"
	..()


/obj/item/organ/internal/ability_organ/alien/resinspinner
	name = "resin spinner"
	zone = "mouth"
	slot = "resinspinner"
	origin_tech = "biotech=5;materials=4"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/alien/plant/resin)


/obj/item/organ/internal/ability_organ/alien/acid
	name = "acid gland"
	zone = "mouth"
	slot = "acidgland"
	origin_tech = "biotech=5;materials=2;combat=2"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/alien/acid)


/obj/item/organ/internal/ability_organ/alien/neurotoxin
	name = "neurotoxin gland"
	zone = "mouth"
	slot = "neurotoxingland"
	origin_tech = "biotech=5;combat=5"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/alien/neurotoxin)


/obj/item/organ/internal/ability_organ/alien/eggsac
	name = "egg sac"
	zone = "groin"
	slot = "eggsac"
	w_class = 4
	origin_tech = "biotech=8"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/alien/lay_egg)