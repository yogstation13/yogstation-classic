// Various tools and handheld engineering devices.

/datum/export/toolbox
	cost = 4
	unit_name = "toolbox"
	export_types = list(/obj/item/weapon/storage/toolbox)

// mechanical toolbox:	22cr
// emergency toolbox:	17-20cr
// electrical toolbox:	36cr
// robust: priceless

// Basic tools
/datum/export/screwdriver
	cost = 2
	unit_name = "screwdriver"
	export_types = list(/obj/item/weapon/tool/screwdriver)
	include_subtypes = FALSE

/datum/export/wrench
	cost = 2
	unit_name = "wrench"
	export_types = list(/obj/item/weapon/tool/wrench)

/datum/export/crowbar
	cost = 2
	unit_name = "crowbar"
	export_types = list(/obj/item/weapon/tool/crowbar)

/datum/export/wirecutters
	cost = 2
	unit_name = "pair"
	message = "of wirecutters"
	export_types = list(/obj/item/weapon/tool/wirecutters)


// Welding tools
/datum/export/weldingtool
	cost = 5
	unit_name = "welding tool"
	export_types = list(/obj/item/weapon/tool/weldingtool)
	include_subtypes = FALSE

/datum/export/weldingtool/emergency
	cost = 2
	unit_name = "emergency welding tool"
	export_types = list(/obj/item/weapon/tool/weldingtool/mini)

/datum/export/weldingtool/industrial
	cost = 10
	unit_name = "industrial welding tool"
	export_types = list(/obj/item/weapon/tool/weldingtool/largetank, /obj/item/weapon/tool/weldingtool/hugetank)


// Fire extinguishers
/datum/export/extinguisher
	cost = 15
	unit_name = "fire extinguisher"
	export_types = list(/obj/item/weapon/extinguisher)
	include_subtypes = FALSE

/datum/export/extinguisher/mini
	cost = 2
	unit_name = "pocket fire extinguisher"
	export_types = list(/obj/item/weapon/extinguisher/mini)


// Flashlights
/datum/export/flashlight
	cost = 5
	unit_name = "flashlight"
	export_types = list(/obj/item/device/flashlight)
	include_subtypes = FALSE

/datum/export/flashlight/flare
	cost = 2
	unit_name = "flare"
	export_types = list(/obj/item/device/flashlight/flare)

/datum/export/flashlight/seclite
	cost = 10
	unit_name = "seclite"
	export_types = list(/obj/item/device/flashlight/seclite)


// Analyzers and Scanners
/datum/export/analyzer
	cost = 5
	unit_name = "analyzer"
	export_types = list(/obj/item/device/analyzer)

/datum/export/analyzer/t_scanner
	cost = 10
	unit_name = "t-ray scanner"
	export_types = list(/obj/item/device/t_scanner)


/datum/export/radio
	cost = 5
	unit_name = "radio"
	export_types = list(/obj/item/device/radio)


// High-tech tools.
/datum/export/rcd
	cost = 1000
	unit_name = "rapid construction device"
	export_types = list(/obj/item/weapon/rcd)

/datum/export/rcd_ammo
	cost = 30
	unit_name = "compressed matter cardridge"
	export_types = list(/datum/design/rcd_ammo)

/datum/export/rpd
	cost = 1000
	unit_name = "rapid piping device"
	export_types = list(/obj/item/weapon/pipe_dispenser)

/datum/export/red
	cost = 2000
	unit_name = "rapid engineering device"
	export_types = list(/obj/item/weapon/rapid_engineering_device)