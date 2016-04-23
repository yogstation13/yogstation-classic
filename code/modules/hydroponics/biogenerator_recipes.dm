/datum/biogenerator_recipe
	var/item = /obj/item/weapon/storage/bag/ore
	var/name = "" //should be unique
	var/base_cost = 0
	var/possible_amounts = list(1)
	var/category = "Miscellaneous"

/datum/biogenerator_recipe/proc/create_item(obj/machinery/biogenerator/gen)//returns null if item creation failed, 1 otherwise.
	if(gen.check_cost(base_cost / gen.efficiency))
		return 0
	new item(gen.loc)
	return 1

/datum/biogenerator_recipe/reagent
	item = "" //reusing this var as the string ID of the reagent.
	possible_amounts = list(1, 5)

/datum/biogenerator_recipe/reagent/create_item(obj/machinery/biogenerator/gen)
	if(gen.check_cost(base_cost / gen.efficiency))
		return 0
	if(gen.check_container_volume(10))
		return 0
	gen.beaker.reagents.add_reagent(item, 10)
	return 1

/datum/biogenerator_recipe/reagent/milk
	name = "10 Milk"
	item = "milk"
	base_cost = 20
	category = "Food"

/datum/biogenerator_recipe/reagent/cream
	name = "10 Cream"
	item = "cream"
	base_cost = 30
	category = "Food"

/datum/biogenerator_recipe/milk_carton
	name = "Empty Milk Carton"
	item = /obj/item/weapon/reagent_containers/food/condiment/milk
	base_cost = 100
	possible_amounts = list(1, 5)
	category = "Food"

/datum/biogenerator_recipe/cream_carton
	name = "Empty Cream Carton"
	item = /obj/item/weapon/reagent_containers/food/drinks/bottle/cream
	base_cost = 300
	possible_amounts = list(1, 5)
	category = "Food"

/datum/biogenerator_recipe/monkey_cube
	name = "Monkey Cube"
	item = /obj/item/weapon/reagent_containers/food/snacks/monkeycube
	base_cost = 250
	possible_amounts = list(1, 5)
	category = "Food"

/datum/biogenerator_recipe/ez_nutrient
	name = "EZ Nutrient"
	item = /obj/item/weapon/reagent_containers/glass/bottle/nutrient/ez
	base_cost = 10
	possible_amounts = list(1, 5)
	category = "Botany Chemicals"

/datum/biogenerator_recipe/left_4_zed
	name = "Left 4 Zed"
	item = /obj/item/weapon/reagent_containers/glass/bottle/nutrient/l4z
	base_cost = 20
	possible_amounts = list(1, 5)
	category = "Botany Chemicals"

/datum/biogenerator_recipe/robust_harvest
	name = "Robust Harvest"
	item = /obj/item/weapon/reagent_containers/glass/bottle/nutrient/rh
	base_cost = 25
	possible_amounts = list(1, 5)
	category = "Botany Chemicals"

/datum/biogenerator_recipe/weed_killer
	name = "Weedkiller"
	item = /obj/item/weapon/reagent_containers/glass/bottle/weedkiller
	base_cost = 50
	possible_amounts = list(1, 5)
	category = "Botany Chemicals"

/datum/biogenerator_recipe/pest_spray
	name = "Pest Spray"
	item = /obj/item/weapon/reagent_containers/glass/bottle/pestkiller
	base_cost = 50
	possible_amounts = list(1, 5)
	category = "Botany Chemicals"

/datum/biogenerator_recipe/wallet
	name = "Wallet"
	item = /obj/item/weapon/storage/wallet
	base_cost = 100
	category = "Leather and Cloth"

/datum/biogenerator_recipe/bookbag
	name = "Book Bag"
	item = /obj/item/weapon/storage/bag/books
	base_cost = 200
	category = "Leather and Cloth"

/datum/biogenerator_recipe/plantbag
	name = "Plant Bag"
	item = /obj/item/weapon/storage/bag/plants
	base_cost = 200
	category = "Leather and Cloth"

/datum/biogenerator_recipe/orebag
	name = "Mining Satchel"
	item = /obj/item/weapon/storage/bag/ore
	base_cost = 200
	category = "Leather and Cloth"

/datum/biogenerator_recipe/chemistrybag
	name = "Chemistry Bag"
	item = /obj/item/weapon/storage/bag/chemistry
	base_cost = 200
	category = "Leather and Cloth"

/datum/biogenerator_recipe/rag
	name = "Rag"
	item = /obj/item/weapon/reagent_containers/glass/rag
	base_cost = 200
	category = "Leather and Cloth"

/datum/biogenerator_recipe/botany_gloves
	name = "Botanical Gloves"
	item = /obj/item/clothing/gloves/botanic_leather
	base_cost = 250
	category = "Leather and Cloth"

/datum/biogenerator_recipe/toolbelt
	name = "Toolbelt"
	item = /obj/item/weapon/storage/belt/utility
	base_cost = 300
	category = "Leather and Cloth"

/datum/biogenerator_recipe/securitybelt
	name = "Security Belt"
	item = /obj/item/weapon/storage/belt/security
	base_cost = 300
	category = "Leather and Cloth"

/datum/biogenerator_recipe/medicalbelt
	name = "Medical Belt"
	item = /obj/item/weapon/storage/belt/medical
	base_cost = 300
	category = "Leather and Cloth"

/datum/biogenerator_recipe/janitorbelt
	name = "Janitorial Belt"
	item = /obj/item/weapon/storage/belt/janitor
	base_cost = 300
	category = "Leather and Cloth"

/datum/biogenerator_recipe/bandolier
	name = "Bandolier"
	item = /obj/item/weapon/storage/belt/bandolier
	base_cost = 300
	category = "Leather and Cloth"

/datum/biogenerator_recipe/holster
	name = "Shoulder Holster"
	item = /obj/item/weapon/storage/belt/holster
	base_cost = 400
	category = "Leather and Cloth"

/datum/biogenerator_recipe/satchel
	name = "Leather Sachel"
	item = /obj/item/weapon/storage/backpack/satchel
	base_cost = 400
	category = "Leather and Cloth"

/datum/biogenerator_recipe/leather_jacket
	name = "Leather Jacket"
	item = /obj/item/clothing/suit/jacket/leather
	base_cost = 500
	category = "Leather and Cloth"

/datum/biogenerator_recipe/leather_overcoat
	name = "Leather Overcoat"
	item = /obj/item/clothing/suit/jacket/leather/overcoat
	base_cost = 1000
	category = "Leather and Cloth"

/datum/biogenerator_recipe/rice_hat
	name = "Rice Hat"
	item = /obj/item/clothing/head/rice_hat
	base_cost = 300
	category = "Leather and Cloth"
