/mob/living/simple_animal/borer/verb/Feed()
	set name = "Infect"
	set category = "Borer"
	set desc = "Infect a adjacent human being"

	if(victim)
		src << "<span class='boldnotice'>You already have a host! leave this one if you want a new one.</span>"

	if(stat == DEAD)
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1,src))
		if(H!=src && Adjacent(H))
			choices += H

	var/mob/living/carbon/human/H = input(src,"Who do you wish to infect?") in null|choices
	if(!H) return
	if(CanInfect(H))
		H << "<span class='boldnotice'>Something slimy begins probing at the opening of your ear canal...</span>"
		src << "<span class='boldnotice'>You slither up [H] and begin probing at their ear canal...</span>"

		if(!do_after(src,30))
			src << "<span class='boldnotice'>As [H] moves away, you are dislodged and fall to the ground.</span>"
			return

		if(!H || !src) return

		Infect(H)

/mob/living/simple_animal/borer/proc/CanInfect(var/mob/living/carbon/human/H)
	if(!Adjacent(H))
		return 0

	if(stat == UNCONSCIOUS)
		src << "<span class='boldnotice'>I must be conscious to do this...</span>"
		return 0

	if(H.stat == DEAD)
		src << "<span class='boldnotice'>This subject does not have a strong enough life energy...</span>"
		return 0
	return 1

/mob/living/simple_animal/borer/verb/secrete_chemicals()
	set category = "Borer"
	set name = "Secrete Chemicals"
	set desc = "Push some chemicals into your host's bloodstream."

	if(!victim)
		src << "<span class='boldnotice'>You are not inside a host body.</span>"
		return

	if(stat == DEAD)
		src << "<span class='boldnotice'>You cannot secrete chemicals in your current state.</span>"

	if(docile)
		src << "<span class='boldnotice'>You are feeling far too docile to do that.</span>"
		return

	if(chemicals < 50)
		src << "<span class='boldnotice'>You don't have enough chemicals!</span>"
		return

	var/chem = input("Select a chemical to secrete.", "Chemicals") as null|anything in list("mannitol","bicaridine","hyperzine", "kelotane", "morphine", "cyanide")

	if(!chem || chemicals < 50 || !victim || controlling || !src || stat) //Sanity check.
		return

	src << "\red <B>You squirt a measure of [chem] from your reservoirs into [host]'s bloodstream.</B>"
	victim.reagents.add_reagent(chem, 10)
	chemicals -= 50