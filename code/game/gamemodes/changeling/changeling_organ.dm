/obj/item/organ/internal/ability_organ/changeling
	var/free_organ = 0
	//var/zone = "chest"
	//var/slot

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
