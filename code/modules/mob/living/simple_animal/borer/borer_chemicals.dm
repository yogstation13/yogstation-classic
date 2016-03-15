/datum/borer_chem
	var/chemname
	var/needed_influence = 0
	var/influence_change = 5
	var/chemuse = 35
	var/quantity = 10

/datum/borer_chem/mannitol
	chemname = "mannitol"

/datum/borer_chem/bicaridine
	chemname = "bicaridine"

/datum/borer_chem/kelotane
	chemname = "kelotane"

/datum/borer_chem/charcoal
	chemname = "charcoal"

/datum/borer_chem/ephedrine
	chemname = "ephedrine"

/datum/borer_chem/leporazine
	chemname = "leporazine"
	chemuse = 100

/datum/borer_chem/perfluorodecalin
	chemname = "perfluorodecalin"
	needed_influence = 40
	influence_change = -5
	chemuse = 75

/datum/borer_chem/spacedrugs
	chemname = "space_drugs"
	needed_influence = 50
	influence_change = -5
	chemuse = 75

/datum/borer_chem/mutadone
	chemname = "mutadone"
	chemuse = 100

/datum/borer_chem/creagent
	chemname = "colorful_reagent"
	needed_influence = 100
	chemuse = 25

/datum/borer_chem/ethanol
	chemname = "ethanol"
	chemuse = 50