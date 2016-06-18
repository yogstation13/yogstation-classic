/datum/design/biogenerator
	reliability = 100				//Reliability of the device.
	build_type = BIOGENERATOR
	var/possible_amounts = list(1)

/datum/design/biogenerator/proc/create_item(obj/machinery/biogenerator/gen)//returns null if build_path creation failed, 1 otherwise.
	if(gen.check_cost(materials[MAT_BIOMASS] / gen.efficiency))
		return 0
	new build_path(gen.loc)
	return 1

/datum/design/biogenerator/reagent
	build_path = "" //reusing this var as the string ID of the reagent.
	possible_amounts = list(1, 5)

/datum/design/biogenerator/reagent/create_item(obj/machinery/biogenerator/gen)
	if(gen.check_cost(materials[MAT_BIOMASS] / gen.efficiency))
		return 0
	if(gen.check_container_volume(10))
		return 0
	gen.beaker.reagents.add_reagent(build_path, 10)
	return 1

/datum/design/biogenerator/reagent/milk
	name = "10 Milk"
	build_path = "milk"
	materials = list(MAT_BIOMASS =  20)
	category = list("Food")

/datum/design/biogenerator/reagent/cream
	name = "10 Cream"
	build_path = "cream"
	materials = list(MAT_BIOMASS =  30)
	category = list("Food")

/datum/design/biogenerator/milk_carton
	name = "Empty Milk Carton"
	build_path = /obj/item/weapon/reagent_containers/food/condiment/milk
	materials = list(MAT_BIOMASS =  100)
	possible_amounts = list(1, 5)
	category = list("Food")

/datum/design/biogenerator/cream_carton
	name = "Empty Cream Carton"
	build_path = /obj/item/weapon/reagent_containers/food/drinks/bottle/cream
	materials = list(MAT_BIOMASS =  300)
	possible_amounts = list(1, 5)
	category = list("Food")

/datum/design/biogenerator/monkey_cube
	name = "Monkey Cube"
	build_path = /obj/item/weapon/reagent_containers/food/snacks/monkeycube
	materials = list(MAT_BIOMASS =  250)
	possible_amounts = list(1, 5)
	category = list("Food")

/datum/design/biogenerator/ez_nutrient
	name = "EZ Nutrient"
	build_path = /obj/item/weapon/reagent_containers/glass/bottle/nutrient/ez
	materials = list(MAT_BIOMASS =  10)
	possible_amounts = list(1, 5)
	category = list("Botany Chemicals")

/datum/design/biogenerator/left_4_zed
	name = "Left 4 Zed"
	build_path = /obj/item/weapon/reagent_containers/glass/bottle/nutrient/l4z
	materials = list(MAT_BIOMASS =  20)
	possible_amounts = list(1, 5)
	category = list("Botany Chemicals")

/datum/design/biogenerator/robust_harvest
	name = "Robust Harvest"
	build_path = /obj/item/weapon/reagent_containers/glass/bottle/nutrient/rh
	materials = list(MAT_BIOMASS =  25)
	possible_amounts = list(1, 5)
	category = list("Botany Chemicals")

/datum/design/biogenerator/weed_killer
	name = "Weedkiller"
	build_path = /obj/item/weapon/reagent_containers/glass/bottle/weedkiller
	materials = list(MAT_BIOMASS =  50)
	possible_amounts = list(1, 5)
	category = list("Botany Chemicals")

/datum/design/biogenerator/pest_spray
	name = "Pest Spray"
	build_path = /obj/item/weapon/reagent_containers/glass/bottle/pestkiller
	materials = list(MAT_BIOMASS =  50)
	possible_amounts = list(1, 5)
	category = list("Botany Chemicals")

/datum/design/biogenerator/wallet
	name = "Wallet"
	build_path = /obj/item/weapon/storage/wallet
	materials = list(MAT_BIOMASS =  100)
	category = list("Leather and Cloth")

/datum/design/biogenerator/bookbag
	name = "Book Bag"
	build_path = /obj/item/weapon/storage/bag/books
	materials = list(MAT_BIOMASS =  200)
	category = list("Leather and Cloth")

/datum/design/biogenerator/plantbag
	name = "Plant Bag"
	build_path = /obj/item/weapon/storage/bag/plants
	materials = list(MAT_BIOMASS =  200)
	category = list("Leather and Cloth")

/datum/design/biogenerator/orebag
	name = "Mining Satchel"
	build_path = /obj/item/weapon/storage/bag/ore
	materials = list(MAT_BIOMASS =  200)
	category = list("Leather and Cloth")

/datum/design/biogenerator/chemistrybag
	name = "Chemistry Bag"
	build_path = /obj/item/weapon/storage/bag/chemistry
	materials = list(MAT_BIOMASS =  200)
	category = list("Leather and Cloth")

/datum/design/biogenerator/rag
	name = "Rag"
	build_path = /obj/item/weapon/reagent_containers/glass/rag
	materials = list(MAT_BIOMASS =  200)
	category = list("Leather and Cloth")

/datum/design/biogenerator/botany_gloves
	name = "Botanical Gloves"
	build_path = /obj/item/clothing/gloves/botanic_leather
	materials = list(MAT_BIOMASS =  250)
	category = list("Leather and Cloth")

/datum/design/biogenerator/toolbelt
	name = "Toolbelt"
	build_path = /obj/item/weapon/storage/belt/utility
	materials = list(MAT_BIOMASS =  300)
	category = list("Leather and Cloth")

/datum/design/biogenerator/securitybelt
	name = "Security Belt"
	build_path = /obj/item/weapon/storage/belt/security
	materials = list(MAT_BIOMASS =  300)
	category = list("Leather and Cloth")

/datum/design/biogenerator/medicalbelt
	name = "Medical Belt"
	build_path = /obj/item/weapon/storage/belt/medical
	materials = list(MAT_BIOMASS =  300)
	category = list("Leather and Cloth")

/datum/design/biogenerator/janitorbelt
	name = "Janitorial Belt"
	build_path = /obj/item/weapon/storage/belt/janitor
	materials = list(MAT_BIOMASS =  300)
	category = list("Leather and Cloth")

/datum/design/biogenerator/bandolier
	name = "Bandolier"
	build_path = /obj/item/weapon/storage/belt/bandolier
	materials = list(MAT_BIOMASS =  300)
	category = list("Leather and Cloth")

/datum/design/biogenerator/holster
	name = "Shoulder Holster"
	build_path = /obj/item/weapon/storage/belt/holster
	materials = list(MAT_BIOMASS =  400)
	category = list("Leather and Cloth")

/datum/design/biogenerator/satchel
	name = "Leather Sachel"
	build_path = /obj/item/weapon/storage/backpack/satchel
	materials = list(MAT_BIOMASS =  400)
	category = list("Leather and Cloth")

/datum/design/biogenerator/leather_jacket
	name = "Leather Jacket"
	build_path = /obj/item/clothing/suit/jacket/leather
	materials = list(MAT_BIOMASS =  500)
	category = list("Leather and Cloth")

/datum/design/biogenerator/leather_overcoat
	name = "Leather Overcoat"
	build_path = /obj/item/clothing/suit/jacket/leather/overcoat
	materials = list(MAT_BIOMASS =  1000)
	category = list("Leather and Cloth")

/datum/design/biogenerator/rice_hat
	name = "Rice Hat"
	build_path = /obj/item/clothing/head/rice_hat
	materials = list(MAT_BIOMASS =  300)
	category = list("Leather and Cloth")
