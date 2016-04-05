/obj/item/organ/internal/ability_organ/changeling/fleshmend
	name = "fleshmend gland"
	desc = "A gland that rapidly heals the body."
	slot = "fleshmender"
	zone = "chest"
	granted_powers = list(/obj/effect/proc_holder/resource_ability/changeling/fleshmend)

/obj/effect/proc_holder/resource_ability/changeling/fleshmend
	name = "Fleshmend"
	desc = "Our flesh twists and knits itself back together, healing our wounds. Humans watching this will notice something amiss."
	helptext = "Heals a moderate amount of damage over a short period of time. Can be used while unconscious."
	resource_cost = 35
	dna_cost = 2
	req_stat = UNCONSCIOUS
	organtype = /obj/item/organ/internal/ability_organ/changeling/fleshmend

//Starts healing you every second for 10 seconds. Can be used whilst unconscious.
/obj/effect/proc_holder/resource_ability/changeling/fleshmend/sting_action(mob/living/user)
	user << "<span class='notice'>Our flesh surges with our prowess, our flesh mending any damage it has sustained.</span>"
	user.visible_message("<span class='warning'>[user]'s flesh begins to roil and pulse unnaturally!</span>", 5)
	spawn(0)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.restore_blood()
			H.remove_all_embedded_objects()

		for(var/i = 0, i<10,i++)
			if (prob(10))
				user.visible_message("<span class='warning'>A sickeningly wet crunch emanates from [user].</span>", 2)
			user.adjustBruteLoss(-10)
			user.adjustOxyLoss(-10)
			user.adjustFireLoss(-10)
			sleep(10)

	feedback_add_details("changeling_powers","RR")
	return 1