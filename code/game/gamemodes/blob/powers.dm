/mob/camera/blob/proc/can_buy(cost = 15)
	if(blob_points < cost)
		src << "<span class='warning'>You cannot afford this!</span>"
		return 0
	add_points(-cost)
	return 1

// Power verbs

/mob/camera/blob/verb/transport_core()
	set category = "Blob"
	set name = "Jump to Core"
	set desc = "Transport back to your core."
	if(blob_core)
		src.loc = blob_core.loc

/mob/camera/blob/verb/jump_to_node()
	set category = "Blob"
	set name = "Jump to Node"
	set desc = "Transport back to a selected node."
	if(blob_nodes.len)
		var/list/nodes = list()
		for(var/i = 1; i <= blob_nodes.len; i++)
			nodes["Blob Node #[i]"] = blob_nodes[i]
		var/node_name = input(src, "Choose a node to jump to.", "Node Jump") in nodes
		var/obj/effect/blob/node/chosen_node = nodes[node_name]
		if(chosen_node)
			src.loc = chosen_node.loc

/mob/camera/blob/proc/createSpecial(price, blobType, nearEquals, turf/T)
	if(!T)
		T = get_turf(src)
	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
	if(!B)
		src << "<span class='warning'>There is no blob here!</span>"
		return
	if(!istype(B, /obj/effect/blob/normal))
		src << "<span class='warning'>Unable to use this blob, find a normal one.</span>"
		return
	if(nearEquals)
		for(var/obj/effect/blob/L in orange(nearEquals, T))
			if(L.type == blobType)
				src << "<span class='warning'>There is a similar blob nearby, move more than [nearEquals] tiles away from it!</span>"
				return
	if(!can_buy(price))
		return
	B.color = blob_reagent_datum.color
	var/obj/effect/blob/N = B.change_to(blobType, src)
	return N

/mob/camera/blob/verb/create_shield_power()
	set category = "Blob"
	set name = "Create Shield Blob (10)"
	set desc = "Create a shield blob."
	create_shield()

/mob/camera/blob/proc/create_shield(turf/T)
	createSpecial(10, /obj/effect/blob/shield, 0, T)

/mob/camera/blob/verb/create_resource()
	set category = "Blob"
	set name = "Create Resource Blob (40)"
	set desc = "Create a resource tower which will generate points for you."
	createSpecial(40, /obj/effect/blob/resource, 4)

/mob/camera/blob/verb/create_node()
	set category = "Blob"
	set name = "Create Node Blob (60)"
	set desc = "Create a Node."
	createSpecial(60, /obj/effect/blob/node, 5)

/mob/camera/blob/verb/create_factory()
	set category = "Blob"
	set name = "Create Factory Blob (60)"
	set desc = "Create a Spore producing blob."
	createSpecial(60, /obj/effect/blob/factory, 7)

/mob/camera/blob/verb/create_storage()
	set category = "Blob"
	set name = "Create Storage Blob (40)"
	set desc = "Create a storage tower which will store extra resources for you. This increases your max resource cap by 50."
	var/obj/effect/blob/storage/R = createSpecial(40, /obj/effect/blob/storage, 3)
	R.update_max_blob_points(50)

/mob/camera/blob/verb/create_blobbernaut()
	set category = "Blob"
	set name = "Create Blobbernaut (20)"
	set desc = "Create a powerful blob-being, a Blobbernaut"
	var/turf/T = get_turf(src)

	if(!T)
		return

	var/obj/effect/blob/B = locate(/obj/effect/blob) in T
	if(!B)
		src << "You must be on a blob!"
		return
	if(!istype(B, /obj/effect/blob/factory))
		src << "Unable to use this blob, find a factory blob."
		return
	if(!can_buy(20))
		return
	var/mob/living/simple_animal/hostile/blob/blobbernaut/blobber = new /mob/living/simple_animal/hostile/blob/blobbernaut (get_turf(B))
	if(blobber)
		qdel(B)
	blobber.color = blob_reagent_datum.color
	blobber.overmind = src
	blob_mobs.Add(blobber)

/mob/camera/blob/verb/relocate_core()
	set category = "Blob"
	set name = "Relocate Core (80)"
	set desc = "Relocates your core to the node you are on, your old core will be turned into a node."
	var/turf/T = get_turf(src)

	if(!blob_core) //Don't allow dead overminds to create new cores
		usr << "You have no core to relocate!"
		return

	if(!T)
		return

	var/obj/effect/blob/node/B = locate(/obj/effect/blob/node) in T
	if(!B)
		src << "You must be on a blob node!"
		return
	if(!can_buy(80))
		return
	var/turf/old_turf = blob_core.loc
	blob_core.loc = T
	B.loc = old_turf

