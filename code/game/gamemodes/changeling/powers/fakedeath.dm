/obj/effect/proc_holder/resource_ability/changeling/fakedeath
	name = "Regenerative Stasis"
	desc = "We fall into a stasis, allowing us to regenerate and trick our enemies."
	resource_cost = 15
	dna_cost = 0
	req_dna = 1
	req_stat = DEAD
	max_genetic_damage = 100


//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/obj/effect/proc_holder/resource_ability/changeling/fakedeath/sting_action(mob/living/carbon/user)
	user << "<span class='notice'>We begin our stasis, preparing energy to arise once more.</span>"
	user.status_flags |= FAKEDEATH		//play dead
	user.update_canmove()
	if(user.stat != DEAD)
		user.emote("deathgasp")
		user.tod = worldtime2text()
	spawn(LING_FAKEDEATH_TIME)
		if(user && user.mind && user.mind.changeling)
			user << "<span class='notice'>We are ready to regenerate.</span>"
			user.AddAbility(new /obj/effect/proc_holder/resource_ability/changeling/revive(null))
	feedback_add_details("changeling_powers","FD")
	return 1

/obj/effect/proc_holder/resource_ability/changeling/fakedeath/can_sting(mob/user)
	if(user.status_flags & FAKEDEATH)
		user << "<span class='warning'>We are already regenerating.</span>"
		return
	if(!user.stat) //Confirmation for living changelings if they want to fake their death
		switch(alert("Are we sure we wish to fake our own death?",,"Yes", "No"))
			if("No")
				return
	return ..()