//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTHER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.
// Needs to go in Cargo Folder as "packs" -Super
/datum/supply_packs
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/cost = null
	var/containertype = /obj/structure/closet/crate
	var/crate_name = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/group = ""
	var/dangerous = FALSE // as in should our admins be messaged

/datum/supply_packs/proc/generate(turf/T)
	var/obj/structure/closet/crate/C = new containertype(T)
	C.name = crate_name
	if(access)
		C.req_access = list(access)

	for(var/item in contains)
		new item(C)
	return C

////// Use the sections to keep things tidy please /Malkevin

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/emergency	// Section header - use these to set default supply group and crate type for sections
	containertype = /obj/structure/closet/crate/internals
	group = "Emergency"


/datum/supply_packs/emergency/evac
	name = "Emergency equipment"
	contains = list(/obj/machinery/bot/floorbot,
					/obj/machinery/bot/floorbot,
					/obj/machinery/bot/medbot,
					/obj/machinery/bot/medbot,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas)
	cost = 3500
	containertype = /obj/structure/closet/crate/internals
	crate_name = "emergency crate"

/datum/supply_packs/emergency/internals
	name = "Internals Crate"
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air,
					/obj/item/weapon/tank/internals/air)
	cost = 1000
	crate_name = "internals crate"

/datum/supply_packs/emergency/firefighting
	name = "Firefighting Crate"
	contains = list(/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/device/flashlight,
					/obj/item/device/flashlight,
					/obj/item/weapon/tank/internals/oxygen/red,
					/obj/item/weapon/tank/internals/oxygen/red,
					/obj/item/weapon/extinguisher,
					/obj/item/weapon/extinguisher,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/clothing/head/hardhat/red)
	cost = 1000
	containertype = /obj/structure/closet/crate
	crate_name = "firefighting crate"

/datum/supply_packs/emergency/atmostank
	name = "Firefighting Watertank"
	contains = list(/obj/item/weapon/watertank/atmos)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "firefighting watertank crate"
	access = access_atmospherics

/datum/supply_packs/emergency/weedcontrol
	name = "Weed Control Crate"
	contains = list(/obj/item/weapon/scythe,
					/obj/item/clothing/mask/gas,
					/obj/item/weapon/grenade/chem_grenade/antiweed,
					/obj/item/weapon/grenade/chem_grenade/antiweed)
	cost = 1500
	containertype = /obj/structure/closet/crate/secure/hydrosec
	crate_name = "weed control crate"
	access = access_hydroponics

/datum/supply_packs/emergency/specialops
	name = "Special Ops supplies"
	contains = list(/obj/item/weapon/storage/box/emps,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/grenade/smokebomb,
					/obj/item/weapon/pen/sleepy,
					/obj/item/weapon/grenade/chem_grenade/incendiary)
	cost = 2000
	containertype = /obj/structure/closet/crate
	crate_name = "special ops crate"
	hidden = 1

/datum/supply_packs/emergency/syndicate
	name = "ERROR_NULL_ENTRY"
	contains = list(/obj/item/weapon/storage/box/syndicate)
	cost = 14000
	containertype = /obj/structure/closet/crate
	crate_name = "crate"
	hidden = 1
	dangerous = TRUE

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Security ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/security
	containertype = /obj/structure/closet/crate/secure/gear
	access = access_security
	group = "Security"


/datum/supply_packs/security/supplies
	name = "Security Supplies Crate"
	contains = list(/obj/item/weapon/storage/box/flashbangs,
					/obj/item/weapon/storage/box/teargas,
					/obj/item/weapon/storage/box/flashes,
					/obj/item/weapon/storage/box/handcuffs)
	cost = 1000
	crate_name = "security supply crate"

////// Armor: Basic

/datum/supply_packs/security/helmets
	name = "Helmets Crate"
	contains = list(/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec)
	cost = 1000
	crate_name = "helmet crate"

/datum/supply_packs/security/armor
	name = "Armor Crate"
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest)
	cost = 1000
	crate_name = "armor crate"

////// Weapons: Basic

/datum/supply_packs/security/baton
	name = "Stun Batons Crate"
	contains = list(/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/melee/baton/loaded,
					/obj/item/weapon/melee/baton/loaded)
	cost = 1000
	crate_name = "stun baton crate"

/datum/supply_packs/security/laser
	name = "Lasers Crate"
	contains = list(/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/laser,
					/obj/item/weapon/gun/energy/laser)
	cost = 1500
	crate_name = "laser crate"

/datum/supply_packs/security/taser
	name = "Stun Guns Crate"
	contains = list(/obj/item/weapon/gun/energy/gun/advtaser,
					/obj/item/weapon/gun/energy/gun/advtaser,
					/obj/item/weapon/gun/energy/gun/advtaser)
	cost = 1500
	crate_name = "stun gun crate"

/datum/supply_packs/security/disabler
	name = "Disabler Crate"
	contains = list(/obj/item/weapon/gun/energy/disabler,
					/obj/item/weapon/gun/energy/disabler,
					/obj/item/weapon/gun/energy/disabler)
	cost = 1000
	crate_name = "disabler crate"

