// Wires for airlocks

/datum/wires/nuke
	holder_type = /obj/machinery/nuclearbomb
	wire_count = 7
	random = 0

var/const/NUKE_WIRE_TIMER = 1
var/const/NUKE_WIRE_SAFETY = 2
var/const/NUKE_WIRE_LIGHTS = 4
var/const/NUKE_WIRE_BOLTS = 8
var/const/NUKE_WIRE_ALARM = 16
var/const/NUKE_WIRE_NOTHING1 = 32
var/const/NUKE_WIRE_NOTHING2 = 64

/datum/wires/nuke/CanUse(var/mob/living/L)
	var/obj/machinery/nuclearbomb/A = holder
	if(A.panel_open)
		return 1
	return 0

/datum/wires/nuke/GetInteractWindow()
	var/obj/machinery/nuclearbomb/A = holder
	. += ..()
	. += text("<br>\n A small LED display shows [].<br>\n[]<br>\n[]<br>\n[]<br>\n[]", A.timeleft, (A.timing ? "The device is shaking!" : "The device is still."),
		(A.safety ? "The device is quiet." : "The device is whirring!"), (A.lighthack ? "The lights are disabled." : "The lights are functional."),
		(A.anchored ? "The bolts are extended." : "The bolts are retracted."))

/datum/wires/nuke/UpdateCut(var/index, var/mended)

	var/obj/machinery/nuclearbomb/A = holder
	switch(index)
		if(NUKE_WIRE_TIMER)
			if(!mended)
				if(A.timing == 1)
					A.timing = 0
					set_security_level("[A.previous_level]")
					A.updatelights()
		if(NUKE_WIRE_SAFETY)
			if(!mended)
				if(A.timing == 1)
					A.explode()
				else if (A.timing == 0)
					A.safety = 1
		if(NUKE_WIRE_LIGHTS)
			if(!mended)
				A.lighthack = 1
			else
				A.lighthack = 0
			A.updatelights()

/datum/wires/nuke/UpdatePulsed(var/index)

	var/obj/machinery/nuclearbomb/A = holder
	if(IsIndexCut(index))
		return
	switch(index)
		if(NUKE_WIRE_TIMER)
			if(A.timing == 1)
				A.timeleft -= 5
				A.visible_message("\icon[A] *beep*", "\icon[A] *beep*")
		if(NUKE_WIRE_SAFETY)
			if(A.timing == 1)
				A.visible_message("\icon[A] *beep*", "\icon[A] *beep*")
		if(NUKE_WIRE_LIGHTS)
			flick("nuclearbombc", A)
			A.visible_message("\icon[A] *beep*", "\icon[A] *beep*")
		if(NUKE_WIRE_BOLTS)
			if(!(A.isinspace()) && (A.removal_stage < 5))
				A.anchored = !( A.anchored )
		if(NUKE_WIRE_ALARM)
			A.testexplosion()