/mob/camera/blob/verb/revert()
	set category = "Blob"
	set name = "Remove Blob"
	set desc = "Removes a blob."
	var/turf/T = get_turf(src)
	if(!T)
		return

	var/obj/effect/blob/B = locate(/obj/effect/blob) in T
	if(!B)
		src << "You must be on a blob!"
		return
	if(istype(B, /obj/effect/blob/core))
		src << "Unable to remove this blob."
		return
	qdel(B)

/mob/camera/blob/verb/expand_blob_power()
	set category = "Blob"
	set name = "Expand/Attack Blob (5)"
	set desc = "Attempts to create a new blob in this tile. If the tile isn't clear we will attack it, which might clear it."
	var/turf/T = get_turf(src)
	expand_blob(T)

/mob/camera/blob/proc/expand_blob(turf/T)//tg's nicer proc
	if(!can_attack())
		return
	var/obj/effect/blob/OB = locate() in circlerange(T, 1)
	if(!OB)
		src << "<span class='warning'>There is no blob adjacent to the target tile!</span>"
		return
	if(can_buy(5))
		var/attacksuccess = FALSE
		last_attack = world.time
		for(var/mob/living/L in T)
			if("blob" in L.faction) //no friendly/dead fire
				continue
			if(L.stat != DEAD)
				attacksuccess = TRUE
			var/mob_protection = L.get_permeability_protection()
			blob_reagent_datum.reaction_mob(L, VAPOR, 25, 1, mob_protection, src)
			blob_reagent_datum.send_message(L)
		var/obj/effect/blob/B = locate() in T
		if(B)
			if(attacksuccess) //if we successfully attacked a turf with a blob on it, don't refund shit
				B.blob_attack_animation(T, src)
			else
				src << "<span class='warning'>There is a blob there!</span>"
				add_points(5) //otherwise, refund all of the cost
			return
		else
			OB.expand(T, src)
			OB.update_icon()
/*/mob/camera/blob/proc/expand_blob(turf/T) //yog's older proc
	if(!T)
		return

	if(!can_attack())
		return
	var/obj/effect/blob/B = locate() in T
	if(B)
		src << "There is a blob here!"
		return
	var/obj/effect/blob/OB = locate() in circlerange(T, 1)
	if(!OB)
		src << "There is no blob adjacent to you."
		return
	if(!can_buy(5))
		return
	last_attack = world.time
	OB.expand(T, src)
	for(var/mob/living/L in T)
		blob_reagent_datum.reaction_mob(L, TOUCH, 25)
		blob_reagent_datum.send_message(L)
	OB.color = blob_reagent_datum.color*/

/mob/camera/blob/verb/rally_spores_power()
	set category = "Blob"
	set name = "Rally Spores (5)"
	set desc = "Rally the spores to move to your location."
	var/turf/T = get_turf(src)
	rally_spores(T)

/mob/camera/blob/proc/rally_spores(turf/T)
	if(!can_buy(5))
		return
	src << "You rally your spores."
	var/list/surrounding_turfs = block(locate(T.x - 1, T.y - 1, T.z), locate(T.x + 1, T.y + 1, T.z))
	if(!surrounding_turfs.len)
		return
	for(var/mob/living/simple_animal/hostile/blob/blobspore/BS in living_mob_list)
		if(isturf(BS.loc) && get_dist(BS, T) <= 35)
			BS.LoseTarget()
			BS.Goto(pick(surrounding_turfs), BS.move_to_delay)

/mob/camera/blob/verb/split_consciousness()
	set category = "Blob"
	set name = "Split consciousness (100) (One use)"
	set desc = "Expend resources to attempt to produce another sentient overmind"

	if(!blob_core)
		src << "You do not have a core to split yourself."
		return

	var/turf/T = get_turf(src)
	var/obj/effect/blob/node/B = locate(/obj/effect/blob/node) in T

	if(!B)
		src << "<span class='warning'>You must be on a blob node!</span>"
		return

	if(!can_buy(100))
		return

	verbs -= /mob/camera/blob/verb/split_consciousness
	new /obj/effect/blob/core/(get_turf(B), 200, null, blob_core.point_rate, "offspring")
	qdel(B)
	if(ticker && ticker.mode.name == "blob")
		var/datum/game_mode/blob/BL = ticker.mode
		BL.blobwincount = initial(BL.blobwincount) * 2