/datum/supply_packs/security/forensics
	name = "Forensics Crate"
	contains = list(/obj/item/device/detective_scanner,
	                /obj/item/weapon/storage/box/evidence,
	                /obj/item/device/camera,
	                /obj/item/device/taperecorder,
	                /obj/item/toy/crayon/white,
	                /obj/item/clothing/head/det_hat)
	cost = 2000
	crate_name ="forensics crate"

///// Armory stuff

/datum/supply_packs/security/armory
	containertype = /obj/structure/closet/crate/secure/weapon
	access = access_armory

///// Armor: Specialist

/datum/supply_packs/security/armory/riothelmets
	name = "Riot Helmets Crate"
	contains = list(/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot)
	cost = 1500
	crate_name = "riot helmets crate"

/datum/supply_packs/security/armory/riotarmor
	name = "Riot Armor Crate"
	contains = list(/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot)
	cost = 1500
	crate_name = "riot armor crate"

/datum/supply_packs/security/armory/riotshields
	name = "Riot Shields Crate"
	contains = list(/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot,
					/obj/item/weapon/shield/riot)
	cost = 2000
	crate_name = "riot shields crate"

/datum/supply_packs/security/armory/bulletarmor
	name = "Bulletproof Armor Crate"
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof)
	cost = 1500
	crate_name = "tactical armor crate"

/datum/supply_packs/security/armory/laserarmor
	name = "Ablative Armor Crate"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof)		// Only two vests to keep costs down for balance
	cost = 2000
	containertype = /obj/structure/closet/crate/secure/plasma
	crate_name = "ablative armor crate"

/////// Weapons: Specialist

/datum/supply_packs/security/armory/ballistic
	name = "Combat Shotguns Crate"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/automatic/combat,
					/obj/item/weapon/gun/projectile/shotgun/automatic/combat,
					/obj/item/weapon/gun/projectile/shotgun/automatic/combat,
					/obj/item/weapon/storage/belt/bandolier,
					/obj/item/weapon/storage/belt/bandolier,
					/obj/item/weapon/storage/belt/bandolier)
	cost = 2000
	crate_name = "combat shotgun crate"

/datum/supply_packs/security/armory/expenergy
	name = "Energy Guns Crate"
	contains = list(/obj/item/weapon/gun/energy/gun,
					/obj/item/weapon/gun/energy/gun)			// Only two guns to keep costs down
	cost = 2500
	containertype = /obj/structure/closet/crate/secure/plasma
	crate_name = "energy gun crate"

/datum/supply_packs/security/armory/eweapons
	name = "Incendiary Weapons Crate"
	contains = list(/obj/item/weapon/flamethrower/full,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/grenade/chem_grenade/incendiary,
					/obj/item/weapon/grenade/chem_grenade/incendiary,
					/obj/item/weapon/grenade/chem_grenade/incendiary)
	cost = 1500	// its a fecking flamethrower and some plasma, why the shit did this cost so much before!?
	containertype = /obj/structure/closet/crate/secure/plasma
	crate_name = "incendiary weapons crate"
	access = access_heads
	dangerous = TRUE

/////// Implants & etc

/datum/supply_packs/security/armory/loyalty
	name = "Loyalty Implants Crate"
	contains = list (/obj/item/weapon/storage/lockbox/loyalty)
	cost = 4000
	crate_name = "loyalty implant crate"

/datum/supply_packs/security/armory/trackingimp
	name = "Tracking Implants Crate"
	contains = list (/obj/item/weapon/storage/box/trackimp)
	cost = 2000
	crate_name = "tracking implant crate"

/datum/supply_packs/security/armory/chemimp
	name = "Chemical Implants Crate"
	contains = list (/obj/item/weapon/storage/box/chemimp)
	cost = 2000
	crate_name = "chemical implant crate"

/datum/supply_packs/security/armory/exileimp
	name = "Exile Implants Crate"
	contains = list (/obj/item/weapon/storage/box/exileimp)
	cost = 3000
	crate_name = "exile implant crate"

/datum/supply_packs/security/armory/bombcollars
	name = "Bomb Collar Crate"
	contains = list(/obj/item/clothing/head/bombCollar,
					/obj/item/clothing/head/bombCollar,
					/obj/item/clothing/head/bombCollar,
					/obj/item/device/collarDetonator,
					/obj/item/weapon/paper/bombcollars)
	cost = 4000
	crate_name = "bomb collar crate"

/datum/supply_packs/security/securitybarriers
	name = "Security Barriers Crate"
	contains = list(/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier,
					/obj/machinery/deployable/barrier)
	cost = 2000
	crate_name = "security barriers crate"

/datum/supply_packs/security/firingpins
	name = "Standard Firing Pins Crate"
	contains = list(/obj/item/weapon/storage/box/firingpins,
					/obj/item/weapon/storage/box/firingpins)
	cost = 1000
	crate_name = "firing pins crate"

