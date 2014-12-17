///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////

datum/design/safeguard_module
	name = "AI Module(Safeguard)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "safeguard_module"
	req_tech = list("programming" = 3, "materials" = 4)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$gold" = 100)
	build_path = /obj/item/weapon/aiModule/supplied/safeguard
	ui_category = "AI Module"
	
datum/design/onehuman_module
	name = "AI Module (OneHuman)"
	desc = "Allows for the construction of a OneHuman AI Module."
	id = "onehuman_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/zeroth/oneHuman
	ui_category = "AI Module"

datum/design/protectstation_module
	name = "AI Module (ProtectStation)"
	desc = "Allows for the construction of a ProtectStation AI Module."
	id = "protectstation_module"
	req_tech = list("programming" = 3, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$gold" = 100)
	build_path = /obj/item/weapon/aiModule/supplied/protectStation
	ui_category = "AI Module"

datum/design/quarantine_module
	name = "AI Module (Quarantine)"
	desc = "Allows for the construction of a Quarantine AI Module."
	id = "quarantine_module"
	req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$gold" = 100)
	build_path = /obj/item/weapon/aiModule/supplied/quarantine
	ui_category = "AI Module"

datum/design/oxygen_module
	name = "AI Module (OxygenIsToxicToHumans)"
	desc = "Allows for the construction of a Safeguard AI Module."
	id = "oxygen_module"
	req_tech = list("programming" = 3, "biotech" = 2, "materials" = 4)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$gold" = 100)
	build_path = /obj/item/weapon/aiModule/supplied/oxygen
	ui_category = "AI Module"

datum/design/freeform_module
	name = "AI Module (Freeform)"
	desc = "Allows for the construction of a Freeform AI Module."
	id = "freeform_module"
	req_tech = list("programming" = 4, "materials" = 4)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$gold" = 100)
	build_path = /obj/item/weapon/aiModule/supplied/freeform
	ui_category = "AI Module"

datum/design/reset_module
	name = "AI Module (Reset)"
	desc = "Allows for the construction of a Reset AI Module."
	id = "reset_module"
	req_tech = list("programming" = 3, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$gold" = 100)
	build_path = /obj/item/weapon/aiModule/reset
	ui_category = "AI Module"

datum/design/purge_module
	name = "AI Module (Purge)"
	desc = "Allows for the construction of a Purge AI Module."
	id = "purge_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/reset/purge
	ui_category = "AI Module"

datum/design/freeformcore_module
	name = "AI Core Module (Freeform)"
	desc = "Allows for the construction of a Freeform AI Core Module."
	id = "freeformcore_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/core/freeformcore
	ui_category = "AI Module"

datum/design/asimov
	name = "AI Core Module (Asimov)"
	desc = "Allows for the construction of a Asimov AI Core Module."
	id = "asimov_module"
	req_tech = list("programming" = 3, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/core/full/asimov
	ui_category = "AI Module"

datum/design/paladin_module
	name = "AI Core Module (P.A.L.A.D.I.N.)"
	desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
	id = "paladin_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/core/full/paladin
	ui_category = "AI Module"

datum/design/tyrant_module
	name = "AI Core Module (T.Y.R.A.N.T.)"
	desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
	id = "tyrant_module"
	req_tech = list("programming" = 4, "syndicate" = 2, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/core/full/tyrant
	ui_category = "AI Module"

datum/design/corporate_module
	name = "AI Core Module (Corporate)"
	desc = "Allows for the construction of a Corporate AI Core Module."
	id = "corporate_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/core/full/corp
	ui_category = "AI Module"

datum/design/custom_module
	name = "AI Core Module (Custom)"
	desc = "Allows for the construction of a Custom AI Core Module."
	id = "custom_module"
	req_tech = list("programming" = 4, "materials" = 6)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20, "$diamond" = 100)
	build_path = /obj/item/weapon/aiModule/core/full/custom
	ui_category = "AI Module"
