/datum/disease/lingvirus
	name = "Unknown Xenobiological Pathogen"
	max_stages = 4
	spread_flags = AIRBORNE | CONTACT_GENERAL
	cure_text = "Sedation required."
	cures = list("morphine")
	agent = "Possibilities: C-type hivemind xenobiological vector, consumption of restricted xeno-related foodstuffs, latent infection via carrier."
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	desc = "Level 7 viral pathogen of xenobiological origin. Known symptoms involve: intense hallucinations, foaming at the mouth. Appears to be limited in scope and potency. Physically nonlethal, but mental damage may linger."
	severity = MEDIUM

/datum/disease/lingvirus/stage_act()
	..()
	if (affected_mob.mind.changeling)
		cure()
		return
	switch (stage)
		if (1)
			if (prob(2))
				affected_mob.hallucination = min(1500, affected_mob.hallucination+200)
			if (prob(3))
				affected_mob << "<span class='info'>The world sways and warbles about you, as if caught in a desert heat.</span>"
				affected_mob.emote("twitch")
			if (prob(2))
				affected_mob.visible_message("<span class='warning'>[affected_mob] suddenly begins to sweat.</span>")
		if (2)
			if (prob(5))
				affected_mob.hallucination = min(1500, affected_mob.hallucination+500)
			if (prob(2))
				affected_mob << "<span class='warning'>You feel gravely ill. Something is terribly wrong.</span>"
				affected_mob.emote("moan")
		if (3)
			if (prob(7))
				affected_mob.hallucination = min(1500, affected_mob.hallucination+700)
			if (prob(3) && affected_mob.hallucination >= 900)
				affected_mob << "<span class='boldwarning'>The stress begins to wear away at your sanity. Your mouth falls open, hung wide in a silent scream.</span>"
				affected_mob.emote("scream")
				affected_mob.visible_message("<span class='boldwarning'>[affected_mob] shrieks manically and begins to tear at their hair.</span>")
		if (4)
			if (prob(1))
				affected_mob.hallucination = min(300, affected_mob.hallucination+100)
			if (prob(3) && affected_mob.hallucination <= 300)
				affected_mob << "<span class='info'>A wave of sudden, palpable relief washes over you as the feeling of intense discomfort fades, and the fog over your mind is lifted.</span>"
				cure()
				return