/obj/machinery/autolathe/parts
	name = "partlathe"
	desc = "It produces stock parts using metal and glass."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "partlathe"
	display_name = "Partlathe"
	build_type_flag = PARTLATHE

	categories = list("Stock Parts", "Eject Materials")

	var/obj/machinery/computer/rdconsole/partlathe/console//SUPER SECRET HACKEY CODE

/obj/machinery/autolathe/parts/New()
	..()
	console = new /obj/machinery/computer/rdconsole/partlathe()
	console.lathe = src
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/partlathe(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	RefreshParts()

	wires = new(src)
	files = console.files

/obj/machinery/autolathe/parts/settings_win(mob/user)
	var/dat = "<A href='?src=\ref[src];menu=[AUTOLATHE_MAIN_MENU]'>Main Menu</A><div class='statusDisplay'>"
	dat += "<h3>R&D Console Setting:</h3><BR>"
	if(console.sync)
		dat += "<A href='?src=\ref[src];sync=1'>Sync Database with Network</A><BR>"
		dat += "<span class='linkOn'>Connect to Research Network</span><BR>"
		dat += "<A href='?src=\ref[src];togglesync=1'>Disconnect from Research Network</A><BR>"
	else
		dat += "<span class='linkOff'>Sync Database with Network</span><BR>"
		dat += "<A href='?src=\ref[src];togglesync=1'>Connect to Research Network</A><BR>"
		dat += "<span class='linkOn'>Disconnect from Research Network</span><BR>"
	dat += "<A href='?src=\ref[src];reset=1'>Reset R&D Database</A></div>"
	return dat

/obj/machinery/autolathe/parts/syncing_win(mob/user)
	var/dat = "<div class='statusDisplay'>Updating Database....</div>"
	return dat


/obj/machinery/autolathe/parts/get_additional_menu_items()
	var/dat = "<br></tr><tr><td><A href='?src=\ref[src];menu=[AUTOLATHE_SETTINGS_MENU]'>Settings</A></td>"
	return dat

/obj/machinery/autolathe/parts/Topic(href, href_list)
	if(href_list["make"])
		being_built = files.FindDesignByID(href_list["make"]) //check if it's a valid design
		if(!being_built || !(being_built.build_type & PARTLATHE))
			return

	if(..())
		return

	if(href_list["sync"])
		console.sync()

	else if(href_list["togglesync"])
		console.sync = !console.sync
		updateUsrDialog()

	else if(href_list["reset"])
		console.reset()

/obj/machinery/autolathe/parts/adjust_hacked(hack)
	return