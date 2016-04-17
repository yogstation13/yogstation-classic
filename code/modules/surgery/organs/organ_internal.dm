/obj/item/organ/internal
	origin_tech = "biotech=2"
	force = 1
	w_class = 2
	throwforce = 0
	var/zone = "chest"
	var/slot
	var/vital = 0
	var/organ_action_name = null
	var/decay_time = 0//Measured in BYOND seconds. By default, organs do not decay.
	var/decay = 0
	var/decay_above_temp = T0C

/obj/item/organ/internal/New()
	decay = decay_time
	if(decay_time)
		SSobj.processing |= src

/obj/item/organ/internal/process()
	if(!decay_time || decay == -1)
		return
	if(owner && !(owner.stat & DEAD))//don't decay if you are inside a living person.
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
		on_decay()

/obj/item/organ/internal/proc/on_decay()
	decay = -1
	SSobj.processing.Remove(src)

/obj/item/organ/internal/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/device/healthanalyzer))//perhaps also the PDA cartridge?
		user.visible_message("<span class='notice'>[user] has analyzed \the [src].</span>")
		if(!decay_time)
			user << "<span class='danger'>\The [src] will not decay.</span>"
		else if(decay == -1)
			user << "<span class='danger'>\The [src] is decayed beyond the point of no return.</span>"
		else
			user << "<span class='danger'>\The [src]'s tissue is [round(100-(100*decay/decay_time), 0.1)]% decayed.</span>"

/obj/item/organ/internal/proc/Insert(mob/living/carbon/M, special = 0)
	if(!iscarbon(M) || owner == M)
		return

	var/obj/item/organ/internal/replaced = M.getorganslot(slot)
	if(replaced)
		replaced.Remove(M, special = 1)

	owner = M
	M.internal_organs |= src
	loc = null
	if(organ_action_name)
		action_button_name = organ_action_name


/obj/item/organ/internal/proc/Remove(mob/living/carbon/M, special = 0)
	owner = null
	if(M)
		M.internal_organs -= src
		if(vital && !special)
			M.death()

	if(organ_action_name)
		action_button_name = null

/obj/item/organ/internal/proc/on_find(mob/living/finder)
	return

/obj/item/organ/internal/proc/on_life()
	decay = min(decay_time, decay+1)
	return

/obj/item/organ/internal/proc/prepare_eat()
	var/obj/item/weapon/reagent_containers/food/snacks/S = new
	S.name = name
	S.desc = desc
	S.icon = icon
	S.icon_state = icon_state
	S.origin_tech = origin_tech
	S.w_class = w_class
	S.reagents.add_reagent("nutriment", 5)

	return S

/obj/item/organ/internal/Destroy()
	if(owner)
		Remove(owner, 1)
	..()

/obj/item/organ/internal/attack(mob/living/carbon/M, mob/user)
	if(M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(status == ORGAN_ORGANIC)
			var/obj/item/weapon/reagent_containers/food/snacks/S = prepare_eat()
			if(S)
				H.drop_item()
				H.put_in_active_hand(S)
				S.attack(H, H)
				qdel(src)
	else
		..()

//Looking for brains?
//Try code/modules/mob/living/carbon/brain/brain_item.dm



/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	zone = "chest"
	slot = "heart"
	origin_tech = "biotech=3"
	vital = 1
	decay_time = 600//10 BYOND minutes, same as the old defib time limit.
	var/beating = 1

/obj/item/organ/internal/heart/on_decay()
	..()
	beating = 0
	update_icon()

/obj/item/organ/internal/heart/update_icon()
	if(beating)
		icon_state = "heart-on"
	else
		icon_state = "heart-off"

/obj/item/organ/internal/heart/Insert(mob/living/carbon/M, special = 0)
	..()
	beating = 1
	update_icon()

/obj/item/organ/internal/heart/Remove(mob/living/carbon/M, special = 0)
	..()
	/*//unnecessary with the new decay system.
	spawn(120)
		beating = 0
		update_icon()
	*/

/obj/item/organ/internal/heart/prepare_eat()
	var/obj/S = ..()
	S.icon_state = "heart-off"
	return S



/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	zone = "groin"
	slot = "appendix"
	var/inflamed = 0

/obj/item/organ/internal/appendix/update_icon()
	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"
	else
		icon_state = "appendix"
		name = "appendix"

/obj/item/organ/internal/appendix/Remove(mob/living/carbon/M, special = 0)
	for(var/datum/disease/appendicitis/A in M.viruses)
		A.cure()
		inflamed = 1
	update_icon()
	..()

/obj/item/organ/internal/appendix/Insert(mob/living/carbon/M, special = 0)
	..()
	if(inflamed)
		M.AddDisease(new /datum/disease/appendicitis)

/obj/item/organ/internal/appendix/prepare_eat()
	var/obj/S = ..()
	if(inflamed)
		S.reagents.add_reagent("????", 5)
	return S

/obj/item/organ/internal/thrall_tumor
	zone = "head"
	slot = "tumor"
	name = "black tumor"
	icon_state = "blacktumor"


// Surgery stuffs, and enthralling.
/obj/item/organ/internal/thrall_tumor/Remove(mob/living/carbon/M, special = 0, adminbus = 0)
	ticker.mode.remove_thrall(M.mind,!adminbus && prob(30))
	..()

/obj/item/organ/internal/thrall_tumor/Insert(mob/living/carbon/M, special = 0)
	ticker.mode.add_thrall(M.mind)
	M.mind.special_role = "thrall"
	..()