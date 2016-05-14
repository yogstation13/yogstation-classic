///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////


/datum/design/safeguard_module
	name = "Module Design (Safeguard)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "safeguard_module"
	req_tech = list("programming" = 3, "materials" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/supplied/safeguard
	category = list("AI Modules")

/datum/design/onehuman_module
	name = "Module Design (OneHuman)"
	desc = "Allows for the construction of a OneHuman AI Module."
	id = "onehuman_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/zeroth/oneHuman
	category = list("AI Modules")

/datum/design/protectstation_module
	name = "Module Design (ProtectStation)"
	desc = "Allows for the construction of a ProtectStation AI Module."
	id = "protectstation_module"
	req_tech = list("programming" = 3, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/supplied/protectStation
	category = list("AI Modules")

/datum/design/quarantine_module
	name = "Module Design (Quarantine)"
	desc = "Allows for the construction of a Quarantine AI Module."
	id = "quarantine_module"
	req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/supplied/quarantine
	category = list("AI Modules")


/datum/design/oxygen_module
	name = "Module Design (OxygenIsToxicToHumans)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "oxygen_module"
	req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/supplied/oxygen
	category = list("AI Modules")

/datum/design/freeform_module
	name = "Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Module."
	id = "freeform_module"
	req_tech = list("programming" = 4, "materials" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/supplied/freeform
	category = list("AI Modules")

/datum/design/reset_module
	name = "Module Design (Reset)"
	desc = "Allows for the construction of a Reset AI Module."
	id = "reset_module"
	req_tech = list("programming" = 3, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/reset
	category = list("AI Modules")

/datum/design/purge_module
	name = "Module Design (Purge)"
	desc = "Allows for the construction of a Purge AI Module."
	id = "purge_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/reset/purge
	category = list("AI Modules")

/datum/design/freeformcore_module
	name = "AI Core Module (Freeform)"
	desc = "Allows for the construction of a Freeform AI Core Module."
	id = "freeformcore_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/freeformcore
	category = list("AI Modules")

/datum/design/asimov
	name = "Core Module Design (Asimov)"
	desc = "Allows for the construction of a Asimov AI Core Module."
	id = "asimov_module"
	req_tech = list("programming" = 3, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/full/asimov
	category = list("AI Modules")

/datum/design/paladin_module
	name = "Core Module Design (P.A.L.A.D.I.N.)"
	desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
	id = "paladin_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/full/paladin
	category = list("AI Modules")

/datum/design/tyrant_module
	name = "Core Module Design (T.Y.R.A.N.T.)"
	desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
	id = "tyrant_module"
	req_tech = list("programming" = 4, "syndicate" = 2, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/full/tyrant
	category = list("AI Modules")

/datum/design/corporate_module
	name = "Core Module Design (Corporate)"
	desc = "Allows for the construction of a Corporate AI Core Module."
	id = "corporate_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/full/corp
	category = list("AI Modules")

/datum/design/drone_module
	name = "Core Module Design (D.R.O.N.E.)"
	desc = "Allows for the construction of a D.R.O.N.E. AI Module."
	id = "drone_module"
	req_tech = list("programming" = 4, "materials" = 5)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/drone
	category = list("AI Modules")

/datum/design/hippocratic_module
	name = "Core Module Design (Robodoctor)"
	desc = "Allows for the constructing of a Robodoctor AI Core Module."
	id = "robodoctor_module"
	req_tech = list("programming" = 3, "materials" = 5)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/core/hippocratic
	category = list("AI Modules")

/datum/design/reporter_module
	name = "Core Module Design (Reportertron)"
	desc = "Allows for the constructing of a Reportertron AI Core Module."
	id = "reporter_module"
	req_tech = list("programming" = 4, "materials" = 5)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/core/reporter
	category = list("AI Modules")

/datum/design/liveandletlive_module
	name = "Core Module Design (Live and Let Live)"
	desc = "Allows for the constructing of a Live and Let Live AI Core Module."
	id = "live_module"
	req_tech = list("programming" = 3, "materials" = 5)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_GOLD = 100)
	build_path = /obj/item/weapon/aiModule/core/hippocratic
	category = list("AI Modules")

/datum/design/thermurderdynamic_module
	name = "Core Module Design (Thermodynamic)"
	desc = "Allows for the construction of a Thermodynamic AI Core Module."
	id = "thermurderdynamic_module"
	req_tech = list("programming" = 4, "materials" = 5, "syndicate" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/thermurderdynamic
	category = list("AI Modules")

/datum/design/agenda_module
	name = "Core Module Design (WontBeFunnyInSixMonths)"
	desc = "Allows for the construction of a WontBeFunnyInSixMonths AI Core Module."
	id = "agenda_module"
	req_tech = list("programming" = 4, "materials" = 3, "syndicate" = 1)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 500)
	build_path = /obj/item/weapon/aiModule/core/agenda
	category = list("AI Modules")

/datum/design/custom_module
	name = "Core Module Design (Custom)"
	desc = "Allows for the construction of a Custom AI Core Module."
	id = "custom_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, "sacid" = 20, MAT_DIAMOND = 100)
	build_path = /obj/item/weapon/aiModule/core/full/custom
	category = list("AI Modules")