/datum/supply_packs/security/securityclothes
	name = "Security Clothing Crate"
	contains = list(/obj/item/clothing/under/rank/security/navyblue,
					/obj/item/clothing/under/rank/security/navyblue,
					/obj/item/clothing/suit/security/officer,
					/obj/item/clothing/suit/security/officer,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/under/rank/warden/navyblue,
					/obj/item/clothing/suit/security/warden,
					/obj/item/clothing/head/beret/sec/navywarden,
					/obj/item/clothing/under/rank/head_of_security/navyblue,
					/obj/item/clothing/suit/security/hos,
					/obj/item/clothing/head/beret/sec/navyhos)
	cost = 3000
	crate_name = "security clothing crate"

/datum/supply_packs/security/armory/pinpointer
	name = "Pinpointer crate"
	contains = list (/obj/item/weapon/storage/lockbox/pinpointer)
	cost = 4000
	crate_name = "pinpointer crate"

/////// Joke Crate Inbound

/datum/supply_packs/security/justiceinbound
	name = "Standard Justice Enforcer Crate"
	contains = list(/obj/item/clothing/head/helmet/justice,
					/obj/item/clothing/mask/gas/sechailer)
	cost = 8000 //justice comes at a price. An expensive, noisy price.
	crate_name = "justice enforcer crate"


//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Engineering /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/engineering
	group = "Engineering"


/datum/supply_packs/engineering/fueltank
	name = "Fuel Tank Crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 800
	containertype = /obj/structure/largecrate
	crate_name = "fuel tank crate"

/datum/supply_packs/engineering/tools		//the most robust crate
	name = "Toolbox Crate"
	contains = list(/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/mechanical,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/toolbox/mechanical,
					/obj/item/weapon/storage/toolbox/mechanical)
	cost = 1000
	crate_name = "electrical maintenance crate"

/datum/supply_packs/engineering/powergamermitts
	name = "Insulated Gloves Crate"
	contains = list(/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow)
	cost = 2000	//Made of pure-grade bullshittinium
	crate_name = "insulated gloves crate"

/datum/supply_packs/engineering/power
	name = "Powercell Crate"
	contains = list(/obj/item/weapon/stock_parts/cell/high,		//Changed to an extra high powercell because normal cells are useless
					/obj/item/weapon/stock_parts/cell/high,
					/obj/item/weapon/stock_parts/cell/high)
	cost = 1000
	crate_name = "electrical maintenance crate"

/datum/supply_packs/engineering/engiequipment
	name = "Engineering Gear Crate"
	contains = list(/obj/item/weapon/storage/belt/utility,
					/obj/item/weapon/storage/belt/utility,
					/obj/item/weapon/storage/belt/utility,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/suit/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat)
	cost = 1000
	crate_name = "engineering gear crate"

/datum/supply_packs/engineering/solar
	name = "Solar Pack Crate"
	contains  = list(/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly, // 21 Solar Assemblies. 1 Extra for the controller
					/obj/item/weapon/circuitboard/solar_control,
					/obj/item/weapon/tracker_electronics,
					/obj/item/weapon/paper/solar)
	cost = 2000
	crate_name = "solar pack crate"

/datum/supply_packs/engineering/engine
	name = "Emitter Crate"
	contains = list(/obj/machinery/power/emitter,
					/obj/machinery/power/emitter)
	cost = 1500
	containertype = /obj/structure/closet/crate/secure
	crate_name = "emitter crate"
	access = access_ce
	dangerous = TRUE

/datum/supply_packs/engineering/engine/field_gen
	name = "Field Generator Crate"
	contains = list(/obj/machinery/field/generator,
					/obj/machinery/field/generator)
	cost = 1500
	crate_name = "field generator crate"

/datum/supply_packs/engineering/engine/sing_gen
	name = "Singularity Generator Crate"
	contains = list(/obj/machinery/the_singularitygen)
	cost = 5000
	crate_name = "singularity generator crate"

/datum/supply_packs/engineering/engine/collector
	name = "Collector Crate"
	contains = list(/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector)
	cost = 2500
	crate_name = "collector crate"

/datum/supply_packs/engineering/engine/tesla_collector
	name = "Tesla Collector Crate"
	contains = list(/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod)
	cost = 2000
	crate_name = "tesla collector crate"

/datum/supply_packs/engineering/engine/tesla_gen
	name = "Tesla Generator Crate"
	contains = list(/obj/machinery/the_singularitygen/tesla)
	cost = 5000
	crate_name = "tesla generator"


/datum/supply_packs/engineering/engine/PA
	name = "Particle Accelerator Crate"
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	cost = 3000
	crate_name = "particle accelerator crate"

/datum/supply_packs/engineering/engine/supermatter_shard
	name = "Supermatter Shard Crate"
	contains = list(/obj/machinery/power/supermatter_shard)
	cost = 20000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "supermatter shard crate"
	access = access_ce
	dangerous = TRUE

/datum/supply_packs/engineering/engine/spacesuit
	name = "Space Suit Crate"
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/mask/breath,)
	cost = 8000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "space suit crate"
	access = access_eva

