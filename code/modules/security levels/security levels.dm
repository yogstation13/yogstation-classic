/var/security_level = 0
//0 = code green
//1 = code blue
//2 = code red
//3 = code delta
//4 = code charlie foxtrot

//previous code was sloppy.  global vars to keep track of overlays.
/var
	alertOverlayGreen	= image('icons/obj/monitors.dmi', "overlay_green")
	alertOverlayBlue	= image('icons/obj/monitors.dmi', "overlay_blue")
	alertOverlayRed		= image('icons/obj/monitors.dmi', "overlay_red")
	alertOverlayDelta	= image('icons/obj/monitors.dmi', "overlay_delta")
	alertOverlayCF		= image('icons/obj/monitors.dmi', "overlay_cf")

//config.alert_desc_blue_downto

/proc/set_security_level(var/level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("delta")
			level = SEC_LEVEL_DELTA
		if("charlie foxtrot")
			level = SEC_LEVEL_CF

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_CF && level != security_level)
		var/toStrip = null
		switch(security_level)
			if(SEC_LEVEL_GREEN)
				toStrip = alertOverlayGreen
			if(SEC_LEVEL_BLUE)
				toStrip = alertOverlayBlue
			if(SEC_LEVEL_RED)
				toStrip = alertOverlayRed
			if(SEC_LEVEL_DELTA)
				toStrip = alertOverlayDelta
			if(SEC_LEVEL_CF)
				toStrip = alertOverlayCF
		switch(level)
			if(SEC_LEVEL_GREEN)
				world << "<font size=4 color='red'>Attention! Security level lowered to green</font>"
				world << "<font color='red'>[config.alert_desc_green]</font>"
				security_level = SEC_LEVEL_GREEN
				for(var/obj/machinery/firealarm/FA in world)
					if(FA.z == 1)
						//FA.overlays = list()
						if(toStrip in FA.overlays)
							FA.overlays -= toStrip
						FA.overlays += alertOverlayGreen
			if(SEC_LEVEL_BLUE)
				if(security_level < SEC_LEVEL_BLUE)
					world << "<font size=4 color='red'>Attention! Security level elevated to blue</font>"
					world << "<font color='red'>[config.alert_desc_blue_upto]</font>"
				else
					world << "<font size=4 color='red'>Attention! Security level lowered to blue</font>"
					world << "<font color='red'>[config.alert_desc_blue_downto]</font>"
				security_level = SEC_LEVEL_BLUE
				for(var/obj/machinery/firealarm/FA in world)
					if(FA.z == 1)
						//FA.overlays = list()
						if(toStrip in FA.overlays)
							FA.overlays -= toStrip
						FA.overlays += alertOverlayBlue
			if(SEC_LEVEL_RED)
				if(security_level < SEC_LEVEL_RED)
					world << "<font size=4 color='red'>Attention! Code red!</font>"
					world << "<font color='red'>[config.alert_desc_red_upto]</font>"
				else
					world << "<font size=4 color='red'>Attention! Code red!</font>"
					world << "<font color='red'>[config.alert_desc_red_downto]</font>"
				security_level = SEC_LEVEL_RED

				/*	- At the time of commit, setting status displays didn't work properly
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications,world)
				if(CC)
					CC.post_status("alert", "redalert")*/

				for(var/obj/machinery/firealarm/FA in world)
					if(FA.z == 1)
						//FA.overlays = list()
						if(toStrip in FA.overlays)
							FA.overlays -= toStrip
						FA.overlays += alertOverlayRed
			if(SEC_LEVEL_DELTA)
				if( security_level < SEC_LEVEL_DELTA )
					world << "<font size=4 color='red'>Attention! Delta security level reached!</font>"
					world << "<font color='red'>[config.alert_desc_delta]</font>"
				else
					world << "<font size=4 color='red'>Attention! Code Charlie Foxtrot has been cleared!</font>"
					// !! comment out the following 1 line of code when [config.alert_desc_delta_downto] exists
					world << "<font color='red'>A Nanotrasen official will be by to draft new contracts with the survivors.</font>"
					// !! uncomment the following 1 line of code when [config.alert_desc_delta_downto] exists
					// world << "<font color='red'>[config.alert_desc_delta_downto]</font>"
				security_level = SEC_LEVEL_DELTA
				for(var/obj/machinery/firealarm/FA in world)
					if(FA.z == 1)
						//FA.overlays = list()
						if(toStrip in FA.overlays)
							FA.overlays -= toStrip
						FA.overlays += alertOverlayDelta
			if(SEC_LEVEL_CF)
				world << "<font size=4 color='red'>Attention! Code Charlie Foxtrot has been declared!</font>"
				// !! comment out the following 1 line of code when config.alert_desc_cf exists
				world << "<font color='red'>All contracts have been burned!</font>"
				// !! uncomment the following 1 line of code when config.alert_desc_cf exists
				// world << "<font color='red'>[config.alert_desc_cf]</font>
				security_level = SEC_LEVEL_CF
				for(var/obj/machinery/firealarm/FA in world)
					if(FA.z == 1)
						if(toStrip in FA.overlays)
							FA.overlays -= toStrip
						FA.overlays += alertOverlayCF
	else
		return

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("delta")
			return SEC_LEVEL_DELTA


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/