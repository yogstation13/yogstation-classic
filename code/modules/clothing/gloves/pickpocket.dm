#define SEE_POCKETS		1
#define SEE_BACKPACK	2
#define SEE_BELT		4

/obj/item/clothing/gloves/pickpocket
	desc = "Gloves for those sticky fingers of yours."
	name = "pickpocket gloves"
	var/strip_coeff = 0.33 //Stripping is 33% faster
	var/silent_strip = 1 //no messages while stripping
	var/silent_internals = 1 //silent internals toggling
	var/strip_visibility_flags = 0 //what can we see when we wear these
	var/put_in_hand = 1 //Put whatever we are stealing in-hand?

/obj/item/clothing/gloves/pickpocket/chameleon
	name = "chameleon pickpocket gloves"
	desc = "Latest in Syndicate technology. Can reform it's thread color to any color that's used by Nanotrasen."
	fiber_text = "shiny black gloves"
	icon_state = "black"
	item_state = "bgloves"
	item_color = "brown"
	strip_visibility_flags = SEE_POCKETS | SEE_BACKPACK | SEE_BELT

	cold_protection = HANDS
	heat_protection = HANDS

	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT

	burn_state = -1 //Won't burn in fires

	var/list/clothing_choices = list(/obj/item/clothing/gloves/color/yellow,
			/obj/item/clothing/gloves/color/black,
			/obj/item/clothing/gloves/color/orange,
			/obj/item/clothing/gloves/color/red,
			/obj/item/clothing/gloves/color/rainbow,
			/obj/item/clothing/gloves/color/blue,
			/obj/item/clothing/gloves/color/purple,
			/obj/item/clothing/gloves/color/green,
			/obj/item/clothing/gloves/color/grey,
			/obj/item/clothing/gloves/color/light_brown,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/gloves/color/latex,
			/obj/item/clothing/gloves/color/white
			)

/obj/item/clothing/gloves/pickpocket/chameleon/attack_self(mob/user)
	var/list/glove_nametypes = list()
	var/obj/item/clothing/gloves/color/picked

	for(var/CC in clothing_choices)
		var/obj/item/clothing/gloves/color/GN = CC
		var/glove_name = initial(GN.name)
		if(glove_name)
			glove_nametypes[glove_name] = GN

	var/picked_glove_name
	picked_glove_name = input(user, "Change gloves to", "Chameleon gloves") as null|anything in glove_nametypes

	if(!picked_glove_name)
		return

	picked = glove_nametypes[picked_glove_name]

	if(!picked || user.stat)
		return

	src.name = initial(picked.name)
	src.desc = initial(picked.desc)
	src.icon_state = initial(picked.icon_state)
	src.item_state = initial(picked.item_state)
	src.item_color = initial(picked.item_color)