/datum/supply_packs/engineering/flood_lamp
	name = "Flood Lamp Assembly Crate"
	contains = list(/obj/machinery/flood_lamp,
					/obj/item/device/flashlight,
					/obj/item/device/flashlight,
					/obj/item/device/flashlight,
					/obj/item/weapon/stock_parts/cell/high,
					/obj/item/weapon/paper/flood_lamp)
	cost = 1500
	crate_name = "floodlamp assembly crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/medical
	containertype = /obj/structure/closet/crate/medical
	group = "Medical"


/datum/supply_packs/medical/supplies
	name = "Medical Supplies Crate"
	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/charcoal,
					/obj/item/weapon/reagent_containers/glass/bottle/charcoal,
					/obj/item/weapon/reagent_containers/glass/bottle/epinephrine,
					/obj/item/weapon/reagent_containers/glass/bottle/epinephrine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/morphine,
					/obj/item/weapon/reagent_containers/glass/bottle/toxin,
					/obj/item/weapon/reagent_containers/glass/bottle/toxin,
					/obj/item/weapon/reagent_containers/glass/beaker/large,
					/obj/item/weapon/reagent_containers/glass/beaker/large,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/weapon/reagent_containers/pill/insulin,
					/obj/item/stack/medical/gauze,
					/obj/item/weapon/storage/box/beakers,
					/obj/item/weapon/storage/box/syringes,
				    /obj/item/weapon/storage/box/bodybags)
	cost = 2000
	containertype = /obj/structure/closet/crate/medical
	crate_name = "medical supplies crate"

/datum/supply_packs/medical/firstaid
	name = "First Aid Kits Crate"
	contains = list(/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/regular,
					/obj/item/weapon/storage/firstaid/regular)
	cost = 1000
	crate_name = "first aid kits crate"

/datum/supply_packs/medical/firstaidbruises
	name = "Bruise Treatment Kits Crate"
	contains = list(/obj/item/weapon/storage/firstaid/brute,
					/obj/item/weapon/storage/firstaid/brute,
					/obj/item/weapon/storage/firstaid/brute)
	cost = 1000
	crate_name = "brute trauma first aid kits crate"

/datum/supply_packs/medical/firstaidburns
	name = "Burns Treatment Kits Crate"
	contains = list(/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/fire,
					/obj/item/weapon/storage/firstaid/fire)
	cost = 1000
	crate_name = "fire first aid kits crate"

/datum/supply_packs/medical/firstaidtoxins
	name = "Toxin Treatment Kits Crate"
	contains = list(/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/toxin,
					/obj/item/weapon/storage/firstaid/toxin)
	cost = 1000
	crate_name = "toxin first aid kits crate"

/datum/supply_packs/medical/firstaidoxygen
	name = "Oxygen Deprivation Kits Crate"
	contains = list(/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/o2,
					/obj/item/weapon/storage/firstaid/o2)
	cost = 1000
	crate_name = "oxygen deprivation kits crate"


/datum/supply_packs/medical/virus
	name = "Virus Crate"
	contains = list(/obj/item/weapon/reagent_containers/glass/bottle/flu_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/cold,
					/obj/item/weapon/reagent_containers/glass/bottle/epiglottis_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/liver_enhance_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/weapon/reagent_containers/glass/bottle/magnitis,
					/obj/item/weapon/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/weapon/reagent_containers/glass/bottle/brainrot,
					/obj/item/weapon/reagent_containers/glass/bottle/hullucigen_virion,
					/obj/item/weapon/reagent_containers/glass/bottle/anxiety,
					/obj/item/weapon/reagent_containers/glass/bottle/beesease,
					/obj/item/weapon/storage/box/syringes,
					/obj/item/weapon/storage/box/beakers,
					/obj/item/weapon/reagent_containers/glass/bottle/mutagen)
	cost = 2500
	containertype = /obj/structure/closet/crate/secure/plasma
	crate_name = "virus crate"
	access = access_cmo
	dangerous = TRUE


/datum/supply_packs/medical/bloodpacks
	name = "Blood Pack Variety Crate"
	contains = list(/obj/item/weapon/reagent_containers/blood/empty,
					/obj/item/weapon/reagent_containers/blood/empty,
					/obj/item/weapon/reagent_containers/blood/APlus,
					/obj/item/weapon/reagent_containers/blood/AMinus,
					/obj/item/weapon/reagent_containers/blood/BPlus,
					/obj/item/weapon/reagent_containers/blood/BMinus,
					/obj/item/weapon/reagent_containers/blood/OPlus,
					/obj/item/weapon/reagent_containers/blood/OMinus)
	cost = 3500
	containertype = /obj/structure/closet/crate/freezer
	crate_name = "blood pack crate"

/datum/supply_packs/medical/iv_drip
	name = "IV Drip Crate"
	contains = list(/obj/machinery/iv_drip)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "iv drip crate"
	access = access_cmo

/datum/supply_packs/medical/surgery
	name = "Surgery Supply Crate"
	contains = list(/obj/item/weapon/scalpel,
					/obj/item/weapon/hemostat,
					/obj/item/weapon/cautery,
					/obj/item/weapon/retractor,
					/obj/item/weapon/circular_saw,
					/obj/item/weapon/surgicaldrill,
					/obj/item/weapon/surgical_drapes,
					/obj/item/weapon/tank/internals/anesthetic,
					/obj/item/clothing/mask/breath/medical)
	cost = 1500
	containertype = /obj/structure/closet/crate/medical
	crate_name = "surgery crate"

