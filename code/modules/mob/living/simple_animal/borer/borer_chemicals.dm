/datum/borer_chem
	var/chemname
	var/needed_influence = 0
	var/influence_change = 5
	var/chemuse = 50
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