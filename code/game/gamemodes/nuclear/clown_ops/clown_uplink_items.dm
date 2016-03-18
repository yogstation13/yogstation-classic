//Keeping them here for now for ease of removal, since this is a joke, after all.

/datum/uplink_item/clown
	category = "Clown Specialty Weapons and Gear"
	gamemodes = list(/datum/game_mode/clown_ops)

/datum/uplink_item/clown/gun/foamsmg
	name = "Toy Submachine Gun"
	desc = "A fully-loaded Donksoft bullpup submachine gun that fires riot grade rounds with a 20-round magazine. This one comes with a HONKtastic firing pin, allowing clowns (and only clowns) to use it without harming themselves."
	item = /obj/item/weapon/gun/projectile/automatic/c20r/toy
	cost = 8
	surplus = 0

/datum/uplink_item/clown/gun/foammachinegun
	name = "Toy Machine Gun"
	desc = "A fully-loaded Donksoft belt-fed machine gun. This weapon has a massive 50-round magazine of devastating riot grade darts, that can briefly incapacitate someone in just one volley. This one comes with a HONKtastic firing pin, allowing clowns (and only clowns) to use it without harming themselves."
	item = /obj/item/weapon/gun/projectile/automatic/l6_saw/toy
	cost = 12
	surplus = 0


/datum/uplink_item/clown/gun/spawn_item(turf/loc, obj/item/device/uplink/U)
	var/obj/item/weapon/gun/G = ..()
	var/obj/item/device/firing_pin/old_pin = G.pin
	G.pin.gun_remove(null)
	qdel(old_pin)
	var/obj/item/device/firing_pin/clown/ultra/pin = new /obj/item/device/firing_pin/clown/ultra()
	pin.gun_insert(null, G)
	return G

/datum/uplink_item/clown/sword
	name = "Bananium Energy Sword"
	desc = "This energy sword is focused by a cyrstal of bananium, rendering it harmless. It can be used to slip opponents, and deflects energy projectiles just like a normal energy sword. Not effective against anyone wearing no-slip shoes."
	item = /obj/item/weapon/melee/energy/sword/bananium
	cost = 8

/datum/uplink_item/clown/bombanana
	name = "Bombanana"
	desc = "This device looks and acts exactly like a banana, except that five seconds after eating it, the peel explodes with the force of a minibomb. It still slips people."
	item = /obj/item/weapon/reagent_containers/food/snacks/grown/banana/bombanana
	cost = 4

/datum/uplink_item/clown/tearstache
	name = "Tear-stache Grenade"
	desc = "This teargas grendate has been modified to fire moustaches in a small radius. This will remove any non-clown masks on victims in the area, leaving them vulnerable to the teargas. The moustaches are treated with superglue to make them almost impossible to remove. Comes with a clum-z grip(tm) trigger so that clowns can use it, though non-clowns may find it fiddly."
	item = /obj/item/weapon/grenade/chem_grenade/teargas/moustache
	cost = 4

/datum/uplink_item/clown/honkmech
	name = "Dark H.O.N.K."
	desc = "A H.O.N.K. mech painted black and equiped with a HoNkER BlAsT 5000, Banana mortar, and tear-stache grenade launcher."
	item = /obj/mecha/combat/honker/dark/loaded
	cost = 20
	surplus = 0