/datum/supply_packs/medical/surgery_table
	name = "Surgery Table Crate"
	contains = list(/obj/item/weapon/circuitboard/operating)
	cost = 2000
	containertype = /obj/structure/closet/crate/surgery_table
	crate_name = "surgery table crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Science /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/science
	group = "Science"


/datum/supply_packs/science/robotics
	name = "Robotics Assembly Crate"
	contains = list(/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/weapon/storage/box/flashes,
					/obj/item/weapon/stock_parts/cell/high,
					/obj/item/weapon/stock_parts/cell/high)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "robotics assembly crate"
	access = access_robotics

/datum/supply_packs/science/robotics/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(/obj/item/weapon/book/manual/ripley_build_and_repair,
					/obj/item/weapon/circuitboard/mecha/ripley/main, //TEMPORARY due to lack of circuitboard printer
					/obj/item/weapon/circuitboard/mecha/ripley/peripherals) //TEMPORARY due to lack of circuitboard printer
	cost = 3000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "\improper APLU \"Ripley\" circuit crate"

/datum/supply_packs/science/robotics/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(/obj/item/weapon/circuitboard/mecha/odysseus/peripherals, //TEMPORARY due to lack of circuitboard printer
					/obj/item/weapon/circuitboard/mecha/odysseus/main) //TEMPORARY due to lack of circuitboard printer
	cost = 2500
	containertype = /obj/structure/closet/crate/secure
	crate_name = "\improper \"Odysseus\" circuit crate"

