/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/

/obj/effect/proc_holder/resource_ability/alien
	name = "Alien Power"
	panel = "Alien"
	resource_type = RESOURCE_ALIEN

	action_icon = 'icons/mob/actions.dmi'
	action_icon_state = "spell_default"
	action_background_icon_state = "bg_alien"

/obj/effect/proc_holder/resource_ability/alien/Click()
	if(!istype(usr,/mob/living/carbon))
		return 1
	var/mob/living/carbon/user = usr
	if(cost_check(user))
		if(fire(user) && user) // Second check to prevent runtimes when evolving
			user.adjustResource(RESOURCE_ALIEN, -resource_cost)
	return 1

/obj/effect/proc_holder/resource_ability/alien/plant/cost_check(mob/living/carbon/user,silent = 0)
	if(!isturf(user.loc) || istype(user.loc, /turf/space))
		if(!silent)
			user << "<span class='noticealien'>Bad place for a garden!</span>"
		return 0
	return..()

/obj/effect/proc_holder/resource_ability/alien/plant/weeds
	name = "Plant Weeds"
	desc = "Plants some alien weeds"
	resource_cost = 50
	action_icon_state = "alien_plant"

/obj/effect/proc_holder/resource_ability/alien/plant/fire(mob/living/carbon/user)
	if(locate(/obj/structure/alien/weeds/node) in get_turf(user))
		src << "There's already a weed node here."
		return 0
	for(var/mob/O in viewers(user, null))
		O.show_message(text("<span class='alertalien'>[user] has planted some alien weeds!</span>"), 1)
	new/obj/structure/alien/weeds/node(user.loc)
	return 1

/obj/effect/proc_holder/resource_ability/alien/whisper
	name = "Whisper"
	desc = "Whisper to someone"
	resource_cost = 10
	action_icon_state = "alien_whisper"

/obj/effect/proc_holder/resource_ability/alien/whisper/fire(mob/living/carbon/user)
	var/mob/living/M = input("Select who to whisper to:","Whisper to?",null) as mob in oview(user)
	if(!M)
		return 0
	var/msg = sanitize(input("Message:", "Alien Whisper") as text|null)
	if(msg)
		log_say("AlienWhisper: [key_name(user)]->[M.key] : [msg]")
		M << "<span class='noticealien'>You hear a strange, alien voice in your head...</span>[msg]"
		user << {"<span class='noticealien'>You said: "[msg]" to [M]</span>"}
	else
		return 0
	return 1

/obj/effect/proc_holder/resource_ability/alien/transfer
	name = "Transfer Plasma"
	desc = "Transfer Plasma to another alien"
	resource_cost = 0
	action_icon_state = "alien_transfer"

/obj/effect/proc_holder/resource_ability/alien/transfer/fire(mob/living/carbon/user)
	var/list/mob/living/carbon/aliens_around = list()
	for(var/mob/living/carbon/A  in oview(user))
		if(A.getorgan(/obj/item/organ/internal/ability_organ/alien/plasmavessel))
			aliens_around.Add(A)
	var/mob/living/carbon/M = input("Select who to transfer to:","Transfer plasma to?",null) as mob in aliens_around
	if(!M)
		return 0
	var/amount = input("Amount:", "Transfer Plasma to [M]") as num
	if (amount)
		amount = min(abs(round(amount)), user.getResource(RESOURCE_ALIEN))
		if (get_dist(user,M) <= 1)
			M.adjustResource(RESOURCE_ALIEN, amount)
			user.adjustResource(RESOURCE_ALIEN, -amount)
			M << "<span class='noticealien'>[user] has transfered [amount] plasma to you.</span>"
			user << {"<span class='noticealien'>You trasfer [amount] plasma to [M]</span>"}
		else
			user << "<span class='noticealien'>You need to be closer!</span>"
	return

/obj/effect/proc_holder/resource_ability/alien/acid
	name = "Corrossive Acid"
	desc = "Drench an object in acid, destroying it over time."
	resource_cost = 200
	action_icon_state = "alien_acid"

/obj/effect/proc_holder/resource_ability/alien/acid/on_gain(mob/living/carbon/user)
	user.verbs.Add(/mob/living/carbon/proc/corrosive_acid)

/obj/effect/proc_holder/resource_ability/alien/acid/on_lose(mob/living/carbon/user)
	user.verbs.Remove(/mob/living/carbon/proc/corrosive_acid)

/obj/effect/proc_holder/resource_ability/alien/acid/proc/corrode(target,mob/living/carbon/user = usr)
	if(target in oview(1,user))
		// OBJ CHECK
		if(isobj(target))
			var/obj/I = target
			if(I.unacidable)	//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
				user << "<span class='noticealien'>You cannot dissolve this object.</span>"
				return 0
		// TURF CHECK
		else if(istype(target, /turf/simulated))
			var/turf/T = target
			// R WALL
			if(istype(T, /turf/simulated/wall/r_wall))
				user << "<span class='noticealien'>You cannot dissolve this object.</span>"
				return 0
			// R FLOOR
			if(istype(T, /turf/simulated/floor/engine))
				user << "<span class='noticealien'>You cannot dissolve this object.</span>"
				return 0
		else// Not a type we can acid.
			return 0
		new /obj/effect/acid(get_turf(target), target)
		user.visible_message("<span class='alertalien'>[user] vomits globs of vile stuff all over [target]. It begins to sizzle and melt under the bubbling mess of acid!</span>")
		return 1
	else
		src << "<span class='noticealien'>Target is too far away.</span>"
		return 0


