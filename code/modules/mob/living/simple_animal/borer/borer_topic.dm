
/mob/living/simple_animal/borer/Topic(href, href_list, hsrc)
	if(href_list["borer_refresh"])
		src.show_panel()
	if(href_list["borer_evolve"])
		if(src.stat != CONSCIOUS)
			return

		var/evolution_name = href_list["borer_evolve"]

		var/datum/borer_tech/evolution = null

		for(var/datum/borer_tech/tech in borer_tech_tree.techs)
			if(tech.tech_name == evolution_name)
				evolution = tech
				break

		if(!evolution)
			return

		var/evolve_quantity = input(usr, "How many chemicals to donate?.", "How many?") as num|null
		if(!evolve_quantity)
			return

		if(!src || src.stat != CONSCIOUS)
			return



		evolve_quantity = min(evolution.chemicals_required_for_research - evolution.current_chemicals, evolve_quantity)
		if(src.chemicals < evolve_quantity)
			src << "<span class='warning'>You dont have [evolve_quantity] chemicals.</span>"
			return

		evolution.current_chemicals += evolve_quantity
		src.chemicals -= evolve_quantity

		if(evolution.current_chemicals >= evolution.chemicals_required_for_research)
			evolution.evolveBorers()

		src.show_panel()

	if(href_list["borer_use_chem"])
		var/mob/living/simple_animal/borer/B = locate(href_list["_src_"])
		if(!istype(B, /mob/living/simple_animal/borer))
			return

		var/topic_chem = href_list["borer_use_chem"]
		var/datum/borer_chem/C

		for(var/datum in typesof(/datum/borer_chem))
			var/datum/borer_chem/test = new datum()
			if(test.chemname == topic_chem)
				C = test
				break

		if(!istype(C, /datum/borer_chem))
			return

		if(!C || !victim || controlling || !src || stat)
			return

		if(!istype(C, /datum/borer_chem))
			return

		if(chemicals < C.chemuse)
			src << "<span class='boldnotice'>You need [C.chemuse] chemicals stored to use this chemical!</span>"
			return

		src << "<span class='userdanger'>You squirt a measure of [C.chemname] from your reservoirs into [victim]'s bloodstream.</span>"
		victim.reagents.add_reagent(C.chemname, C.quantity)
		chemicals -= C.chemuse
		influence += C.influence_change
		if(influence > 100)
			influence = 100
		if(influence < 0)
			influence = 0
		log_game("[src]/([src.ckey]) has injected [C.chemname] into their host [victim]/([victim.ckey])")

		B << output(chemicals, "ViewBorer\ref[B]Chems.browser:update_chemicals")
		B << output(influence, "ViewBorer\ref[B]Chems.browser:update_influence")

	..()