/datum/supply_packs/science/plasma
	name = "Plasma Assembly Crate"
	contains = list(/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/weapon/tank/internals/plasma,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure/plasma
	crate_name = "plasma assembly crate"
	access = access_tox_storage

/datum/supply_packs/science/shieldwalls
	name = "Shield Generators"
	contains = list(/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen)
	cost = 2000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "shield generators crate"
	access = access_teleporter


/datum/supply_packs/science/transfer_valves
	name = "Tank Transfer Valves"
	contains = list(/obj/item/device/transfer_valve,
					/obj/item/device/transfer_valve)
	cost = 6000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "transfer valves crate"
	access = access_rd
	dangerous = TRUE

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/organic
	group = "Food & Livestock"
	containertype = /obj/structure/closet/crate/freezer


/datum/supply_packs/organic/food
	name = "Food Crate"
	contains = list(/obj/item/weapon/reagent_containers/food/condiment/flour,
					/obj/item/weapon/reagent_containers/food/condiment/rice,
					/obj/item/weapon/reagent_containers/food/condiment/milk,
					/obj/item/weapon/reagent_containers/food/condiment/soymilk,
					/obj/item/weapon/storage/fancy/egg_box,
					/obj/item/weapon/reagent_containers/food/condiment/enzyme,
					/obj/item/weapon/reagent_containers/food/condiment/sugar,
					/obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey,
					/obj/item/weapon/reagent_containers/food/snacks/grown/banana,
					/obj/item/weapon/reagent_containers/food/snacks/grown/banana,
					/obj/item/weapon/reagent_containers/food/snacks/grown/banana)
	cost = 1000
	crate_name = "food crate"

/datum/supply_packs/organic/pizza
	name = "Pizza Crate"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	cost = 6000
	crate_name = "Pizza crate"

/datum/supply_packs/organic/monkey
	name = "Monkey Crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes)
	cost = 2000
	crate_name = "monkey crate"

/datum/supply_packs/organic/party
	name = "Party equipment"
	contains = list(/obj/item/weapon/storage/box/drinkingglasses,
					/obj/item/weapon/reagent_containers/food/drinks/shaker,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
					/obj/item/weapon/reagent_containers/food/drinks/ale,
					/obj/item/weapon/reagent_containers/food/drinks/ale,
					/obj/item/weapon/reagent_containers/food/drinks/beer,
					/obj/item/weapon/reagent_containers/food/drinks/beer,
					/obj/item/weapon/reagent_containers/food/drinks/beer,
					/obj/item/weapon/reagent_containers/food/drinks/beer)
	cost = 2000
	crate_name = "party equipment"

//////// livestock
/datum/supply_packs/organic/cow
	name = "Cow Crate"
	cost = 3000
	containertype = /obj/structure/closet/critter/cow
	crate_name = "cow crate"

/datum/supply_packs/organic/goat
	name = "Goat Crate"
	cost = 2500
	containertype = /obj/structure/closet/critter/goat
	crate_name = "goat crate"

/datum/supply_packs/organic/chicken
	name = "Chicken Crate"
	cost = 2000
	containertype = /obj/structure/closet/critter/chick
	crate_name = "chicken crate"

/datum/supply_packs/organic/corgi
	name = "Corgi Crate"
	cost = 5000
	containertype = /obj/structure/closet/critter/corgi
	contains = list(/obj/item/clothing/tie/petcollar)
	crate_name = "corgi crate"

/datum/supply_packs/organic/cat
	name = "Cat Crate"
	cost = 5000 //Cats are worth as much as corgis.
	containertype = /obj/structure/closet/critter/cat
	contains = list(/obj/item/clothing/tie/petcollar)
	crate_name = "cat crate"

/datum/supply_packs/organic/pug
	name = "Pug Crate"
	cost = 5000
	containertype = /obj/structure/closet/critter/pug
	contains = list(/obj/item/clothing/tie/petcollar)
	crate_name = "pug crate"

/datum/supply_packs/organic/fox
	name = "Fox Crate"
	cost = 5500 //Foxes are cool.
	containertype = /obj/structure/closet/critter/fox
	contains = list(/obj/item/clothing/tie/petcollar)
	crate_name = "fox crate"

/datum/supply_packs/organic/butterfly
	name = "Butterflies Crate"
	cost = 5000
	containertype = /obj/structure/closet/critter/butterfly
	crate_name = "butterflies crate"
	contraband = 1

////// hippy gear

/datum/supply_packs/organic/hydroponics // -- Skie
	name = "Hydroponics Supply Crate"
	contains = list(/obj/item/weapon/reagent_containers/spray/plantbgone,
					/obj/item/weapon/reagent_containers/spray/plantbgone,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia,
					/obj/item/weapon/reagent_containers/glass/bottle/ammonia,
					/obj/item/weapon/hatchet,
					/obj/item/weapon/cultivator,
					/obj/item/device/analyzer/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron) // Updated with new things
	cost = 1500
	containertype = /obj/structure/closet/crate/hydroponics
	crate_name = "hydroponics crate"

/datum/supply_packs/misc/hydroponics/hydrotank
	name = "Hydroponics Watertank Backpack Crate"
	contains = list(/obj/item/weapon/watertank)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "hydroponics watertank crate"
	access = access_hydroponics

/datum/supply_packs/organic/hydroponics/seeds
	name = "Seeds Crate"
	contains = list(/obj/item/seeds/chiliseed,
					/obj/item/seeds/berryseed,
					/obj/item/seeds/cornseed,
					/obj/item/seeds/eggplantseed,
					/obj/item/seeds/tomatoseed,
					/obj/item/seeds/soyaseed,
					/obj/item/seeds/wheatseed,
					/obj/item/seeds/carrotseed,
					/obj/item/seeds/sunflowerseed,
					/obj/item/seeds/chantermycelium,
					/obj/item/seeds/potatoseed,
					/obj/item/seeds/sugarcaneseed)
	cost = 1000
	crate_name = "seeds crate"

/datum/supply_packs/organic/hydroponics/exoticseeds
	name = "Exotic Seeds Crate"
	contains = list(/obj/item/seeds/nettleseed,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/plumpmycelium,
					/obj/item/seeds/libertymycelium,
					/obj/item/seeds/amanitamycelium,
					/obj/item/seeds/reishimycelium,
					/obj/item/seeds/bananaseed,
					/obj/item/seeds/eggyseed)
	cost = 1500
	crate_name = "exotic seeds crate"

/datum/supply_packs/organic/vending
	name = "Bartending Supply Crate"
	contains = list(/obj/item/weapon/vending_refill/boozeomat,
					/obj/item/weapon/vending_refill/boozeomat,
					/obj/item/weapon/vending_refill/boozeomat,
					/obj/item/weapon/vending_refill/coffee,
					/obj/item/weapon/vending_refill/coffee,
					/obj/item/weapon/vending_refill/coffee)
	cost = 2000
	crate_name = "bartending supply crate"

/datum/supply_packs/organic/vending/snack
	name = "Snack Supply Crate"
	contains = list(/obj/item/weapon/vending_refill/snack,
					/obj/item/weapon/vending_refill/snack,
					/obj/item/weapon/vending_refill/snack)
	cost = 1500
	crate_name = "snacks supply crate"

/datum/supply_packs/organic/vending/cola
	name = "Softdrinks Supply Crate"
	contains = list(/obj/item/weapon/vending_refill/cola,
					/obj/item/weapon/vending_refill/cola,
					/obj/item/weapon/vending_refill/cola)
	cost = 1500
	crate_name = "softdrinks supply crate"

/datum/supply_packs/organic/vending/cigarette
	name = "Cigarette Supply Crate"
	contains = list(/obj/item/weapon/vending_refill/cigarette,
					/obj/item/weapon/vending_refill/cigarette,
					/obj/item/weapon/vending_refill/cigarette)
	cost = 1500
	crate_name = "cigarette supply crate"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Materials ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/materials
	group = "Raw Materials"


/datum/supply_packs/materials/metal50
	name = "50 Metal Sheets"
	contains = list(/obj/item/stack/sheet/metal/fifty)
	cost = 1000
	crate_name = "metal sheets crate"

/datum/supply_packs/materials/plasteel20
	name = "20 Plasteel Sheets"
	contains = list(/obj/item/stack/sheet/plasteel/twenty)
	cost = 3000
	crate_name = "plasteel sheets crate"

/datum/supply_packs/materials/plasteel50
	name = "50 Plasteel Sheets"
	contains = list(/obj/item/stack/sheet/plasteel/fifty)
	cost = 5000
	crate_name = "plasteel sheets crate"

/datum/supply_packs/materials/glass50
	name = "50 Glass Sheets"
	contains = list(/obj/item/stack/sheet/glass/fifty)
	cost = 1000
	crate_name = "glass sheets crate"

/datum/supply_packs/materials/cardboard50
	name = "50 Cardboard Sheets"
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	cost = 1000
	crate_name = "cardboard sheets crate"

/datum/supply_packs/materials/sandstone30
	name = "30 Sandstone Blocks"
	contains = list(/obj/item/stack/sheet/mineral/sandstone/fifty)
	cost = 1000
	crate_name = "sandstone blocks crate"


//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/misc
	group = "Miscellaneous Supplies"

/datum/supply_packs/misc/mule
	name = "MULEbot Crate"
	contains = list(/obj/machinery/bot/mulebot)
	cost = 2000
	containertype = /obj/structure/largecrate/mule
	crate_name = "\improper MULEbot Crate"

/datum/supply_packs/misc/conveyor
	name = "Conveyor Assembly Crate"
	contains = list(/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_switch_construct,
					/obj/item/weapon/paper/conveyor)
	cost = 1500
	crate_name = "conveyor assembly crate"

/datum/supply_packs/misc/watertank
	name = "Water Tank Crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 800
	containertype = /obj/structure/largecrate
	crate_name = "water tank crate"

/datum/supply_packs/misc/lasertag
	name = "Laser Tag Crate"
	contains = list(/obj/item/weapon/gun/energy/laser/redtag,
					/obj/item/weapon/gun/energy/laser/redtag,
					/obj/item/weapon/gun/energy/laser/redtag,
					/obj/item/weapon/gun/energy/laser/bluetag,
					/obj/item/weapon/gun/energy/laser/bluetag,
					/obj/item/weapon/gun/energy/laser/bluetag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/head/helmet/redtaghelm,
					/obj/item/clothing/head/helmet/bluetaghelm)
	cost = 1500
	crate_name = "laser tag crate"

/datum/supply_packs/misc/religious_supplies
	name = "Religious Supplies Crate"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater,
					/obj/item/weapon/storage/book/bible/booze,
					/obj/item/weapon/storage/book/bible/booze,
					/obj/item/clothing/suit/hooded/chaplain_hoodie,
					/obj/item/clothing/suit/hooded/chaplain_hoodie)
	cost = 4000	// it costs so much because the Space Church is ran by Space Jews
	crate_name = "religious supplies crate"