/obj/effect/proc_holder/resource_ability/alien/acid/fire(mob/living/carbon/alien/user)
	var/O = input("Select what to dissolve:","Dissolve",null) as obj|turf in oview(1,user)
	if(!O) return 0
	return corrode(O,user)

/mob/living/carbon/proc/corrosive_acid(O as obj|turf in oview(1)) // right click menu verb ugh
	set name = "Corrossive Acid"

	if(!iscarbon(usr))
		return
	var/mob/living/carbon/user = usr
	var/obj/effect/proc_holder/resource_ability/alien/acid/A = locate() in user.abilities
	if(!A) return
	if(user.getResource(RESOURCE_ALIEN) > A.resource_cost && A.corrode(O))
		user.adjustResource(RESOURCE_ALIEN, -A.resource_cost)


/obj/effect/proc_holder/resource_ability/alien/neurotoxin
	name = "Spit Neurotoxin"
	desc = "Spits neurotoxin at someone, paralyzing them for a short time."
	resource_cost = 50
	action_icon_state = "alien_neurotoxin"

/obj/effect/proc_holder/resource_ability/alien/neurotoxin/fire(mob/living/carbon/alien/user)
	user.visible_message("<span class='danger'>[user] spits neurotoxin!", "<span class='alertalien'>You spit neurotoxin.</span>")

	var/turf/T = user.loc
	var/turf/U = get_step(user, user.dir) // Get the tile infront of the move, based on their direction
	if(!isturf(U) || !isturf(T))
		return 0

	var/obj/item/projectile/bullet/neurotoxin/A = new /obj/item/projectile/bullet/neurotoxin(user.loc)
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	A.fire()

	return 1


/obj/effect/proc_holder/resource_ability/alien/plant/resin
	name = "Secrete Resin"
	desc = "Secrete tough malleable resin."
	resource_cost = 55
	var/list/structures = list(
		"resin wall" = /obj/structure/alien/resin/wall,
		"resin membrane" = /obj/structure/alien/resin/membrane,
		"resin nest" = /obj/structure/stool/bed/nest)

	action_icon_state = "alien_resin"

/obj/effect/proc_holder/resource_ability/alien/plant/resin/fire(mob/living/carbon/user)
	if(locate(/obj/structure/alien/resin) in user.loc)
		user << "<span class='danger'>There is already a resin structure there.</span>"
		return 0
	var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in structures
	if(!choice) return 0

	user << "<span class='notice'>You shape a [choice].</span>"
	user.visible_message("<span class='notice'>[user] vomits up a thick purple substance and begins to shape it.</span>")

	choice = structures[choice]
	new choice(user.loc)
	return 1

/obj/effect/proc_holder/resource_ability/alien/regurgitate
	name = "Regurgitate"
	desc = "Empties the contents of your stomach"
	resource_cost = 0
	action_icon_state = "alien_barf"

/obj/effect/proc_holder/resource_ability/alien/regurgitate/fire(mob/living/carbon/user)
	if(user.stomach_contents.len)
		for(var/atom/movable/A in user.stomach_contents)
			user.stomach_contents.Remove(A)
			A.loc = user.loc
			A.update_pipe_vision()
		user.visible_message("<span class='alertealien'>[user] hurls out the contents of their stomach!</span>")
	return

/obj/effect/proc_holder/resource_ability/alien/nightvisiontoggle
	name = "Toggle Night Vision"
	desc = "Toggles Night Vision"
	resource_cost = 0
	has_action = 0 // Has dedicated GUI button already

/obj/effect/proc_holder/resource_ability/alien/nightvisiontoggle/fire(mob/living/carbon/alien/user)
	if(!user.nightvision)
		user.see_in_dark = 8
		user.see_invisible = SEE_INVISIBLE_MINIMUM
		user.nightvision = 1
		user.hud_used.nightvisionicon.icon_state = "nightvision1"
	else if(user.nightvision == 1)
		user.see_in_dark = 4
		user.see_invisible = 45
		user.nightvision = 0
		user.hud_used.nightvisionicon.icon_state = "nightvision0"

	return 1

/mob/living/carbon/alien/adjustResource(resource_type, amount)
	. = ..()
	updatePlasmaDisplay()


/proc/cmp_abilities_cost(obj/effect/proc_holder/resource_ability/alien/a, obj/effect/proc_holder/resource_ability/alien/b)
	return b.resource_cost - a.resource_cost