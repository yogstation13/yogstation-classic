/datum/objective/crew
	proc/setup()

	captain
		hat
			explanation_text = "Don't lose your hat!"
			check_completion()
				if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/caphat))
					return 1
				else
					return 0
		drunk
			explanation_text = "Have alcohol in your bloodstream at the end of the round."
			check_completion()
				if(owner.current && owner.current.reagents && owner.current.reagents.has_reagent("ethanol"))
					return 1
				else
					return 0

	headofsecurity
		hat
			explanation_text = "Have your beret on at the end of the round."
			check_completion()
				if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/beret/sec/navyhos))
					return 1
				else
					return 0
		brig
			explanation_text = "Have at least one antagonist cuffed in the brig at the end of the round." //can be dead as people usually suicide
			check_completion()
				for(var/datum/mind/M in ticker.minds)
					if(M.special_role && M.current && !istype(M.current,/mob/dead) && istype(get_area(M.current),/area/prison)) //think that's everything...
						var/mob/living/carbon/C = M.current //Oh the things we do to avoid the colon
						if(!C.handcuffed)
							return 1
				return 0
		centcom
			explanation_text = "Bring at least one antagonist back to CentCom in handcuffs for interrogation. You must accompany them on the escape shuttle." //can also be dead I guess
			check_completion()
				for(var/datum/mind/M in ticker.minds)
					if(M.special_role && M.current && !istype(M.current,/mob/dead) && istype(get_area(M.current),/area/shuttle/escape))
						if(owner.current && owner.current.stat != 2 && istype(get_area(owner.current),/area/shuttle/escape)) //split this up as it was long
							var/mob/living/carbon/C = M.current
							if(C.handcuffed)
								return 1
				return 0

	headofpersonnel
		vanish
			explanation_text = "End the round alive but not on the station or escape levels."
			check_completion()
				if(owner.current && owner.current.stat != 2 && owner.current.z != 1 && owner.current.z != 2) return 1
				else return 0

	chiefengineer
		power
			explanation_text = "Ensure that all APCs are powered at the end of the round."
			check_completion()
				for(var/obj/machinery/power/apc/C in world)
					if(C.cell && C.z == ZLEVEL_STATION) //This only works if you ban any CEs who try to de-cell every single APC on the station for greentext
						var/area/A = get_area(C)
						var/list/skipped_areas = list() //Add any exempt area here when this inevitably gets broken somehow
						var/skip = 0
						for(var/area_type in skipped_areas)
							if(istype(A,area_type))
								skip = 1
								break
						if(skip) continue

						if(C.cell.charge == 0)
							return 0

				return 1
		suit
			explanation_text = "End the round wearing your hardsuit and magboots."
			check_completion()
				if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/helmet/space/hardsuit/engine/elite) && owner.current.check_contents_for(/obj/item/clothing/shoes/magboots/advance))
					return 1
				return 0

