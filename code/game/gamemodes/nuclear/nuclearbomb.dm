var/bomb_set

/obj/machinery/nuclearbomb
	name = "nuclear fission explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = 1

	var/mintime = 60
	var/timeleft = 600
	var/timing = 0.0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0.0
	var/safety = 1.0
	var/obj/item/weapon/disk/nuclear/auth = null
	use_power = 0
	var/previous_level = ""
	var/lastentered = ""
	var/lighthack = 0
	var/removal_stage = 0
	var/alarmcooldown = 0
	var/datum/wires/nuke/wires = null
	var/obj/item/device/pda/hacker = null
	var/hacktime = 330


/obj/machinery/nuclearbomb/process()
	if (src.timing)
		bomb_set = 1 //So long as there is one nuke timing, it means one nuke is armed.
		src.timeleft--
		if (src.timeleft <= 0)
			explode()
		else
			var/volume = (timeleft <= 20 ? 30 : 5)
			playsound(loc, 'sound/items/timer.ogg', volume, 0)
		for(var/mob/M in viewers(1, src))
			if ((M.client && M.machine == src))
				src.attack_hand(M)
	if (hacker)
		if (auth)
			hacktime--
			if ((hacktime % 5) == 0)
				playsound(loc, 'sound/items/timer.ogg', 5, 0)
			if ((hacktime % 60) == 0)
				hackerinform(hacktime/60)
			if (hacktime <= 0)
				hacktime = 0
				hacker = null
				updatelights()

		else
			hacktime = 330
			hackerinform(-1)
			hacker = null
			updatelights()
			set_security_level("[previous_level]")
	return

