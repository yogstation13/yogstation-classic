///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/list/required_reagents = new/list()
	var/list/required_catalysts = new/list()

	// Both of these variables are mostly going to be used with slime cores - but if you want to, you can use them for other things
	var/atom/required_container = null // the container required for the reaction to happen
	var/required_other = 0 // an integer required for the reaction to happen

	var/result_amount = 0
	var/secondary = 0 // set to nonzero if secondary reaction
	var/mob_react = 0 //Determines if a chemical reaction can occur inside a mob

	var/required_temp = 0
	var/mix_message = "The solution begins to bubble."

/datum/chemical_reaction/proc/on_reaction(datum/reagents/holder, created_volume)
	return
	//I recommend you set the result amount to the total volume of all components.


/datum/chemical_reaction/proc/chemical_mob_spawn(datum/reagents/holder, amount_to_spawn, reaction_name, mob_faction = "chemicalsummon")
	if(holder && holder.my_atom)
		var/blocked = list(/mob/living/simple_animal/hostile,
			/mob/living/simple_animal/hostile/pirate,
			/mob/living/simple_animal/hostile/pirate/ranged,
			/mob/living/simple_animal/hostile/russian,
			/mob/living/simple_animal/hostile/russian/ranged,
			/mob/living/simple_animal/hostile/syndicate,
			/mob/living/simple_animal/hostile/syndicate/melee,
			/mob/living/simple_animal/hostile/syndicate/melee/space,
			/mob/living/simple_animal/hostile/syndicate/ranged,
			/mob/living/simple_animal/hostile/syndicate/ranged/orion,
			/mob/living/simple_animal/hostile/syndicate/ranged/space,
			/mob/living/simple_animal/hostile/alien/queen/large,
			/mob/living/simple_animal/hostile/mushroom,
			/mob/living/simple_animal/hostile/asteroid,
			/mob/living/simple_animal/hostile/retaliate,
			/mob/living/simple_animal/hostile/asteroid/basilisk,
			/mob/living/simple_animal/hostile/asteroid/goldgrub,
			/mob/living/simple_animal/hostile/asteroid/goliath,
			/mob/living/simple_animal/hostile/asteroid/hivelord,
			/mob/living/simple_animal/hostile/asteroid/hivelordbrood,
			/mob/living/simple_animal/hostile/carp/holocarp,
			/mob/living/simple_animal/hostile/mining_drone,
			/mob/living/simple_animal/hostile/poison,
			/mob/living/simple_animal/hostile/blob,
			/mob/living/simple_animal/ascendant_shadowling,
			/mob/living/simple_animal/hostile/guardian,
			/mob/living/simple_animal/hostile/guardian/fire,
			/mob/living/simple_animal/hostile/guardian/punch,
			/mob/living/simple_animal/hostile/guardian/fast,
			/mob/living/simple_animal/hostile/guardian/healer,
			/mob/living/simple_animal/hostile/guardian/ranged,
			/mob/living/simple_animal/hostile/guardian/bluespace,
			/mob/living/simple_animal/hostile/guardian/bomb,
			/mob/living/simple_animal/hostile/guardian/shield,
			/mob/living/simple_animal/hostile/carp/tactical,
			/mob/living/simple_animal/hostile/retaliate/dolphin/tactical
			)//exclusion list for things you don't want the reaction to create.
		var/list/specialcritters = list(/mob/living/simple_animal/borer,/obj/item/unactivated_swarmer)  //Speshul mobs for speshul reactions
		var/list/meancritters = typesof(/mob/living/simple_animal/hostile) - blocked // list of possible hostile mobs
		var/list/nicecritters = list(/mob/living/simple_animal/crab,
		                        /mob/living/simple_animal/mouse,
		                        /mob/living/simple_animal/lizard,
		                        /mob/living/simple_animal/parrot,
		                        /mob/living/simple_animal/butterfly,
		                        /mob/living/simple_animal/cow,
		                        /mob/living/simple_animal/chicken) // and possible friendly mobs
		nicecritters += typesof(/mob/living/simple_animal/pet) - /mob/living/simple_animal/pet
		var/atom/A = holder.my_atom
		var/turf/T = get_turf(A)
		var/area/my_area = get_area(T)
		var/message = "A [reaction_name] reaction has occured in [my_area.name]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</A>)"
		message += " (<A HREF='?_src_=vars;Vars=\ref[A]'>VV</A>)"

		var/mob/M = get(A, /mob)
		if(M)
			message += " - Carried By: [key_name_admin(M)](<A HREF='?_src_=holder;adminmoreinfo=\ref[M]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[M]'>FLW</A>)"
		else
			message += " - Last Fingerprint: [(A.fingerprintslast ? A.fingerprintslast : "N/A")]"

		message_admins(message, 0, 1)

		playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

		for(var/mob/living/carbon/C in viewers(get_turf(holder.my_atom), null))
			C.flash_eyes()
		for(var/i = 1, i <= amount_to_spawn, i++)
			if (reaction_name == "Friendly Gold Slime")
				var/chosen = pick(nicecritters)
				var/mob/living/simple_animal/C = new chosen
				C.faction |= mob_faction
				C.loc = get_turf(holder.my_atom)
				if(prob(50))
					for(var/j = 1, j <= rand(1, 3), j++)
						step(C, pick(NORTH,SOUTH,EAST,WEST))
			if(reaction_name == "Lesser Gold Slime" || reaction_name == "Gold Slime")
				var/chosen = pick(meancritters)
				var/mob/living/simple_animal/C = new chosen
				C.faction |= mob_faction
				C.loc = get_turf(holder.my_atom)
				if(prob(50))
					for(var/j = 1, j <= rand(1, 3), j++)
						step(C, pick(NORTH,SOUTH,EAST,WEST))

			if(reaction_name == "Strange Gold Slime")  //Sooper Sekrit, don't tell anyone!
				var/chosen = pick(specialcritters)
				switch(chosen)
					if(/mob/living/simple_animal/borer)
						//Spawn and populate a borer
						var/mob/living/simple_animal/borer/B = new
						B.loc = get_turf(holder.my_atom)
						if(prob(50))
							for(var/j = 1, j <= rand(1, 3), j++)
								step(B, pick(NORTH,SOUTH,EAST,WEST))
						for(var/mob/O in viewers(get_turf(holder.my_atom),null))
							O.show_message(text("<span class='notice'>Some sort of alien slug has crawled out of the slime extract!</span>"), 1)

						var/list/candidates = get_candidates(BE_ALIEN, ALIEN_AFK_BRACKET)
						if(!candidates.len)
							//Spawn a non player controlled borer, animatable with light pink slime potion
							for(var/mob/O in viewers(get_turf(holder.my_atom),null))
								O.show_message(text("<span class='notice'>You get a vague feeling that something is missing.</span>"), 1)  //Alert bystanders that their borer is braindead
						else
							B.transfer_personality(pick(candidates))
							B << "<span class='warning'>You realize that you are self aware!</span>"
							B << "<span class='userdanger'>You owe the person who gave you life a great debt.</span>"
							B << "<span class='userdanger'>Serve your creator, and help them accomplish their goals at all costs.</span>"

					if(/obj/item/unactivated_swarmer)
						var/obj/item/unactivated_swarmer/U = new
						U.loc = get_turf(holder.my_atom)
						U.creator = 1
						if(prob(50))
							for(var/j = 1, j <= rand(1, 3), j++)
								step(U, pick(NORTH,SOUTH,EAST,WEST))
						for(var/mob/O in viewers(get_turf(holder.my_atom),null))
							O.show_message(text("<span class='notice'>The slime extract shudders, then forms some sort of alien machine!</span>"), 1)

/datum/chemical_reaction/proc/goonchem_vortex(turf/simulated/T, setting_type, range)
	for(var/atom/movable/X in orange(range, T))
		if(istype(X, /obj/effect))
			continue
		if(!X.anchored)
			var/distance = get_dist(X, T)
			var/moving_power = max(range - distance, 1)
			spawn(0) //so everything moves at the same time.
				if(moving_power > 2) //if the vortex is powerful and we're close, we get thrown
					if(setting_type)
						var/atom/throw_target = get_edge_target_turf(X, get_dir(X, get_step_away(X, T)))
						X.throw_at(throw_target, moving_power, 1)
					else
						X.throw_at(T, moving_power, 1)
				else
					if(setting_type)
						for(var/i = 0, i < moving_power, i++)
							sleep(2)
							if(!step_away(X, T))
								break
					else
						for(var/i = 0, i < moving_power, i++)
							sleep(2)
							if(!step_towards(X, T))
								break
