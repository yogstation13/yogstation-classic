/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1.0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	if (t)
		src.name = "data disk- '[t]'"
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */
/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"
	flags = NOBLUDGEON

/obj/item/weapon/card/emag/attack()
	return

/obj/item/weapon/card/emag/afterattack(atom/target, mob/user, proximity)
	var/atom/A = target
	if(!proximity) return
	A.emag_act(user)

/obj/item/weapon/card/emag/centcom
	desc = "It's a special card that uses a backdoor built into every Nanotrasen machine and device to override access restrictions and activate special functions.<br><font color='red'>USE OF THIS DEVICE IS RESTRICTED TO NANOTRASEN EMERGENCY RESPONSE TEAMS.</font>"
	name = "access override card"
	icon_state = "data"
	item_state = "card-id"
	flags = NOBLUDGEON

/obj/item/weapon/card/emag/centcom/afterattack(atom/target, mob/user, proximity)
	var/atom/A = target
	if(!proximity) return
	if(istype(A, /obj/machinery/door/airlock/centcom)) return
	if(istype(A, /obj/machinery) || istype(A, /obj/item))
		A.emag_act(user)

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	var/mining_points = 0 //For redeeming at mining equipment vendors
	var/list/access = list()
	var/registered_name = null // The name registered_name on the card
	slot_flags = SLOT_ID

	var/assignment = null
	var/dorm = 0		// determines if this ID has claimed a dorm already

/obj/item/weapon/card/id/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user] shows you: \icon[src] [src.name].</span>", \
					"<span class='notice'>You show \the [src.name].</span>")
	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/examine(mob/user)
	..()
	if(mining_points)
		user << "There's [mining_points] mining equipment redemption point\s loaded onto this card."

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/*
Usage:
update_label()
	Sets the id name to whatever registered_name and assignment is

update_label("John Doe", "Clowny")
	Properly formats the name and occupation and sets the id name to the arguments
*/
/obj/item/weapon/card/id/proc/update_label(newname, newjob)
	if(newname || newjob)
		name = "[(!newname)	? "identification card"	: "[newname]'s ID Card"][(!newjob) ? "" : " ([newjob])"]"
		return

	name = "[(!registered_name)	? "identification card"	: "[registered_name]'s ID Card"][(!assignment) ? "" : " ([assignment])"]"

/obj/item/weapon/card/id/silver
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/gold
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	access = list(access_maint_tunnels, access_syndicate)
	origin_tech = "syndicate=3"
	var/list/card_choices = list()

/obj/item/weapon/card/id/syndicate/New()
	card_choices = list(new /obj/item/weapon/card/id(), new /obj/item/weapon/card/id/silver(), new /obj/item/weapon/card/id/gold(), new /obj/item/weapon/card/id/prisoner(), new /obj/item/weapon/card/emag() )

