/datum/borer_chem
	var/chemname
	var/needed_influence = 0
	var/influence_change = 5
	var/chemuse = 50
	var/quantity = 10

/datum/borer_chem/mannitol
	chemname = "mannitol"

/datum/borer_chem/bicardine
	chemname = "bicardine"

/datum/borer_chem/kelotane
	chemname = "kelotane"

/datum/borer_chem/charcoal
	chemname = "charcoal"

/datum/borer_chem/potassiumiodide
	chemname = "potass_iodide"

/datum/borer_chem/leporazine
	chemname = "leporazine"
	chemuse = 100

/datum/borer_chem/leporazine
	chemname = "spaceacillin"
	chemuse = 250

/datum/borer_chem/morphine
	chemname = "morphine"
	needed_influence = 50
	influence_change = -10
	chemuse = 100

/datum/borer_chem/spacedrugs
	chemname = "space_drugs"
	needed_influence = 50
	chemuse = 75