/datum/supply_packs/misc/posters
	name = "Corporate Posters Crate"
	contains = list(/obj/item/weapon/contraband/poster/legit,
					/obj/item/weapon/contraband/poster/legit,
					/obj/item/weapon/contraband/poster/legit,
					/obj/item/weapon/contraband/poster/legit,
					/obj/item/weapon/contraband/poster/legit)
	cost = 800
	crate_name = "Corporate Posters Crate"


///////////// Paper Work

/datum/supply_packs/misc/paper
	name = "Bureaucracy Crate"
	contains = list(/obj/structure/filingcabinet/chestdrawer/wheeled,
					/obj/item/device/camera_film,
					/obj/item/weapon/hand_labeler,
					/obj/item/hand_labeler_refill,
					/obj/item/hand_labeler_refill,
					/obj/item/weapon/paper_bin,
					/obj/item/weapon/pen,
					/obj/item/weapon/pen/blue,
					/obj/item/weapon/pen/red,
					/obj/item/weapon/folder/blue,
					/obj/item/weapon/folder/red,
					/obj/item/weapon/folder/yellow,
					/obj/item/weapon/clipboard,
					/obj/item/weapon/clipboard)
	cost = 1500
	crate_name = "bureaucracy crate"

/datum/supply_packs/misc/toner
	name = "Toner Cartridges crate"
	contains = list(/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner,
					/obj/item/device/toner)
	cost = 1000
	crate_name = "toner cartridges crate"


///////////// Janitor Supplies

/datum/supply_packs/misc/janitor
	name = "Janitorial Supplies Crate"
	contains = list(/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/reagent_containers/glass/bucket,
					/obj/item/weapon/mop,
					/obj/item/weapon/caution,
					/obj/item/weapon/caution,
					/obj/item/weapon/caution,
					/obj/item/weapon/storage/bag/trash,
					/obj/item/weapon/reagent_containers/spray/cleaner,
					/obj/item/weapon/reagent_containers/glass/rag,
					/obj/item/weapon/grenade/chem_grenade/cleaner,
					/obj/item/weapon/grenade/chem_grenade/cleaner,
					/obj/item/weapon/grenade/chem_grenade/cleaner)
	cost = 1000
	crate_name = "janitorial supplies crate"

/datum/supply_packs/misc/janitor/janicart
	name = "Janitorial Cart and Galoshes Crate"
	contains = list(/obj/structure/janitorialcart,
					/obj/item/clothing/shoes/galoshes)
	cost = 1000
	containertype = /obj/structure/largecrate
	crate_name = "janitorial cart crate"

