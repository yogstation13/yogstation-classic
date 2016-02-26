/mob/living/simple_animal/borer
	name = "Cortical Borer"
	desc = "Absolutely not de-beaked or harmless. Keep away from corpses."
	icon_state = "brainslug"
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	health = 20
	maxHealth = 20
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	faction = list("creature")
	speak_emote = list("squeaks")
	ventcrawler = 2

	var/mob/living/carbon/human/victim = null
	var/docile = 0
	var/controlling = 0
	var/chemicals = 50
	var/used_dominate
	var/influence = 0

/mob/living/simple_animal/borer/New()
	..()
	name = "[pick("Primary","Secondary","Tertiary","Quaternary")] Borer ([rand(100,999)])"

/mob/living/simple_animal/borer/Stat()
	..()

	if(statpanel("Status"))
		stat(null, "Chemicals: [chemicals]")
		if(victim)
			stat(null, "Influence: [influence]%")

/mob/living/simple_animal/borer/Life()

	..()

	if(victim)

		if(stat != UNCONSCIOUS && victim.stat != UNCONSCIOUS)
			if(chemicals < 250)
				chemicals++
			if(influence < 100)
				influence += 0.5
				if(influence == 100)
					src << "<span class='boldnotice'>You are one with [victim] you both aid eachother in their needs and establish a mutally beneficial relationship.</span>"
					victim << "<span class='boldnotice'>You are one with [src] you both aid eachother in their needs and establish a mutally beneficial relationship.</span>"
				if(influence == 80)
					victim << "<span class='boldnotice'>You feel [src]'s power grow to extreme levels. You beging to feel unbeatable.</span>"
				if(influence == 50)
					victim << "<span class='boldnotice'>You feel [src]'s power grow.</span>"
				if(influence == 10)
					victim << "<span class='boldnotice'>You feel [src]'s power slowly starting to whisper to you.</span>"

		if(stat != DEAD && victim.stat != DEAD)

			if(victim.reagents.has_reagent("sugar"))
				if(!docile)
					if(controlling)
						host << "<span class='boldnotice'>You feel the soporific flow of sugar in your host's blood, lulling you into docility.</span>"
					else
						src << "<span class='boldnotice'>You feel the soporific flow of sugar in your host's blood, lulling you into docility.</span>"
					docile = 1
					influence -= 1
			else
				if(docile)
					if(controlling)
						host << "<span class='boldnotice'>You shake off your lethargy as the sugar leaves your host's blood.</span>"
					else
						src << "<span class='boldnotice'>You shake off your lethargy as the sugar leaves your host's blood.</span>"
					docile = 0
			if(controlling)

				if(docile)
					host << "<span class='boldnotice'>You are feeling far too docile to continue controlling your host...</span>"
					//host.release_control() //Sort this out.
					return

				if(prob(5))
					victim.adjustBrainLoss(rand(1,2))

				if(prob(victim.brainloss/20))
					victim.say("*[pick(list("blink","blink_r","choke","aflap","drool","twitch","twitch_s","gasp"))]")

/mob/living/simple_animal/borer/say(message)
	if(!victim)
		src << "<span class='boldnotice'>You cannot speak without a host.</span>"

	if(influence > 80)
		victim << "<span class='green'><b>[name] telepathicaly shouts... </b></span><span class='userdanger'>[message]</span"
		src << "<span class='green'><b>[name] telepathicaly shouts... </b></span><span class='userdanger'>[message]</span>"
	else if(influence > 40)
		victim << "<span class='green'><b>[name] telepathicaly says... </b></span>[message]"
		src << "<span class='green'><b>[name] telepathicaly says... </b></span>[message]"
	else
		victim << "<span class='green'><b>[name] telepathicaly whispers... </b></span><i>[message]</i>"
		src << "<span class='green'><b>[name] telepathicaly whispers... </b></span><i>[message]</i>"



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

/mob/living/simple_animal/borer/proc/leave_victim()

	if(!victim) return

	src.loc = get_turf(victim)

	victim.borer = null
	victim = null
	influence = 0