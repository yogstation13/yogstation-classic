
var/datum/borer_tech_tree/borer_tech_tree = new /datum/borer_tech_tree()

/datum/borer_tech_tree
	var/list/datum/borer_tech/techs = list()

/datum/borer_tech_tree/New()
	techs += new /datum/borer_tech/initial()
	techs += new /datum/borer_tech/intermediate_synthesizing()

/datum/borer_tech
	var/tech_name = "A generic tech name"
	var/list/required_research = list()
	var/chemicals_required_for_research = 0
	var/current_chemicals = 0
	var/desc = "A generic description."

/datum/borer_tech/proc/evolveBorers()
	for(var/mob/living/simple_animal/borer/B in borers)
		evolveBorer(B)

/datum/borer_tech/proc/evolveBorer(var/mob/living/simple_animal/borer/B)
	B << "<span class='boldnotice'>You evolved [tech_name]</span>"
	return

/datum/borer_tech/initial
	tech_name = "Basic Chemical Synthesizing"
	chemicals_required_for_research = 100
	desc = "Unlocks the basic chemicals, Bicaridine And Kelotane."

/datum/borer_tech/initial/evolveBorer(var/mob/living/simple_animal/borer/B)
	B.borer_chems += new /datum/borer_chem/bicaridine()
	B.borer_chems += new /datum/borer_chem/kelotane()
	..()

/datum/borer_tech/intermediate_synthesizing
	tech_name = "Intermediate Chemical Synthesizing"
	chemicals_required_for_research = 175
	desc = "Unlocks a wider range of healing chems such as Charcoal And Mannitol."

/datum/borer_tech/intermediate_synthesizing/New()
	required_research += new /datum/borer_tech/initial

/datum/borer_tech/intermediate_synthesizing/evolveBorer(var/mob/living/simple_animal/borer/B)
	B.borer_chems += new /datum/borer_chem/charcoal()
	B.borer_chems += new /datum/borer_chem/mannitol()
	..()
