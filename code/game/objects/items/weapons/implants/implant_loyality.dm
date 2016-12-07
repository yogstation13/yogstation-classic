/obj/item/weapon/implant/loyalty
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0

/obj/item/weapon/implant/loyalty/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen Employee Management Implant<BR>
				<b>Life:</b> Ten years.<BR>
				<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
				<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
				<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return dat


/obj/item/weapon/implant/loyalty/implant(mob/target)
	if(..())

		var/obj/item/weapon/implant/mindslave/imp = locate(/obj/item/weapon/implant/mindslave) in target
		if(imp)
			imp.removed(target)

		if(locate(/obj/item/weapon/implant/freedom) in target)
			target << "<span class='warning'>You feel the syndicate nanobots in your bloodstream quietly deactivate the implant.  You appear to be implanted, but the implant has no effect.</span>"
			return 1

		if((target.mind in (ticker.mode.head_revolutionaries | ticker.mode.get_gang_bosses())) || is_shadow_or_thrall(target) || (target.mind.special_role))
			target.visible_message("<span class='warning'>[target] seems to resist the implant!</span>", "<span class='warning'>You feel the corporate tendrils of Nanotrasen try to invade your mind!</span>")
			removed(target, 1)
			qdel(src)
			return -1
		if(target.mind in ticker.mode.get_gangsters())
			ticker.mode.remove_gangster(target.mind)
		if(target.mind in ticker.mode.revolutionaries)
			ticker.mode.remove_revolutionary(target.mind)
		if(target.mind in ticker.mode.cult)
			target << "<span class='warning'>You feel the corporate tendrils of Nanotrasen try to invade your mind!</span>"
		if(ticker.mode.is_cyberman(target.mind))
			target << "<span class='notice'>Your cyberman body silenty disables the Nanotrasen nanobots as they enter your bloodstream. You appear to be implanted, but the implant has no effect.</span>"
		else
			target << "<span class='notice'>You feel a surge of loyalty towards Nanotrasen.</span>"
		return 1
	return 0

/obj/item/weapon/implant/loyalty/removed(mob/target, var/silent = 0)
	if(..())
		if(target.stat != DEAD && !silent)
			target << "<span class='boldnotice'>You feel a sense of liberation as Nanotrasen's grip on your mind fades away.</span>"
		return 1
	return 0


/obj/item/weapon/implanter/loyalty
	name = "implanter (loyalty)"

/obj/item/weapon/implanter/loyalty/New()
	imp = new /obj/item/weapon/implant/loyalty(src)
	..()
	update_icon()


/obj/item/weapon/implantcase/loyalty
	name = "implant case - 'Loyalty'"
	desc = "A glass case containing a loyalty implant."

/obj/item/weapon/implantcase/loyalty/New()
	imp = new /obj/item/weapon/implant/loyalty(src)
	..()