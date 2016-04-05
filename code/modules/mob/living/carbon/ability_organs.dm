//Framework for alien and changeling powers granted by organs

//ORGANS

/obj/item/organ/internal/ability_organ
	origin_tech = "biotech=5"
	icon = 'icons/effects/blood.dmi'
	icon_state = "xgibmid2"
	var/list/granted_powers = list()

/obj/item/organ/internal/ability_organ/New()
	for(var/A in granted_powers)
		if(ispath(A))
			granted_powers -= A
			granted_powers += new A(src)
	..()

/obj/item/organ/internal/ability_organ/Insert(mob/living/carbon/M, special = 0)
	..()
	for(var/obj/effect/proc_holder/resource_ability/P in granted_powers)
		M.AddAbility(P)


/obj/item/organ/internal/ability_organ/Remove(mob/living/carbon/M, special = 0)
	for(var/obj/effect/proc_holder/P in granted_powers)
		M.RemoveAbility(P)
	..()

//ACTIONS

/datum/action/spell_action/resource_action

/datum/action/spell_action/resource_action/UpdateName()
	var/obj/effect/proc_holder/resource_ability/ab = target
	return ab.name

/datum/action/spell_action/resource_action/IsAvailable()
	if(!target)
		return 0
	var/obj/effect/proc_holder/resource_ability/ab = target

	if(usr)
		return ab.cost_check(usr,1)
	else
		if(owner)
			return ab.cost_check(owner,1)
	return 1

/datum/action/spell_action/resource_action/CheckRemoval()
	if(!iscarbon(owner))
		return 1

	var/mob/living/carbon/C = owner
	if(target.loc && !(target.loc in C.internal_organs))
		return 1

	return 0

//PROC_HOLDERS

/obj/effect/proc_holder/resource_ability
	name = "Organ Power"
	panel = "Organs"
	var/resource_type = 0
	var/resource_cost = 0

	var/has_action = 1
	var/datum/action/spell_action/resource_action/action = null
	var/action_icon = 'icons/mob/actions.dmi'
	var/action_icon_state = "spell_default"
	var/action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/resource_ability/Click()
	if(!istype(usr,/mob/living/carbon))
		return 1
	var/mob/living/carbon/user = usr
	if(cost_check(user))
		if(fire(user) && user) // Second check to prevent runtimes when evolving
			user.adjustResource(resource_type, -resource_cost)
	return 1

/obj/effect/proc_holder/resource_ability/proc/on_gain(mob/living/carbon/user)
	return

/obj/effect/proc_holder/resource_ability/proc/on_lose(mob/living/carbon/user)
	return

/obj/effect/proc_holder/resource_ability/proc/fire(mob/living/carbon/user)
	return 1

/obj/effect/proc_holder/resource_ability/proc/cost_check(mob/living/carbon/user,silent = 0)
	if(user.stat)
		if(!silent)
			user << "<span class='noticealien'>You must be conscious to do this.</span>"
		return 0
	if(user.getResource(resource_type) < resource_cost)
		if(!silent)
			user << "<span class='noticealien'>Not enough plasma stored.</span>"
		return 0
	return 1

//MOB PROCS

/mob/living/carbon/proc/getResource(resource_type)
	switch(resource_type)
		if(RESOURCE_ALIEN)
			var/obj/item/organ/internal/ability_organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/internal/ability_organ/alien/plasmavessel)
			if(!vessel)
				return 0
			return vessel.storedPlasma
		if(RESOURCE_CHANGELING)
			var/obj/item/organ/internal/ability_organ/changeling/chem_storage/chem_store = getorgan(/obj/item/organ/internal/ability_organ/changeling/chem_storage)
			if(!chem_store)
				return 0
			return chem_store.chem_charges
		else
			return 0

/mob/living/carbon/proc/getResourceMax(resource_type)
	switch(resource_type)
		if(RESOURCE_ALIEN)
			var/obj/item/organ/internal/ability_organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/internal/ability_organ/alien/plasmavessel)
			if(!vessel)
				return 0
			return vessel.max_plasma
		if(RESOURCE_CHANGELING)
			var/obj/item/organ/internal/ability_organ/changeling/chem_storage/chem_store = getorgan(/obj/item/organ/internal/ability_organ/changeling/chem_storage)
			if(!chem_store)
				return 0
			return chem_store.chem_storage
		else
			return 0

/mob/living/carbon/proc/adjustResource(resource_type, amount)
	switch(resource_type)
		if(RESOURCE_ALIEN)
			var/obj/item/organ/internal/ability_organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/internal/ability_organ/alien/plasmavessel)
			if(!vessel)
				return 0
			vessel.storedPlasma = max(vessel.storedPlasma + amount,0)
			vessel.storedPlasma = min(vessel.storedPlasma, vessel.max_plasma) //upper limit of max_plasma, lower limit of 0
			return 1
		if(RESOURCE_CHANGELING)
			var/obj/item/organ/internal/ability_organ/changeling/chem_storage/chem_store = getorgan(/obj/item/organ/internal/ability_organ/changeling/chem_storage)
			if(!chem_store)
				return 0
			chem_store.chem_charges = max(chem_store.chem_charges + amount,0)
			chem_store.chem_charges = min(chem_store.chem_charges, chem_store.chem_storage) //upper limit of max_plasma, lower limit of 0
			return 1
		else
			return 0

/mob/living/carbon/proc/setResource(resource_type, value)
	switch(resource_type)
		if(RESOURCE_ALIEN)
			var/obj/item/organ/internal/ability_organ/alien/plasmavessel/vessel = getorgan(/obj/item/organ/internal/ability_organ/alien/plasmavessel)
			if(!vessel)
				return 0
			vessel.storedPlasma = value
			vessel.storedPlasma = min(vessel.storedPlasma, vessel.max_plasma) //upper limit of max_plasma, lower limit of 0
			return 1
		if(RESOURCE_CHANGELING)
			var/obj/item/organ/internal/ability_organ/changeling/chem_storage/chem_store = getorgan(/obj/item/organ/internal/ability_organ/changeling/chem_storage)
			if(!chem_store)
				return 0
			chem_store.chem_charges = max(value,0)
			chem_store.chem_charges = min(chem_store.chem_charges, chem_store.chem_storage) //upper limit of max_plasma, lower limit of 0
			return 1
		else
			return 0