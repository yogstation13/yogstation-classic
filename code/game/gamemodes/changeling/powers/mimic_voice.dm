/obj/item/organ/internal/ability_organ/changeling/mimicvoice
	name = "Dynamic Vocal Cords"
	desc = "a set of vocal cords that can easily mimic voices."
	slot = "mimicvoice"
	zone = "mouth"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/changeling/mimicvoice)

/obj/effect/proc_holder/resource_ability/changeling/mimicvoice
	name = "Mimic Voice"
	desc = "We shape our vocal glands to sound like a desired voice."
	helptext = "Will turn your voice into the name that you enter. We must constantly expend chemicals to maintain our form like this."
	resource_cost = 0 //constant chemical drain hardcoded
	dna_cost = 1
	req_human = 1
	organtype = /obj/item/organ/internal/ability_organ/changeling/mimicvoice

// Fake Voice
/obj/effect/proc_holder/resource_ability/changeling/mimicvoice/sting_action(mob/living/carbon/user)
	var/datum/changeling/changeling=user.mind.changeling
	var/obj/item/organ/internal/ability_organ/changeling/chem_storage/chem_store = user.getorgan(/obj/item/organ/internal/ability_organ/changeling/chem_storage)
	if(changeling.mimicing)
		changeling.mimicing = ""
		if(chem_store)
			chem_store.chem_recharge_slowdown -= 0.5
		user << "<span class='notice'>We return our vocal glands to their original position.</span>"
		return

	var/mimic_voice = stripped_input(user, "Enter a name to mimic.", "Mimic Voice", null, MAX_NAME_LEN)
	if(!mimic_voice)
		return

	changeling.mimicing = mimic_voice
	if(chem_store)
		chem_store.chem_recharge_slowdown += 0.5
	user << "<span class='notice'>We shape our glands to take the voice of <b>[mimic_voice]</b>, this will slow down regenerating chemicals while active.</span>"
	user << "<span class='notice'>Use this power again to return to our original voice and return chemical production to normal levels.</span>"

	feedback_add_details("changeling_powers","MV")

/obj/effect/proc_holder/resource_ability/changeling/mimicvoice/on_lose(mob/living/carbon/user)
	var/datum/changeling/changeling=user.mind.changeling//move this from datum/changeling to mob/.../human
	if(changeling.mimicing)
		changeling.mimicing = ""
		var/obj/item/organ/internal/ability_organ/changeling/chem_storage/chem_store = user.getorgan(/obj/item/organ/internal/ability_organ/changeling/chem_storage)
		if(chem_store)
			chem_store.chem_recharge_slowdown -= 0.5
		user << "<span class='notice'>Our dynamic vocal chords are ripped out, restoring our normal voice.</span>"