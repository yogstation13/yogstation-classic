/obj/structure/cult
	density = 1
	anchored = 1
	icon = 'icons/obj/cult.dmi'

/obj/structure/cult/talisman
	name = "altar"
	desc = "A bloodstained altar dedicated to Nar-Sie"
	icon_state = "talismanaltar"


/obj/structure/cult/forge
	name = "daemon forge"
	desc = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie"
	icon_state = "forge"

/obj/structure/cult/pylon
	name = "pylon"
	desc = "A floating crystal that hums with an unearthly energy"
	icon_state = "pylon"
	luminosity = 5

/obj/structure/cult/tome
	name = "desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl"
	icon_state = "tomealtar"

/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back"
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = 1
	unacidable = 1
	anchored = 1.0

/obj/structure/barricade/cult
	name = "ethereal field"
	desc = "Strange energies float around this, although it looks easy enough to break."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"
	anchored = 1.0
	density = 1.0
	var/health = 1.0
	var/maxhealth = 1.0
	alpha = 100

/obj/structure/barricade/cult/attackby(obj/item/W, mob/user, params)
	src.health -= W.force
	if (src.health <= 0)
		visible_message("<span class='warning'>[src] vanishes in a puff of smoke.</span>")
		qdel(src)