/mob/camera/blob/verb/blob_broadcast()
	set category = "Blob"
	set name = "Blob Broadcast"
	set desc = "Speak with your blob spores and blobbernauts as your mouthpieces. This action is free."
	var/speak_text = input(usr, "What would you like to say with your minions?", "Blob Broadcast", null) as text
	if(!speak_text)
		return
	else
		usr << "You broadcast with your minions, <B>[speak_text]</B>"
	for(var/mob/living/simple_animal/hostile/blob_minion in blob_mobs)
		blob_minion.say(speak_text)
	return
//new tg system
/mob/camera/blob/verb/chemical_reroll()
	set category = "Blob"
	set name = "Reactivate Chemical Adaptation (40)"
	set desc = "Replaces your chemical with a random, different one."
	if(free_chem_rerolls || can_buy(40))
		set_chemical()
		if(free_chem_rerolls)
			free_chem_rerolls--

/mob/camera/blob/proc/set_chemical()
	var/datum/reagent/blob/BC = pick((subtypesof(/datum/reagent/blob) - blob_reagent_datum.type))
	blob_reagent_datum = new BC
	for(var/BL in blobs)
		var/obj/effect/blob/B = BL
		B.adjustcolors(blob_reagent_datum.color)
	for(var/BLO in blob_mobs)
		var/mob/living/simple_animal/hostile/blob/BM = BLO
		BM.adjustcolors(blob_reagent_datum.color) //If it's getting a new chemical, tell it what it does!
	src << "Your reagent is now: <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font>!"
	src << "The <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font> reagent [blob_reagent_datum.description]"

/mob/camera/blob/verb/blob_help()
	set category = "Blob"
	set name = "*Blob Help*"
	set desc = "Help on how to blub."
	src << "<b>As the overmind, you can control the blob!</b>"
	src << "Your blob reagent is: <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font>!"
	src << "The <b><font color=\"[blob_reagent_datum.color]\">[blob_reagent_datum.name]</b></font> reagent [blob_reagent_datum.description]"
	src << "<b>You can expand, which will attack people, damage objects, or place a Normal Blob if the tile is clear.</b>"
	src << "<b><i>Normal Blobs</i></b> will expand your reach and can be upgraded into special blobs that perform certain functions."
	src << "<b>You can upgrade normal blobs into the following types of blob:</b>"
	src << "<b><i>Shield Blobs</i></b> are strong and expensive blobs which take more damage. In additon, they are fireproof and can block air, use these to protect yourself from station fires."
	src << "<b><i>Resource Blobs</i></b> are blobs which produce more resources for you, build as many of these as possible to consume the station. This type of blob must be placed near node blobs or your core to work."
	src << "<b><i>Factory Blobs</i></b> are blobs that spawn blob spores which will attack nearby enemies. This type of blob must be placed near node blobs or your core to work."
	src << "<b><i>Blobbernauts</i></b> can be produced from factories for a cost, and are hard to kill, powerful, and moderately smart. The factory used to create one will become fragile and permanently unable to produce spores."
	src << "<b><i>Node Blobs</i></b> are blobs which grow, like the core. Like the core it can activate resource and factory blobs."
	src << "<b>In addition to the buttons on your HUD, there are a few click shortcuts to speed up expansion and defense.</b>"
	src << "<b>CTRL Click</b> = Expand Blob / <b>Middle Mouse Click</b> = Rally Spores / <b>Alt Click</b> = Create Shield"
//old yog system
/*/mob/camera/blob/verb/chemical_reroll()
	set category = "Blob"
	set name = "Reactive Chemical Adaptation (50)"
	set desc = "Replaces your chemical with a different one"
	if(!can_buy(50))
		return

	var/list/excluded = list(/datum/reagent/blob, blob_reagent_datum.type) //guaranteed new chemical
	var/datum/reagent/blob/B = pick((typesof(/datum/reagent/blob) - excluded))
	blob_reagent_datum = new B
	for(var/obj/effect/blob/BL in blobs)
		BL.adjustcolors(blob_reagent_datum.color)
	for(var/mob/living/simple_animal/hostile/blob/BLO)
		BLO.adjustcolors(blob_reagent_datum.color)
	src << "Your reagent is now: <b>[blob_reagent_datum.name]</b>!"*/