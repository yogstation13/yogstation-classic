/obj/machinery/biogenerator
	name = "Biogenerator"
	desc = "Converts plants into biomass, which can be used to construct useful items."
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-empty"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/points = 0
	var/menustat = "menu"
	var/efficiency = 0
	var/productivity = 0
	var/max_items = 40
	var/list/datum/biogenerator_recipe/recipes_known = list()

/obj/machinery/biogenerator/New()
		..()
		create_reagents(1000)
		component_parts = list()
		component_parts += new /obj/item/weapon/circuitboard/biogenerator(null)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
		component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
		component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
		component_parts += new /obj/item/stack/cable_coil(null, 1)
		RefreshParts()
		recipes_known = get_initial_recipes()

/obj/machinery/biogenerator/RefreshParts()
	var/E = 0
	var/P = 0
	var/max_storage = 40
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		P += B.rating
		max_storage = 40 * B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		E += M.rating
	efficiency = E
	productivity = P
	max_items = max_storage

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(panel_open)
		icon_state = "biogen-empty-o"
	else if(!src.beaker)
		icon_state = "biogen-empty"
	else if(!src.processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/reagent_containers/glass) && !panel_open)
		if(beaker)
			user << "<span class='warning'>A container is already loaded into the machine.</span>"
		else
			user.unEquip(O)
			O.loc = src
			beaker = O
			user << "<span class='notice'>You add the container to the machine.</span>"
			updateUsrDialog()
	else if(processing)
		user << "<span class='warning'>The biogenerator is currently processing.</span>"
	else if(istype(O, /obj/item/weapon/storage/bag/plants))
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= max_items)
			user << "<span class='warning'>The biogenerator is already full! Activate it.</span>"
		else
			for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in O.contents)
				if(i >= max_items)
					break
				G.remove_item_from_storage(src)
				i++
			if(i<max_items)
				user << "<span class='info'>You empty the plant bag into the biogenerator.</span>"
			else if(O.contents.len == 0)
				user << "<span class='info'>You empty the plant bag into the biogenerator, filling it to its capacity.</span>"
			else
				user << "<span class='info'>You fill the biogenerator to its capacity.</span>"


	else if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		user << "<span class='warning'>You cannot put this in [src.name]!</span>"
	else
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= max_items)
			user << "<span class='warning'>The biogenerator is full! Activate it.</span>"
		else
			user.unEquip(O)
			O.loc = src
			user << "<span class='info'>You put [O.name] in [src.name]</span>"

	if(!processing)
		if(default_deconstruction_screwdriver(user, "biogen-empty-o", "biogen-empty", O))
			if(beaker)
				var/obj/item/weapon/reagent_containers/glass/B = beaker
				B.loc = loc
				beaker = null

	if(exchange_parts(user, O))
		return

	default_deconstruction_crowbar(O)

	update_icon()
	return

/obj/machinery/biogenerator/interact(mob/user)
	if(stat & BROKEN || panel_open)
		return
	user.set_machine(src)
	var/dat
	if(processing)
		dat += "<div class='statusDisplay'>Biogenerator is processing! Please wait...</div><BR>"
	else
		switch(menustat)
			if("nopoints")
				dat += "<div class='statusDisplay'>You do not have biomass to create products.<BR>Please, put growns into reactor and activate it.</div>"
				menustat = "menu"
			if("complete")
				dat += "<div class='statusDisplay'>Operation complete.</div>"
				menustat = "menu"
			if("void")
				dat += "<div class='statusDisplay'>Error: No growns inside.<BR>Please, put growns into reactor.</div>"
				menustat = "menu"
			if("nobeakerspace")
				dat += "<div class='statusDisplay'>Not enough space left in container. Unable to create product.</div>"
				menustat = "menu"
		if(beaker)
			var/list/sorted_recipes = list("Food" = list(), "Botany Chemicals" = list(), "Leather and Cloth" = list())
			for(var/V in recipes_known)
				var/datum/biogenerator_recipe/R = V
				var/pointer = sorted_recipes[R.category]
				if(pointer)
					pointer += R
				else
					sorted_recipes += R.category
					sorted_recipes[R.category] = list(R)
			dat += "<div class='statusDisplay'>Biomass: [points] units.</div><BR>"
			dat += "<A href='?src=\ref[src];activate=1'>Activate</A><A href='?src=\ref[src];detach=1'>Detach Container</A>"

			for(var/category in sorted_recipes)
				dat += "<h3>[category]:</h3><div class='statusDisplay'>"
				for(var/V in sorted_recipes[category])
					var/datum/biogenerator_recipe/R = V
					dat += "[R.name]: "
					for(var/amt in R.possible_amounts)
						dat += "<A href='?src=\ref[src];create=[R.name];amount=[amt]'>[amt == 1 ? "Make" : "x[amt]"]</A> "
					dat += "([R.base_cost/efficiency])<br>"
				dat += "</div>"
		else
			dat += "<div class='statusDisplay'>No container inside, please insert container.</div>"

	var/datum/browser/popup = new(user, "biogen", name, 350, 520)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/biogenerator/attack_hand(mob/user)
	interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat != 0)
		return
	if (src.stat != 0) //NOPOWER etc
		return
	if(src.processing)
		usr << "<span class='warning'>The biogenerator is in the process of working.</span>"
		return
	var/S = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1*productivity
		else points += I.reagents.get_reagent_amount("nutriment")*10*productivity
		qdel(I)
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(S*30)
		sleep(S+15/productivity)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/check_cost(cost)
	if (cost > points)
		menustat = "nopoints"
		return 1
	else
		points -= cost
		processing = 1
		update_icon()
		updateUsrDialog()
		return 0

/obj/machinery/biogenerator/proc/check_container_volume(reagent_amount)
	if(!beaker || beaker.reagents.total_volume + reagent_amount > beaker.reagents.maximum_volume)
		menustat = "nobeakerspace"
		return 1

/obj/machinery/biogenerator/proc/create_product(datum/biogenerator_recipe/recipe)
	if(recipe.create_item(src))
		processing = 0
		menustat = "complete"
		update_icon()
		return 1

/obj/machinery/biogenerator/proc/detach()
	if(beaker)
		beaker.loc = src.loc
		beaker = null
		update_icon()

/obj/machinery/biogenerator/proc/get_initial_recipes()
	var/list/L = list()
	for(var/T in subtypesof(/datum/biogenerator_recipe) - /datum/biogenerator_recipe/reagent)
		L += new T()
	return L

/obj/machinery/biogenerator/Topic(href, href_list)
	if(..() || panel_open)
		return

	usr.set_machine(src)

	if(href_list["activate"])
		activate()
		updateUsrDialog()

	else if(href_list["detach"])
		detach()
		updateUsrDialog()

	else if(href_list["create"])
		var/amount = (text2num(href_list["amount"]))
		var/C = href_list["create"]
		for(var/V in recipes_known)
			var/datum/biogenerator_recipe/R = V
			if(R.name == C)
				for(var/i=0, i<amount, i++)
					create_product(R)
				break
		updateUsrDialog()

	else if(href_list["menu"])
		menustat = "menu"
		updateUsrDialog()

