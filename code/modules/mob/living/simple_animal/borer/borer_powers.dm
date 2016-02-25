/mob/living/simple_animal/borer/verb/infect_victim()
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
		src.layer = MOB_LAYER
		if(!do_after(src,30))
			src << "<span class='boldnotice'>As [H] moves away, you are dislodged and fall to the ground.</span>"
			return

		if(!H || !src) return

		Infect(H)

/mob/living/simple_animal/borer/proc/CanInfect(var/mob/living/carbon/human/H)
	if(!Adjacent(H))
		return 0

	if(stat != CONSCIOUS)
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

	if(stat != CONSCIOUS)
		src << "<span class='boldnotice'>You cannot secrete chemicals in your current state.</span>"

	if(docile)
		src << "<span class='boldnotice'>You are feeling far too docile to do that.</span>"
		return

	if(chemicals < 50)
		src << "<span class='boldnotice'>You don't have enough chemicals!</span>"
		return

	var/chem = input("Select a chemical to secrete.", "Chemicals") as null|anything in list("mannitol","bicaridine", "kelotane", "charcoal", "morphine", "ephedrine")

	if(!chem || chemicals < 50 || !victim || controlling || !src || stat) //Sanity check.
		return

	src << "\red <B>You squirt a measure of [chem] from your reservoirs into [host]'s bloodstream.</B>"
	victim.reagents.add_reagent(chem, 10)
	chemicals -= 50

/mob/living/simple_animal/borer/verb/hide()
	set category = "Borer"
	set name = "Hide"
	set desc = "Become invisible to the common eye."

	if(src.stat != CONSCIOUS)
		return

	if (src.layer != TURF_LAYER+0.2)
		src.layer = TURF_LAYER+0.2
		src.visible_message("<span class='name'>[src] scurries to the ground!</span>", \
						"<span class='noticealien'>You are now hiding.</span>")
	else
		src.layer = MOB_LAYER
		src.visible_message("[src] slowly peaks up from the ground...", \
					"<span class='noticealien'>You stop hiding.</span>")

/mob/living/simple_animal/borer/verb/dominate_victim()
	set category = "Borer"
	set name = "Paralyze Victim"
	set desc = "Freeze the limbs of a potential host with supernatural fear."

	if(world.time - used_dominate < 150)
		src << "<span class='boldnotice'>You cannot use that ability again so soon.</span>"
		return

	if(victim)
		src << "<span class='boldnotice'>You cannot do that from within a host body.</span>"
		return

	if(src.stat != CONSCIOUS)
		src << "<span class='boldnotice'>You cannot do that in your current state.</span>"
		return

	var/list/choices = list()
	for(var/mob/living/carbon/C in view(3,src))
		if(C.stat != 2)
			choices += C

	if(world.time - used_dominate < 150)
		src << "<span class='boldnotice'>You cannot use that ability again so soon.</span>"
		return

	var/mob/living/carbon/M = input(src,"Who do you wish to dominate?") in null|choices

	if(!M || !src) return

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.borer)
			src << "<span class='boldnotice'>You cannot infest someone who is already infested!</span>"
			return

	src.layer = MOB_LAYER
	src << "<span class='warning'>You focus your psychic lance on [M] and freeze their limbs with a wave of terrible dread.</span>"
	M << "<span class='userdanger'>You feel a creeping, horrible sense of dread come over you, freezing your limbs and setting your heart racing.</span>"
	M.Weaken(10)

	used_dominate = world.time

/mob/living/simple_animal/borer/verb/release_victim()
	set category = "Borer"
	set name = "Release Host"
	set desc = "Slither out of your host."

	if(!victim)
		src << "<span class='userdanger'>You are not inside a host body.</span>"
		return

	if(stat != CONSCIOUS)
		src << "<span class='userdanger'>You cannot leave your host in your current state.</span>"

	if(!victim || !src) return

	src << "<span class='userdanger'>You begin disconnecting from [victim]'s synapses and prodding at their internal ear canal.</span>"

	if(victim.stat != DEAD)
		host << "<span class='userdanger'>An odd, uncomfortable pressure begins to build inside your skull, behind your ear...</span>"

	spawn(100)

		if(!victim || !src) return

		if(src.stat != CONSCIOUS)
			src << "<span class='userdanger'>You cannot release your host in your current state.</span>"
			return

		src << "<span class='userdanger'>You wiggle out of [victim]'s ear and plop to the ground.</span>"
		if(victim.mind)
			host << "<span class='danger'>Something slimy wiggles out of your ear and plops to the ground!</span>"
			host << "<span class='danger'>As though waking from a dream, you shake off the insidious mind control of the brain worm. Your thoughts are your own again.</span>"

		leave_victim()