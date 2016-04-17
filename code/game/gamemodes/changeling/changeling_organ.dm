/obj/item/organ/internal/ability_organ/changeling
	var/free_organ = 0
	var/in_changeling = 0
	var/list/changeling_only_powers = list()
	var/decay_above_temp = T0C
	decay_time = 60
	//var/zone = "chest"
	//var/slot

/obj/item/organ/internal/ability_organ/changeling/New()
	for(var/A in changeling_only_powers)
		if(ispath(A))
			changeling_only_powers -= A
			var/power = new A(src)
			changeling_only_powers += power
			granted_powers += power
	..()

/obj/item/organ/internal/ability_organ/changeling/Insert()
	..()
	initial_changeling_check()

/obj/item/organ/internal/ability_organ/changeling/on_life()
	..()
	changeling_check()

/obj/item/organ/internal/ability_organ/changeling/proc/changeling_check()
	if(!owner)
		return
	if(owner.mind && owner.mind.changeling)
		if(!in_changeling)
			in_changeling = 1
			on_changeling_insert()
	else
		if(in_changeling)
			in_changeling = 0
			on_non_changeling_insert()

/obj/item/organ/internal/ability_organ/changeling/proc/initial_changeling_check()
	in_changeling = !(owner.mind && owner.mind.changeling) //have to do this because it only updates if the changeling status changed.
	changeling_check()

/obj/item/organ/internal/ability_organ/changeling/proc/on_changeling_insert()
	for(var/A in changeling_only_powers)
		owner.AddAbility(A)
	..()

/obj/item/organ/internal/ability_organ/changeling/proc/on_non_changeling_insert()
	for(var/A in changeling_only_powers)
		owner.RemoveAbility(A)
	..()

/obj/item/organ/internal/ability_organ/changeling/handle_decay()
	if(!decay_time || decay == -1)
		return
	if(owner)
		if(!(owner.stat & DEAD))
			decay = min(decay+1, decay_time)
		return

	var/temperature
	if(owner)
		temperature = owner.bodytemperature
	else if(loc)
		var/datum/gas_mixture/environment = loc.return_air()
		if(!environment)
			return
		temperature = environment.temperature
	else
		return

	if(temperature > decay_above_temp)
		decay = max(0, decay-1)
	if(!decay)
		decay = -1
		update_icon()
		SSobj.processing -= src

//CHEMICAL STORAGE

/obj/item/organ/internal/ability_organ/changeling/chem_storage
	name = "chemical storage gland"
	desc = "a gland that stores changeling chemicals."
	slot = "chem_store"
	free_organ = 1
	var/chem_charges = 20
	var/chem_storage = 75
	var/chem_recharge_rate = 1
	var/chem_recharge_slowdown = 0

/obj/item/organ/internal/ability_organ/changeling/chem_storage/on_life()
	..()
	if(owner.mind && owner.hud_used)
		owner.hud_used.lingchemdisplay.invisibility = 0
		owner.hud_used.lingchemdisplay.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd66dd'>[round(owner.getResource(RESOURCE_CHANGELING))]</font></div>"

	if(owner.stat == DEAD)
		chem_charges = min(max(0, chem_charges + chem_recharge_rate - chem_recharge_slowdown), (chem_storage*0.5))
	else //not dead? no chem/geneticdamage caps.
		chem_charges = min(max(0, chem_charges + chem_recharge_rate - chem_recharge_slowdown), chem_storage)

/obj/item/organ/internal/ability_organ/changeling/chem_storage/Remove()
	owner.hud_used.lingchemdisplay.invisibility = 101
	..()