/datum/supply_packs/misc/janitor/janitank
	name = "Janitor Watertank Backpack"
	contains = list(/obj/item/weapon/watertank/janitor)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "janitor watertank crate"
	access = access_janitor

/datum/supply_packs/misc/janitor/lightbulbs
	name = "Replacement Lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixed,
					/obj/item/weapon/storage/box/lights/mixed,
					/obj/item/weapon/storage/box/lights/mixed)
	cost = 1000
	crate_name = "replacement lights"

/datum/supply_packs/misc/noslipfloor
	name = "High-traction Floor Tiles"
	contains = list(/obj/item/stack/tile/noslip/fifty)
	cost = 2000
	crate_name = "high-traction floor tiles"


///////////// Costumes

/datum/supply_packs/misc/costume
	name = "Standard Costume Crate"
	contains = list(/obj/item/weapon/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/clown,
					/obj/item/device/assembly/bikehorn,
					/obj/item/clothing/under/rank/mime,
					/obj/item/clothing/shoes/sneakers/black,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/suit/suspenders,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing,
					/obj/item/weapon/storage/backpack/mime)
	cost = 1000
	containertype = /obj/structure/closet/crate/secure
	crate_name = "standard costumes"
	access = access_theatre

/datum/supply_packs/misc/wizard
	name = "Wizard Costume Crate"
	contains = list(/obj/item/weapon/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	cost = 2000
	crate_name = "wizard costume crate"

/datum/supply_packs/misc/randomised
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	name = "Collectable hat crate!"
	cost = 20000
	crate_name = "collectable hats crate! Brought to you by Bass.inc!"

/datum/supply_packs/misc/randomised/New()
	manifest += "Contains any [num_contained] of:"
	..()


/datum/supply_packs/misc/randomised/contraband
	num_contained = 5
	contains = list(/obj/item/weapon/contraband/poster,
					/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_shadyjims)
	name = "Contraband Crate"
	cost = 3000
	crate_name = "crate"	//let's keep it subtle, eh?
	contraband = 1

/datum/supply_packs/misc/randomised/toys
	name = "Toy Crate"
	num_contained = 5
	contains = list(/obj/item/toy/spinningtoy,
	                /obj/item/toy/sword,
	                /obj/item/toy/foamblade,
	                /obj/item/toy/AI,
	                /obj/item/toy/owl,
	                /obj/item/toy/griffin,
	                /obj/item/toy/nuke,
	                /obj/item/toy/minimeteor,
	                /obj/item/toy/carpplushie,
	                /obj/item/weapon/coin/antagtoken,
	                /obj/item/stack/tile/fakespace,
	                /obj/item/weapon/gun/projectile/shotgun/toy/crossbow,
	                /obj/item/toy/redbutton)

	cost = 5000 // or play the arcade machines ya lazy bum
	crate_name ="toy crate"

/datum/supply_packs/misc/autodrobe
	name = "Autodrobe Supply Crate"
	contains = list(/obj/item/weapon/vending_refill/autodrobe,
					/obj/item/weapon/vending_refill/autodrobe)
	cost = 1500
	crate_name = "autodrobe supply crate"

/datum/supply_packs/misc/formalwear //This is a very classy crate.
	name = "Formal-wear Crate"
	contains = list(/obj/item/clothing/under/blacktango,
					/obj/item/clothing/under/assistantformal,
					/obj/item/clothing/under/assistantformal,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/suit/toggle/lawyer,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/suit/toggle/lawyer/purple,
					/obj/item/clothing/under/lawyer/blacksuit,
					/obj/item/clothing/suit/toggle/lawyer/black,
					/obj/item/clothing/tie/waistcoat,
					/obj/item/clothing/tie/blue,
					/obj/item/clothing/tie/red,
					/obj/item/clothing/tie/black,
					/obj/item/clothing/head/bowler,
					/obj/item/clothing/head/fedora,
					/obj/item/clothing/head/flatcap,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/head/that,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/under/suit_jacket/charcoal,
					/obj/item/clothing/under/suit_jacket/navy,
					/obj/item/clothing/under/suit_jacket/burgundy,
					/obj/item/clothing/under/suit_jacket/checkered,
					/obj/item/clothing/under/suit_jacket/tan,
					/obj/item/weapon/lipstick/random)
	cost = 3000 //Lots of very expensive items. You gotta pay up to look good!
	crate_name = "formal-wear crate"

/datum/supply_packs/misc/foamforce
	name = "Foam Force Crate"
	contains = list(/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy,
					/obj/item/weapon/gun/projectile/shotgun/toy)
	cost = 1000
	crate_name = "foam force crate"

/datum/supply_packs/misc/foamforce/bonus
	name = "Foam Force Pistols Crate"
	contains = list(/obj/item/weapon/gun/projectile/automatic/toy/pistol,
					/obj/item/weapon/gun/projectile/automatic/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol)
	cost = 4000
	crate_name = "foam force pistols crate"
	contraband = 1