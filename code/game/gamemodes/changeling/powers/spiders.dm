/*
/obj/item/organ/internal/ability_organ/changeling/spiders
	name = "spider sac"
	desc = "a sac that can grow and release spiders."
	slot = "spider_gland"
	zone = "chest"
	changeling_only_powers = list(/obj/effect/proc_holder/resource_ability/changeling/spiders)
*/

/obj/effect/proc_holder/resource_ability/changeling/spiders
	name = "Spread Infestation"
	desc = "Our form divides, creating arachnids which will grow into deadly beasts."
	helptext = "The spiders are thoughtless creatures, and may attack their creators when fully grown. Requires at least 5 DNA absorptions."
	resource_cost = 45
	dna_cost = 1
	req_dna = 5
	//organtype = /obj/item/organ/internal/ability_organ/changeling/spiders

//Makes some spiderlings. Good for setting traps and causing general trouble.
/obj/effect/proc_holder/resource_ability/changeling/spiders/sting_action(mob/user)
	for(var/i=0, i<2, i++)
		var/obj/effect/spider/spiderling/S = new(user.loc)
		S.grow_as = /mob/living/simple_animal/hostile/poison/giant_spider/hunter

	feedback_add_details("changeling_powers","SI")
	return 1
