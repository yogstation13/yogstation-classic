/mob/living/simple_animal/hostile/retaliate/dolphin/tactical
	//don't put the name or desc here, leave that in add_harness and remove_harness
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	speed = 0
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/dolphinmeat = 2, /obj/item/weapon/reagent_containers/food/snacks/syndicake = 1)

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/New()
	..()
	AIStatus = AI_OFF
	var/obj/item/weapon/storage/tactical_harness/tmp_harness = new /obj/item/weapon/storage/tactical_harness/dolphin()
	tmp_harness.add_harness(src, null)

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/UnarmedAttack(obj/item/W, mob/user, params)
	if(!stat && istype(W, /obj/item/weapon/reagent_containers/food/snacks/syndicake) && Adjacent(W) && istype(W.loc, /turf))
		eat_syndiecake(W)
	else
		return ..()

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/syndicake) && !stat)
		eat_syndiecake(W, user)
	else
		return ..()

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/put_in_hands(obj/item/W)//need this so syndicake wrappers stay on the ground. Otherwise, the dolphin tries to put them in its hand, which is unreachable outside of varedit.
	W.loc = loc
	W.layer = initial(W.layer)
	W.dropped(src)
	return 0

/mob/living/simple_animal/hostile/retaliate/dolphin/tactical/proc/eat_syndiecake(var/obj/item/weapon/reagent_containers/food/snacks/syndicake/cake, var/mob/user = usr)
	if(health >= maxHealth)
		if(user == src)
			user << "<span class='warning'>You do not need to eat \the [cake] right now.</span>"
		else
			user << "<span class='warning'>\The [src] refuses to eat \the [cake]!</span>"
	else
		if(user == src)
			user.visible_message("<span class='warning'>You eat \the [cake].</span>", "<span class='warning'>You eat \the [cake].</span>")
		else
			user.visible_message("<span class='warning'>[usr] feeds \the [cake] to the [src].</span>", "<span class='warning'>You feed \the [cake] to \the [src]!</span>")
		//eat dat cake
		playsound(loc, 'sound/items/eatfood.ogg', rand(10,50), 1)
		if(cake.reagents.total_volume)//sadly copypasta.
			var/fraction = min(cake.bitesize/cake.reagents.total_volume, 1)
			cake.reagents.reaction(src, INGEST, fraction)
			cake.reagents.trans_to(src, cake.bitesize)
			cake.bitecount++
			cake.On_Consume()

		adjustBruteLoss(-5)
		updatehealth()
