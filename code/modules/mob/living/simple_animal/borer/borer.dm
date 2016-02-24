/mob/living/simple_animal/borer
	name = "Cortical Borer"
	desc = "Absolutely not de-beaked or harmless. Keep away from corpses."
	icon_state = "headcrab"
	icon_living = "headcrab"
	icon_dead = "headcrab_dead"
	health = 20
	maxHealth = 20
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = list("creature")
	speak_emote = list("squeaks")
	ventcrawler = 2

	var/mob/living/carbon/human/victim = null
	var/docile = 0
	var/controlling = 0
	var/chemicals = 50

/mob/living/simple_animal/borer/New()
	..()
	name = "[pick("Primary","Secondary","Tertiary","Quaternary")] Borer ([rand(100,999)])"


/mob/living/simple_animal/borer/Stat()
	..()

	if(statpanel("Status"))
		stat(null, "Chemicals: [chemicals]")

/mob/living/simple_animal/borer/Life()

	..()

	if(victim)

		if(stat != DEAD && victim.stat != DEAD)

			if(victim.reagents.has_reagent("sugar"))
				if(!docile)
					if(controlling)
						host << "<span class='boldnotice'>You feel the soporific flow of sugar in your host's blood, lulling you into docility.</span>"
					else
						src << "<span class='boldnotice'>You feel the soporific flow of sugar in your host's blood, lulling you into docility.</span>"
					docile = 1
			else
				if(docile)
					if(controlling)
						host << "<span class='boldnotice'>You shake off your lethargy as the sugar leaves your host's blood.</span>"
					else
						src << "<span class='boldnotice'>You shake off your lethargy as the sugar leaves your host's blood.</span>"
					docile = 0

			if(chemicals < 250)
				chemicals++
			if(controlling)

				if(docile)
					host << "<span class='boldnotice'>You are feeling far too docile to continue controlling your host...</span>"
					//host.release_control() //Sort this out.
					return

				if(prob(5))
					victim.adjustBrainLoss(rand(1,2))

				if(prob(victim.brainloss/20))
					victim.say("*[pick(list("blink","blink_r","choke","aflap","drool","twitch","twitch_s","gasp"))]")


/mob/living/simple_animal/borer/proc/Infect(mob/living/carbon/human/victim)

	if(!victim)
		return

	if(victim.borer)
		src << "<span class='usernotice'>[victim] is already infected!</span>"
		return

	src.victim = victim
	victim.borer = src
	src.loc = victim

	victim.Stun(4)
	victim.Weaken(4)
	victim.apply_effect(STUTTER, 4)
	visible_message("<span class='warning'>[victim] collapses into a fit of spasms!.</span>")