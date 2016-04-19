/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	var/ignore_flags = 1

/obj/item/weapon/reagent_containers/hypospray/attack_paw(mob/user)
	return attack_hand(user)

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		user << "<span class='warning'>[src] is empty!</span>"
		return
	if(!istype(M))
		return

	if(reagents.total_volume && (ignore_flags || M.can_inject(user, 1))) // Ignore flag should be checked first or there will be an error message.
		M << "<span class='warning'>You feel a tiny prick!</span>"
		user << "<span class='notice'>You inject [M] with [src].</span>"

		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
		reagents.reaction(M, INGEST, fraction)
		if(M.reagents)
			var/list/injected = list()
			var/viruslist = ""
			for(var/datum/reagent/R in reagents.reagent_list)
				if(istype(R, /datum/reagent/blood))
					var/datum/reagent/blood/RR = R
					for(var/datum/disease/D in RR.data["viruses"])
						viruslist += " [D.name]"
						if(istype(D, /datum/disease/advance))
							var/datum/disease/advance/DD = D
							viruslist += " \[ symptoms: "
							for(var/datum/symptom/S in DD.symptoms)
								viruslist += "[S.name] "
							viruslist += "\]"
				injected += R.name

			var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
			user << "<span class='notice'>[trans] unit\s injected.  [reagents.total_volume] unit\s remaining in [src].</span>"

			var/contained = english_list(injected)

			if(viruslist)
				investigate_log("[user.name] ([user.ckey]) injected [M.name] ([M.ckey]) with [viruslist]", "viro")
			add_logs(user, M, "injected", object="[src.name]", addition="([contained])")

			if(M.viruses)
				for(var/datum/disease/D in M.viruses)
					for(var/datum/reagent/A in reagents.reagent_list)
						if(A.id in D.cures)
							if(D.stage <= 1)
								M << "<span class='warning'>Whatever it was wrong with you, it seems to be gone now.</span>"
								M.viruses.Remove(D)
								qdel(D)
							else
								M << "<span class='warning'>You feel a little bit better.</span>"
								D.stage--

/obj/item/weapon/reagent_containers/hypospray/CMO
	list_reagents = list("omnizine" = 30)
	high_risk = 1

/obj/item/weapon/reagent_containers/hypospray/combat
	name = "combat stimulant injector"
	desc = "A modified air-needle autoinjector, used by support operatives to quickly heal injuries in combat."
	amount_per_transfer_from_this = 10
	icon_state = "combat_hypo"
	volume = 90
	ignore_flags = 1 // So they can heal their comrades.
	list_reagents = list("epinephrine" = 30, "omnizine" = 30, "leporazine" = 15, "atropine" = 15)

/obj/item/weapon/reagent_containers/hypospray/combat/nanites
	desc = "A modified air-needle autoinjector for use in combat situations. Prefilled with expensive medical nanites for rapid healing."
	volume = 100
	list_reagents = list("nanites" = 80, "synaptizine" = 20)

//MediPens

/obj/item/weapon/reagent_containers/hypospray/medipen
	name = "epinephrine medipen"
	desc = "A rapid and safe way to stabilize patients in critical condition for personnel without advanced medical knowledge."
	icon_state = "medipen"
	item_state = "medipen"
	amount_per_transfer_from_this = 10
	volume = 10
	ignore_flags = 1 //so you can medipen through hardsuits
	flags = null
	list_reagents = list("epinephrine" = 10)

/obj/item/weapon/reagent_containers/hypospray/medipen/New()
	..()
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/medipen/attack(mob/M, mob/user)
	..()
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/medipen/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/weapon/reagent_containers/hypospray/medipen/examine()
	..()
	if(reagents && reagents.reagent_list.len)
		usr << "<span class='notice'>It is currently loaded.</span>"
	else
		usr << "<span class='notice'>It is spent.</span>"

/obj/item/weapon/reagent_containers/hypospray/medipen/stimpack //goliath kiting
	name = "stimpack medipen"
	desc = "A rapid way to stimulate your body's adrenaline, allowing for freer movement in restrictive armor."
	icon_state = "stimpen"
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = list("ephedrine" = 10, "coffee" = 10)

/obj/item/weapon/reagent_containers/hypospray/medipen/morphine
	name = "morphine medipen"
	desc = "A rapid way to get you out of a tight situation and fast! You'll feel rather drowsy, though."
	list_reagents = list("morphine" = 10)

/obj/item/weapon/reagent_containers/hypospray/mini
	name = "minihypospray"
	desc = "A modified, more portable air-needle autoinjector, used by mining personnel and space explorers to quickly heal injuries in hostile environments."
	icon = 'icons/obj/syringe.dmi'
	item_state = "minihypo"
	icon_state = "minihypo"
	amount_per_transfer_from_this = 5
	volume = 20
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	ignore_flags = 1
	list_reagents = list("omnizine" = 20)