//	securityofficer
	quartermaster
		profit
			explanation_text = "End the round with at least 200 unspent supply points."
			check_completion()
				if(SSshuttle.points >= 200) return 1
				else return 0

	detective
		drunk
			explanation_text = "Have alcohol in your bloodstream at the end of the round."
			check_completion()
				if(owner.current && owner.current.reagents && owner.current.reagents.has_reagent("ethanol"))
					return 1
				else
					return 0
		gear
			explanation_text = "Ensure that you are still wearing your coat, hat and uniform at the end of the round."
			check_completion()
				if(owner.current && ishuman(owner.current))
					var/mob/living/carbon/human/H = owner.current
					if(istype(H.w_uniform, /obj/item/clothing/under/rank/det) && istype(H.wear_suit, /obj/item/clothing/suit/det_suit) && istype(H.head, /obj/item/clothing/head/det_hat)) return 1
				return 0
		smoke
			explanation_text = "Make sure you're smoking at the end of the round."
			check_completion()
				if(owner.current)
					var/mob/living/carbon/C = owner.current
					if(istype(C.wear_mask,/obj/item/clothing/mask/cigarette))
						return 1
				return 0

	botanist
		mutantplants
			explanation_text = "Have four kinds of fertilizer with you at the end of the round." //Fertilizer in this case is anything that provides the plant nutrient
			check_completion() //Lots of things provide plants nutrients
				var/list/fert_types = list("eznutriment","left4zednutriment","robustharvestnutriment","beer","milk","phosphorus","sodawater","ammonia","saltpetre","ash","diethylamine","nutriment","virusfood","blood","adminordrazine")
				var/fert_count = 0
				if(owner.current && owner.current.contents)
					for(var/obj/item/weapon/reagent_containers/content in owner.current.contents)
						for(var/fert in fert_types)
							if(content.reagents.has_reagent(fert,1))
								fert_count++
								fert_types -= fert

				if(fert_count >= 4)
					return 1
				return 0
		noweed
			explanation_text = "Make sure there are no cannabis plants, seeds or products in Hydroponics at the end of the round."
			check_completion()
				for (var/obj/item/clothing/mask/cigarette/W in world)
					if (W.reagents.has_reagent("THC"))
						if (istype(get_area(W), /area/hydroponics) || istype(get_area(W), /area/hydroponics/backroom))
							return 0
				for (var/obj/item/weapon/reagent_containers/food/snacks/grown/cannabis/C in world)
					if (istype(get_area(C), /area/hydroponics) || istype(get_area(C), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/weapon/reagent_containers/food/snacks/grown/cannabis/mega/C in world)
					if (istype(get_area(C), /area/hydroponics) || istype(get_area(C), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/weapon/reagent_containers/food/snacks/grown/cannabis/black/C in world)
					if (istype(get_area(C), /area/hydroponics) || istype(get_area(C), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/weapon/reagent_containers/food/snacks/grown/cannabis/white/C in world)
					if (istype(get_area(C), /area/hydroponics) || istype(get_area(C), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/weapon/reagent_containers/food/snacks/grown/cannabis/omega/C in world)
					if (istype(get_area(C), /area/hydroponics) || istype(get_area(C), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/seeds/cannabis_seed/S in world)
					if (istype(get_area(S), /area/hydroponics) || istype(get_area(S), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/seeds/mega_cannabis_seed/S in world)
					if (istype(get_area(S), /area/hydroponics) || istype(get_area(S), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/seeds/black_cannabis_seed/S in world)
					if (istype(get_area(S), /area/hydroponics) || istype(get_area(S), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/seeds/white_cannabis_seed/S in world)
					if (istype(get_area(S), /area/hydroponics) || istype(get_area(S), /area/hydroponics/backroom))
						return 0
				for (var/obj/item/seeds/omega_cannabis_seed/S in world)
					if (istype(get_area(S), /area/hydroponics) || istype(get_area(S), /area/hydroponics/backroom))
						return 0
				for (var/obj/machinery/hydroponics/PP in machines)
					if (PP.myseed && (istype(PP.myseed, /obj/item/seeds/cannabis_seed) || istype(PP.myseed, /obj/item/seeds/mega_cannabis_seed) || istype(PP.myseed, /obj/item/seeds/white_cannabis_seed) || istype(PP.myseed, /obj/item/seeds/black_cannabis_seed) || istype(PP.myseed, /obj/item/seeds/omega_cannabis_seed)))
						if (istype(get_area(PP), /area/hydroponics) || istype(get_area(PP), /area/hydroponics/backroom))
							return 0
				return 1

	chaplain
		funeral
			explanation_text = "Have no corpses on the station level at the end of the round."
			check_completion()
				for(var/mob/living/carbon/human/H in world)
					if(H.z == 1 && H.stat == 2)
						return 0
				return 1

	janitor
		cleanbar
			explanation_text = "Make sure the bar is spotless at the end of the round."
			check_completion()
				for(var/turf/T in get_area_turfs(/area/crew_quarters/bar, 0))
					for(var/obj/effect/decal/cleanable/D in T)
						return 0
				return 1
		cleanmedbay
			explanation_text = "Make sure medbay is spotless at the end of the round."
			check_completion()
				for(var/turf/T in get_area_turfs(/area/medical/medbay, 0))
					for(var/obj/effect/decal/cleanable/D in T)
						return 0
				return 1
		cleanbrig
			explanation_text = "Make sure the brig is spotless at the end of the round."
			check_completion()
				for(var/turf/T in get_area_turfs(/area/security/brig, 0))
					for(var/obj/effect/decal/cleanable/D in T)
						return 0
				return 1

	barman
		tophat
			explanation_text = "Make sure that you have a top hat on at the end of the round."
			check_completion()
				if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/that))
					return 1
				else
					return 0

//	chef

//	engineer
/*
		cloner
			explanation_text = "Ensure that there are at least two cloners on the station level at the end of the round."
			check_completion()
				var/clonecount = 0
				for(var/obj/machinery/computer/cloning/C in machines) //ugh
					for(var/obj/machinery/dna_scannernew/D in orange(2,C))
						for(var/obj/machinery/clonepod/P in orange(2,C))
							clonecount++
							break
				if(clonecount > 1) return 1
				return 0
*/

	researchdirector
		lamarr
			explanation_text = "Ensure that Lamarr escapes on the shuttle."
			check_completion()
				for (var/obj/item/clothing/mask/facehugger/H in world)
					if (istype(get_area(H),/area/shuttle/escape) && !(H.stat == DEAD) && H.name == "Lamarr")
						return 1
				return 0
		hyper
			explanation_text = "Have methamphetamine in your bloodstream at the end of the round."
			check_completion()
				if(owner.current && owner.current.reagents && owner.current.reagents.has_reagent("methamphetamine"))
					return 1
				else
					return 0
		onfire
			explanation_text = "Escape on the shuttle alive while on fire with silver sulfadiazine in your bloodstream."
			check_completion()
				if(owner.current && owner.current.stat != 2 && ishuman(owner.current))
					var/mob/living/carbon/human/H = owner.current
					if(istype(get_area(H),/area/shuttle/escape) && H.on_fire && owner.current.reagents.has_reagent("silver_sulfadiazine")) return 1
					else return 0

	scientist
		hyper
			explanation_text = "Have methamphetamine in your bloodstream at the end of the round."
			check_completion()
				if(owner.current && owner.current.reagents && owner.current.reagents.has_reagent("methamphetamine"))
					return 1
				else
					return 0
		onfire
			explanation_text = "Escape on the shuttle alive while on fire with silver sulfadiazine in your bloodstream."
			check_completion()
				if(owner.current && owner.current.stat != 2 && ishuman(owner.current))
					var/mob/living/carbon/human/H = owner.current
					if(istype(get_area(H),/area/shuttle/escape) && H.on_fire && owner.current.reagents.has_reagent("silver_sulfadiazine")) return 1
					else return 0

		/*artifact // This is going to be really fucking awkward to do so disabling for now
			explanation_text = "Activate at least one artifact on the station z level by the end of the round, excluding the test artifact."
			check_completion()
				for(var/obj/machinery/artifact/A in machines)
					if(A.z == 1 && A.activated == 1 && A.name != "Test Artifact") return 1 //someone could label it I guess but I don't want to go adding an istestartifact var just for this..
				return 0*/

	medicaldirector // so much copy/pasted stuff  :(
		runtime
			explanation_text = "Ensure that Runtime escapes alive on the shuttle."
			check_completion()
				for (var/mob/living/simple_animal/pet/cat/Runtime/rtime in world)
					if (istype(get_area(rtime),/area/shuttle/escape) && rtime.health > 0) //ew
						return 1
				return 0
		scanned
			explanation_text = "Have at least 5 people's DNA scanned in the cloning console at the end of the round."
			check_completion()
				for(var/obj/machinery/computer/cloning/C in machines)
					if(C.records.len > 4)
						return 1
				return 0
		noscorch
			explanation_text = "Ensure that the floors of the chemistry lab are not scorched at the end of the round."
			check_completion()
				for(var/turf/simulated/floor/T in get_area_turfs(/area/medical/chemistry, 0))
					if(T.burnt == 1) return 0
				return 1
		/* Commented out because why would the MD control that
		cyborgs
			explanation_text = "Ensure that there are at least three living cyborgs at the end of the round."
			check_completion()
				var/borgcount = 0
				for(var/mob/living/silicon/robot in mobs) //borgs gib when they die so no need to check stat I think
					borgcount ++
				if(borgcount > 2) return 1
				else return 0
		*/
		medibots
			explanation_text = "Have at least five medibots on the station level at the end of the round."
			check_completion()
				var/medbots = 0
				for (var/obj/machinery/bot/medbot/M in machines)
					if (M.z == 1)
						medbots++
				if (medbots > 4) return 1
				else return 0
		/* Left in for when we implement goon style butt surgery
		buttbots
			explanation_text = "Have at least five buttbots on the station level at the end of the round."
			check_completion()
				var/buttbots = 0
				for(var/obj/machinery/bot/buttbot/B in machines)
					if(B.z == 1)
						buttbots ++
				if(buttbots > 4) return 1
				else return 0
		*/
		healself
			explanation_text = "Make sure you are completely unhurt when the escape shuttle leaves."
			check_completion()
				if(owner.current && owner.current.stat != 2)
					var/mob/living/carbon/C = owner.current
					if((C.bruteloss + C.oxyloss + C.fireloss + C.toxloss + C.cloneloss + C.brainloss) == 0)
						return 1
				else
					return 0

	geneticist
		scanned
			explanation_text = "Have at least 5 people's DNA scanned in the cloning console at the end of the round."
			check_completion()
				for(var/obj/machinery/computer/cloning/C in machines)
					if(C.records.len > 4)
						return 1
				return 0
				/*
		power
			explanation_text = "Save a DNA sequence with at least one superpower onto a floppy disk and ensure it reaches CentCom."
			check_completion()
				for(var/obj/item/disk/data/floppy/F in world)
					if(F.data_type == "se" && F.data && istype(get_area(F),/area/shuttle/escape/centcom)) //prerequesites
						if(isblockon(getblock(F.data,XRAYBLOCK,3),8) || isblockon(getblock(F.data,FIREBLOCK,3),10) || isblockon(getblock(F.data,HULKBLOCK,3),2) || isblockon(getblock(F.data,TELEBLOCK,3),12))
							return 1
				return 0
				*/

	chemist
		noscorch
			explanation_text = "Ensure that the floors of the chemistry lab are not scorched at the end of the round."
			check_completion()
				for(var/turf/simulated/floor/T in get_area_turfs(/area/medical/chemistry, 0))
					if(T.burnt == 1) return 0
				return 1
		hyper
			explanation_text = "Have methamphetamine in your bloodstream at the end of the round."
			check_completion()
				if(owner.current && owner.current.reagents && owner.current.reagents.has_reagent("methamphetamine"))
					return 1
				else
					return 0

	roboticist
		cyborgs
			explanation_text = "Ensure that there are at least three living cyborgs at the end of the round."
			check_completion()
				var/borgcount = 0
				for(var/mob/living/silicon/robot in world) //borgs gib when they die so no need to check stat I think
					if(!istype(robot, /mob/living/silicon/ai)) //without this, you have 2 'cyborgs' at roundstart
						borgcount ++
				if(borgcount > 2) return 1
				else return 0
		/*
		replicant
			explanation_text = "Make sure at least one replicant survives until the end of the round."
			medal_name = "Progenitor"
			check_completion()
				for(var/mob/living/silicon/robot/R in mobs)
					if(R.replicant)
						return 1
				return 0
		*/
		medibots
			explanation_text = "Have at least five medibots on the station level at the end of the round."
			check_completion()
				var/medbots = 0
				for (var/obj/machinery/bot/medbot/M in machines)
					if (M.z == 1)
						medbots++
				if (medbots > 4) return 1
				else return 0
		/* Left in for goonbutt port :^)
		buttbots
			explanation_text = "Have at least five buttbots on the station level at the end of the round."
			check_completion()
				var/buttbots = 0
				for(var/obj/machinery/bot/buttbot/B in machines)
					if(B.z == 1)
						buttbots ++
				if(buttbots > 4) return 1
				else return 0
		*/

	medicaldoctor
		healself
			explanation_text = "Make sure you are completely unhurt when the escape shuttle leaves."
			check_completion()
				if(owner.current && owner.current.stat != 2)
					var/mob/living/carbon/C = owner.current
					if((C.bruteloss + C.oxyloss + C.fireloss + C.toxloss + C.cloneloss + C.brainloss) == 0)
						return 1
				else
					return 0

	assistant
		appendix
			explanation_text = "Have your appendix removed somehow by the end of the round." //Give the doctors something to do
			check_completion()
				if(owner.current && ishuman(owner.current))
					var/mob/living/carbon/human/H = owner.current
					for(var/obj/item/organ/internal/O in H.internal_organs)
						if(istype(O,/obj/item/organ/internal/appendix))
							return 0
				return 1
		clown
			explanation_text = "Escape on the shuttle alive wearing at least one piece of clown clothing."
			check_completion()
				if(owner.current && ishuman(owner.current))
					var/mob/living/carbon/human/H = owner.current
					if(istype(H.wear_mask,/obj/item/clothing/mask/gas/clown_hat) || istype(H.w_uniform,/obj/item/clothing/under/rank/clown) || istype(H.shoes,/obj/item/clothing/shoes/clown_shoes)) return 1
				return 0
		spacesuit
			explanation_text = "Get your grubby hands on a spacesuit."
			check_completion()
				if(owner.current)
					for(var/obj/item/clothing/suit/space/S in owner.current.contents)
						return 1
				return 0
		monkey
			explanation_text = "Escape on the shuttle alive as a monkey." //Possible if you have a buddy in genetics, but too difficult?
			check_completion()
				if(owner.current && owner.current.stat != 2 && istype(get_area(owner.current),/area/shuttle/escape) && ismonkey(owner.current)) return 1
				else return 0
