/obj/item/organ/internal/ability_organ/changeling/panacea
	name = "anatomic panacea gland"
	desc = "a miracle organ that can cure diseases, remove toxins and radiation damage, and reset the owner's genetic code."
	slot = "panacea"
	zone = "chest"
	changeling_only_powers = list(/obj/effect/proc_holder/resource_ability/changeling/panacea)

/obj/effect/proc_holder/resource_ability/changeling/panacea
	name = "Anatomic Panacea"
	desc = "Expels impurifications from our form; curing diseases, removing toxins and radiation, and resetting our genetic code completely."
	helptext = "Can be used while unconscious."
	resource_cost = 20
	dna_cost = 1
	req_stat = UNCONSCIOUS
	organtype = /obj/item/organ/internal/ability_organ/changeling/panacea

//Heals the things that the other regenerative abilities don't.
/obj/effect/proc_holder/resource_ability/changeling/panacea/sting_action(mob/user)

	user << "<span class='notice'>We cleanse impurities from our form.</span>"
	user.reagents.add_reagent("mutadone", 10)
	user.reagents.add_reagent("potass_iodide", 10)
	user.reagents.add_reagent("charcoal", 20)

	for(var/datum/disease/D in user.viruses)
		D.cure()

	feedback_add_details("changeling_powers","AP")
	return 1