/obj/item/weapon/card/id/syndicate/afterattack(obj/item/weapon/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		var/has_card = 0
		for(var/choice in card_choices)
			var/obj/item/weapon/card/C = choice
			if(I.type == C.type)
				has_card = 1
				break
		if(!has_card)
			card_choices += new I.type()
		if(istype(user, /mob/living) && user.mind)
			if(user.mind.special_role)
				usr << "<span class='notice'>The card's microscanners activate as you pass it over the ID, copying its access.</span>"
				if(!has_card)
					usr << "<span class='notice'>The card has stored the appearance information of the ID.</span>"

/obj/item/weapon/card/id/syndicate/attack_self(mob/user)
	if(istype(user, /mob/living) && user.mind)
		if(user.mind.special_role)
			if(alert(user, "Action", "Agent ID", "Show", "Forge") == "Forge")
				if(loc != usr || user.stat)
					return
				var/list/name_list = list()
				for(var/choice in card_choices)
					var/obj/item/weapon/card/C = choice
					name_list[C.icon_state] = C
				var/obj/item/weapon/card/A
				A = input("Select an Appearance for your card", "BOOYEA", A) in name_list
				if(!A || loc != usr || user.stat)
					return
				var/obj/item/weapon/card/C = name_list[A]
				if(C)
					name = C.name
					desc = C.desc
					icon_state = C.icon_state
					item_state = C.item_state
					item_color = C.item_color
					if(istype(C, /obj/item/weapon/card/emag))
						user << "<span class='notice'>You disguise the ID card as a cryptographic sequencer.</span>"
						return

				var t = copytext(sanitize(input(user, "What name would you like to put on this card?", "Agent card name", registered_name ? registered_name : (ishuman(user) ? user.real_name : user.name))as text | null),1,26)
				if(loc != usr || user.stat)
					return
				if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
					if (t)
						alert("Invalid name.")
					return
				registered_name = t

				var u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Assistant")as text | null),1,MAX_MESSAGE_LEN)
				if(loc != usr || user.stat)
					return
				if(!u)
					registered_name = ""
					return
				assignment = u
				update_label()

				user << "<span class='notice'>You successfully forge the ID card.</span>"
				return
	..()

/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate)

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	high_risk = 1
	New()
		var/datum/job/captain/J = new/datum/job/captain
		access = J.get_access()
		..()

/obj/item/weapon/card/id/centcom
	name = "\improper Centcom ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
	New()
		access = get_all_centcom_access()
		..()

/obj/item/weapon/card/id/ert
	name = "\improper Centcom ID"
	desc = "A ERT ID card"
	icon_state = "centcom"
	registered_name = "Emergency Response Team Commander"
	assignment = "Emergency Response Team Commander"
	New() access = get_all_accesses()+get_ert_access("commander")-access_change_ids

/obj/item/weapon/card/id/ert/Security
	registered_name = "Security Response Officer"
	assignment = "Security Response Officer"
	New() access = get_all_accesses()+get_ert_access("sec")-access_change_ids

/obj/item/weapon/card/id/ert/Engineer
	registered_name = "Engineer Response Officer"
	assignment = "Engineer Response Officer"
	New() access = get_all_accesses()+get_ert_access("eng")-access_change_ids

/obj/item/weapon/card/id/ert/Medical
	registered_name = "Medical Response Officer"
	assignment = "Medical Response Officer"
	New() access = get_all_accesses()+get_ert_access("med")-access_change_ids

/obj/item/weapon/card/id/prisoner
	name = "prisoner ID card"
	desc = "You are a number, you are not a free man."
	icon_state = "orange"
	item_state = "orange-id"
	assignment = "Prisoner"
	registered_name = "Scum"
	var/goal = 0 //How far from freedom?
	var/points = 0

/obj/item/weapon/card/id/prisoner/attack_self(mob/user)
	usr << "<span class='notice'>You have accumulated [points] out of the [goal] points you need for freedom.</span>"

/obj/item/weapon/card/id/prisoner/one
	name = "Prisoner #13-001"
	registered_name = "Prisoner #13-001"

/obj/item/weapon/card/id/prisoner/two
	name = "Prisoner #13-002"
	registered_name = "Prisoner #13-002"

/obj/item/weapon/card/id/prisoner/three
	name = "Prisoner #13-003"
	registered_name = "Prisoner #13-003"

/obj/item/weapon/card/id/prisoner/four
	name = "Prisoner #13-004"
	registered_name = "Prisoner #13-004"

/obj/item/weapon/card/id/prisoner/five
	name = "Prisoner #13-005"
	registered_name = "Prisoner #13-005"

/obj/item/weapon/card/id/prisoner/six
	name = "Prisoner #13-006"
	registered_name = "Prisoner #13-006"

/obj/item/weapon/card/id/prisoner/seven
	name = "Prisoner #13-007"
	registered_name = "Prisoner #13-007"

/obj/item/weapon/card/id/wormhole
	name = "Wormhole Access card"
	desc = "A wrmhole room access card."
	access = list(access_wormhole)