/obj/machinery/nuclearbomb/attackby(obj/item/I as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(I, /obj/item/weapon/disk/nuclear))
		usr.drop_item()
		I.loc = src
		src.auth = I
		updatelights()
		return
	if (istype(I, /obj/item/weapon/screwdriver))
		if (src.auth)
			src.panel_open = !panel_open
			if(panel_open)
				overlays += image(icon, "npanel_open")
			else
				overlays -= image(icon, "npanel_open")
			user.visible_message("<span class='warning'>[user] screws [src]'s panel [panel_open ? "open" : "closed"]!</span>",
				"<span class='notice'>You screw [src]'s panel [panel_open ? "open" : "closed"].</span>")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		else
			visible_message("<span class='warning'>[src] emits a buzzing noise, the panel staying [panel_open ? "open" : "closed"].</span>")
			if(!lighthack)
				flick("nuclearbombc", src)
		return
	if((istype(I, /obj/item/weapon/wirecutters) || istype(I, /obj/item/device/multitool) || istype(I, /obj/item/device/assembly/signaler)) && panel_open)
		wires.Interact(user)
		return
	if (src.anchored)
		switch(removal_stage)
			if(0)
				if(istype(I,/obj/item/weapon/weldingtool))
					var/obj/item/weapon/weldingtool/WT = I
					if(!WT.isOn()) return
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						user << "<span class='warning'>You need more fuel to complete this task.</span>"
						return

					user.visible_message("<span class='warning'>[user] starts cutting loose the anchoring bolt covers on [src].</span>", "<span class='notice'>You start cutting loose the anchoring bolt covers with [I]...</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(do_after(user,40))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("<span class='warning'>[user] cuts through the bolt covers on [src].</span>", "<span class='notice'>You cut through the bolt cover.</span>")
						removal_stage = 1
				return

			if(1)
				if(istype(I,/obj/item/weapon/crowbar))
					user.visible_message("<span class='warning'>[user] starts forcing open the bolt covers on [src].</span>", "<span class='notice'>You start forcing open the anchoring bolt covers with [I]...</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(do_after(user,15))
						if(!src || !user) return
						user.visible_message("<span class='warning'>[user] forces open the bolt covers on [src].</span>", "<span class='notice'>You force open the bolt covers.</span>")
						removal_stage = 2
				return

			if(2)
				if(istype(I,/obj/item/weapon/weldingtool))

					var/obj/item/weapon/weldingtool/WT = I
					if(!WT.isOn()) return
					if (WT.get_fuel() < 5) // uses up 5 fuel.
						user << "<span class='warning'>You need more fuel to complete this task.</span>"
						return

					user.visible_message("<span class='warning'>[user] starts cutting apart the anchoring system sealant on [src].</span>", "<span class='notice'>You start cutting apart the anchoring system's sealant with [I]...</span>")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(do_after(user,40))
						if(!src || !user || !WT.remove_fuel(5, user)) return
						user.visible_message("<span class='warning'>[user] cuts apart the anchoring system sealant on [src].</span>", "<span class='notice'>You cut apart the anchoring system's sealant.</span>")
						removal_stage = 3
				return

			if(3)
				if(istype(I,/obj/item/weapon/wrench))

					user.visible_message("<span class='warning'>[user] begins unwrenching the anchoring bolts on [src].</span>", "<span class='notice'>You begin unwrenching the anchoring bolts...</span>")
					playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
					if(do_after(user,50))
						if(!src || !user) return
						user.visible_message("<span class='warning'>[user] unwrenches the anchoring bolts on [src].</span>", "<span class='notice'>You unwrench the anchoring bolts.</span>")
						removal_stage = 4
				return

			if(4)
				if(istype(I,/obj/item/weapon/crowbar))

					user.visible_message("<span class='warning'>[user] begins lifting [src] off of the anchors.</span>", "<span class='notice'>You begin lifting the device off the anchors...</span>")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(do_after(user,80))
						if(!src || !user) return
						user.visible_message("<span class='warning'>[user] crowbars [src] off of the anchors. It can now be moved.</span>", "<span class='notice'>You jam the crowbar under the nuclear device and lift it off its anchors. You can now move it!</span>")
						anchored = 0
						removal_stage = 5
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				return
	if(istype(I,/obj/item/device/pda))
		if(!panel_open)
			user << "<span class='notice'>The panel needs to be open!</span>"
		var/insane = 0
		if(user.mind)
			for(var/datum/objective/objective in user.mind.objectives)
				if(istype(objective, /datum/objective/nuclear))
					insane = 1
			if(insane)
				if(hacker)
					user << "<span class='notice'>Someone is already using [src] to decrypt the nuclear code.</span>"
					return
				if(hacktime == 0)
					hacker = I
					hackerinform(0)
					hacker = null
				if(auth)
					user.visible_message("<span class='userdanger'>[user] scans the [src] with [I] and the device starts beeping erratically!</span>", "<span class='notice'>You download the encrypted codes to [I] and begin a brute-force hack. Make sure the disk stays in [src] or the hack will be interrupted!</span>")
					hacker = I
					message_admins("[key_name(user, user.mind)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) has initiated brute-forcing of the nuclear code with [I] ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>).")
					log_game("[key_name(user)] has initiated brute-forcing of the nuclear code with [I].")
					priority_announce("Unauthorised self-destruct code decryption attempt detected. The Nuclear Authentification Disk may have been compromised. The disk must be located and brought to Central Command immediately.", "Nuclear Security Breach", 'sound/misc/bloblarm.ogg')
					src.previous_level = "[get_security_level()]"
					set_security_level("delta")
					updatelights()
				else
					user << "<span class='notice'>The nuclear codes are stored on the Nuclear Authentification Disk and can only be accessed when the disk is inserted into [src].</span>"
			else
				user << "<span class='notice'>I don't think that's a good idea...</span>"
		return
	if(istype(I,/obj/item/weapon/card/emag))
		testexplosion()
	..()
	return

/obj/machinery/nuclearbomb/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/nuclearbomb/attack_ai(mob/user as mob)
	return

/obj/machinery/nuclearbomb/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(panel_open)
		wires.Interact(user)
		return
	user.set_machine(src)
	var/dat = text("<TT>\nAuth. Disk: <A href='?src=\ref[];auth=1'>[]</A><HR>", src, (src.auth ? "++++++++++" : "----------"))
	if (src.auth)
		if (src.yes_code)
			dat += text("\n<B>Status</B>: []-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] <A href='?src=\ref[];timer=1'>Toggle</A><BR>\nTime: <A href='?src=\ref[];time=-10'>-</A> <A href='?src=\ref[];time=-1'>-</A> [] <A href='?src=\ref[];time=1'>+</A> <A href='?src=\ref[];time=10'>+</A><BR>\n<BR>\nSafety: [] <A href='?src=\ref[];safety=1'>Toggle</A><BR>\nAnchor: [] <A href='?src=\ref[];anchor=1'>Toggle</A><BR>\n", (src.timing ? "Func/Set" : "Functional"), (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src, src, src, src.timeleft, src, src, (src.safety ? "On" : "Off"), src, (src.anchored ? "Engaged" : "Off"), src)
		else
			dat += text("\n<B>Status</B>: Auth. S2-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\n[] Safety: Toggle<BR>\nAnchor: [] Toggle<BR>\n", (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src.timeleft, (src.safety ? "On" : "Off"), (src.anchored ? "Engaged" : "Off"))
	else
		if (src.timing)
			dat += text("\n<B>Status</B>: Set-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\nSafety: [] Toggle<BR>\nAnchor: [] Toggle<BR>\n", (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src.timeleft, (src.safety ? "On" : "Off"), (src.anchored ? "Engaged" : "Off"))
		else
			dat += text("\n<B>Status</B>: Auth. S1-[]<BR>\n<B>Timer</B>: []<BR>\n<BR>\nTimer: [] Toggle<BR>\nTime: - - [] + +<BR>\n<BR>\nSafety: [] Toggle<BR>\nAnchor: [] Toggle<BR>\n", (src.safety ? "Safe" : "Engaged"), src.timeleft, (src.timing ? "On" : "Off"), src.timeleft, (src.safety ? "On" : "Off"), (src.anchored ? "Engaged" : "Off"))
	var/message = "AUTH"
	if (src.auth)
		message = text("[]", src.code)
		if (src.yes_code)
			message = "*****"
	dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A><A href='?src=\ref[];type=2'>2</A><A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A><A href='?src=\ref[];type=5'>5</A><A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A><A href='?src=\ref[];type=8'>8</A><A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A><A href='?src=\ref[];type=0'>0</A><A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
	var/datum/browser/popup = new(user, "nuclearbomb", name, 300, 400)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/nuclearbomb/Topic(href, href_list)
	if(..())
		return
	if (src.timing == -1.0)
		return
	usr.set_machine(src)
	if (href_list["auth"])
		if (src.auth)
			src.auth.loc = src.loc
			src.yes_code = 0
			src.auth = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/disk/nuclear))
				usr.drop_item()
				I.loc = src
				src.auth = I
	if (src.auth)
		if (href_list["type"])
			if (href_list["type"] == "E")
				if (src.code == src.r_code)
					src.yes_code = 1
					src.code = null
				else
					src.code = "ERROR"
			else
				if (href_list["type"] == "R")
					src.yes_code = 0
					src.code = null
				else
					lastentered = text("[]", href_list["type"])
					if (text2num(lastentered) == null)
						var/turf/LOC = get_turf(usr)
						message_admins("[key_name_admin(usr)] tried to exploit a nuclear bomb by entering non-numerical codes: <a href='?_src_=vars;Vars=\ref[src]'>[lastentered]</a> ! ([LOC ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])", 0)
						log_admin("EXPLOIT : [key_name(usr)] tried to exploit a nuclear bomb by entering non-numerical codes: [lastentered] !")
					else
						src.code += lastentered
						if (length(src.code) > 5)
							src.code = "ERROR"
		if (src.yes_code)
			if (href_list["time"])
				var/time = text2num(href_list["time"])
				src.timeleft += time
				src.timeleft = min(max(round(src.timeleft), mintime), mintime + 600)
			if (href_list["timer"])
				if(wires.IsIndexCut(NUKE_WIRE_TIMER))
					return
				if (src.safety)
					usr << "<span class='danger'>The safety is still on.</span>"
					return
				src.timing = !( src.timing )
				if (src.timing)
					if(!src.safety)
						bomb_set = 1//There can still be issues with this reseting when there are multiple bombs. Not a big deal tho for Nuke/N
						if(!(get_security_level() == "delta"))
							src.previous_level = "[get_security_level()]"
						if(get_security_level() != "delta")
							world << sound('sound/misc/bloblarm.ogg')
						set_security_level("delta")
					else
						bomb_set = 0
						set_security_level("[previous_level]")
				else
					bomb_set = 0
					set_security_level("[previous_level]")
			if (href_list["safety"])
				if(wires.IsIndexCut(NUKE_WIRE_SAFETY))
					return
				src.safety = !( src.safety )
				if(safety)
					src.timing = 0
					set_security_level("[previous_level]")
					bomb_set = 0
			if (href_list["anchor"])
				if(wires.IsIndexCut(NUKE_WIRE_BOLTS))
					return
				if((!isinspace()) && (removal_stage < 5))
					src.anchored = !( src.anchored )
				else
					usr << "<span class='warning'>There is nothing to anchor to!</span>"
	src.add_fingerprint(usr)
	updatelights()
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.attack_hand(M)

/obj/machinery/nuclearbomb/ex_act(severity)
	return

/obj/machinery/nuclearbomb/blob_act()
	if (src.timing == -1.0)
		return
	else
		return ..()
	return

/obj/machinery/nuclearbomb/proc/testexplosion()
	if (alarmcooldown < world.time)
		alarmcooldown = world.time + 1800 //3 minutes
		spawn(5)
			if(!lighthack)
				icon_state = "nuclearbomb3"
			playsound(src, 'sound/machines/Alarm.ogg', 100, 0, surround = 0)
			sleep(135)
			updatelights()
	else
		var/timeleft = (alarmcooldown - world.time)
		visible_message("<span class='alert'>Nothing happens and '</span>[round(timeleft/10)]<span class='alert'>' flashes on the LED display.</span>")

/obj/machinery/nuclearbomb/proc/hackerinform(var/minutes)
	if (!hacker) return
	var/message = ""
	if(minutes < 0)
		message = "Unable to access nuclear disk. Decryption aborted."
	else if (minutes == 0)
		message = "Decryption complete! The nuclear code is [r_code]."
	else
		message = "Decryption in progress... [minutes] minute[(minutes == 1) ? "" : "s"] remaining."
	if (!hacker.silent)
		playsound(hacker.loc, 'sound/machines/twobeep.ogg', 50, 1)
	for (var/mob/O in hearers(3, hacker.loc))
		O.show_message(text("\icon[hacker] *[hacker.ttone]*"))
	if( hacker.loc && ishuman(hacker.loc) )
		var/mob/living/carbon/human/H = hacker.loc
		H << "\icon[hacker] <b>Message from [hacker.owner] ([hacker.ownjob]), </b>\"[message]\" (<a href='byond://?src=\ref[hacker];choice=Message;skiprefresh=1;target=\ref[hacker]'>Reply</a>)"
		hacker.tnote += "<i><b>&larr; From <a href='byond://?src=\ref[hacker];choice=Message;target=\ref[hacker]'>[hacker.owner]</a> ([hacker.ownjob]):</b></i><br>[message]<br>"


/obj/machinery/nuclearbomb/proc/updatelights()
	if(lighthack)
		icon_state = "nuclearbomb0"
	else if(hacker)
		icon_state = "nuclearbombc"
	else if(timing)
		icon_state = "nuclearbomb2"
	else if(auth)
		icon_state = "nuclearbomb1"
	else
		icon_state = "nuclearbomb0"

#define NUKERANGE 80
/obj/machinery/nuclearbomb/proc/is_off_station()
	var/turf/bomb_location = get_turf(src)
	if( bomb_location && (bomb_location.z == 1) )
		if( (bomb_location.x < (128-NUKERANGE)) || (bomb_location.x > (128+NUKERANGE)) || (bomb_location.y < (128-NUKERANGE)) || (bomb_location.y > (128+NUKERANGE)) )
			return 1
		else
			return 0
	else if (bomb_location && (bomb_location.z > 1))
		return bomb_location.z
	else
		return 1


/obj/machinery/nuclearbomb/proc/explode()
	if (src.safety)
		src.timing = 0
		return
	src.timing = -1.0
	src.yes_code = 0
	src.safety = 1
	if (!lighthack)
		src.icon_state = "nuclearbomb3"
	for(var/mob/M in player_list)
		M << 'sound/machines/Alarm.ogg'
	if (ticker && ticker.mode)
		ticker.mode.explosion_in_progress = 1
	sleep(100)

	enter_allowed = 0

	var/off_station = is_off_station()

	if(ticker)
		if(ticker.mode && ticker.mode.name == "nuclear emergency")
			var/obj/machinery/computer/syndicate_station/syndie_location = locate(/obj/machinery/computer/syndicate_station)
			if(syndie_location)
				ticker.mode:syndies_didnt_escape = (syndie_location.z > 1 ? 0 : 1)	//muskets will make me change this, but it will do for now
			ticker.mode:nuke_off_station = off_station
		ticker.station_explosion_cinematic(off_station,null)
		if(ticker.mode)
			ticker.mode.explosion_in_progress = 0
			if(ticker.mode.name == "nuclear emergency")
				ticker.mode:nukes_left --
			else
				world << "<B>The station was destroyed by the nuclear blast!</B>"

			ticker.mode.station_was_nuked = (off_station<1)	//offstation==1 is a draw. the station becomes irradiated and needs to be evacuated.
															//kinda shit but I couldn't  get permission to do what I wanted to do.

			if(!(ticker.mode.check_finished()) && !(emergency_shuttle.location == 1))//If the mode does not deal with the nuke going off so just reboot because everyone is stuck as is
				world << "<B>Resetting in 30 seconds!</B>"

				feedback_set_details("end_error","nuke - unhandled ending")

				if(blackbox)
					blackbox.save_all_data_to_sql()
				sleep(300)
				log_game("Rebooting due to nuclear detonation")
				kick_clients_in_lobby("<span class='danger'>The round came to an end with you in the lobby.</span>", 1) //second parameter ensures only afk clients are kicked
				world.Reboot()
				return
	return


//==========DAT FUKKEN DISK===============
/obj/item/weapon/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = 1.0

/obj/item/weapon/disk/nuclear/New()
	..()
	processing_objects.Add(src)

/obj/item/weapon/disk/nuclear/process()
	var/turf/disk_loc = get_turf(src)
	if(disk_loc.z > 2)
		get(src, /mob) << "<span class='danger'>You can't help but feel that you just lost something back there...</span>"
		Destroy()

/obj/item/weapon/disk/nuclear/Destroy()
	if(blobstart.len > 0)
		var/obj/item/weapon/disk/nuclear/NEWDISK = new(pick(blobstart))
		transfer_fingerprints_to(NEWDISK)
		message_admins("[src] has been destroyed in ([x], [y] ,[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>). Moving it to ([NEWDISK.x], [NEWDISK.y], [NEWDISK.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[NEWDISK.x];Y=[NEWDISK.y];Z=[NEWDISK.z]'>JMP</a>).")
		log_game("[src] has been destroyed in ([x], [y] ,[z]). Moving it to ([NEWDISK.x], [NEWDISK.y], [NEWDISK.z]).")
		del(src) //Needed to clear all references to it
	else
		ERROR("[src] was supposed to be destroyed, but we were unable to locate a blobstart landmark to spawn a new one.")
	return 1 // Cancel destruction.
