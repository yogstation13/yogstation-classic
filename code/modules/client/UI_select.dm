/client/verb/select_ui()
	set name = "Select UI Style"
	set category = "Preferences"

	var/datum/browser/popup = new /datum/browser(mob, "ui_select", "UI Select", 220, 400)
	var/content = ""
	content += "<h2>Human/Monkey UI</h2>"
	for(var/carbon_ui in everyone_carbon_uis)
		content += carbon_ui == prefs.UI_style_carbon ? "<b>[carbon_ui]</b>" : "<a href='?_src_=prefs;preference=dynamic_ui;ui_domain=carbon;ui=[carbon_ui]'>[carbon_ui]</a>"
	content += "<br>Donator Exclusive:<br>"
	for(var/carbon_ui in donator_carbon_uis)
		content += (!is_donator(src) || (carbon_ui == prefs.UI_style_carbon)) ? "<b>[carbon_ui]</b>" : "<a href='?_src_=prefs;preference=dynamic_ui;ui_domain=carbon;ui=[carbon_ui]'>[carbon_ui]</a>"

	content += "<br><h2>Cyborg UI</h2>"
	for(var/borg_ui in everyone_borg_uis)
		content += borg_ui == prefs.UI_style_borg ? "<b>[borg_ui]</b>" : "<a href='?_src_=prefs;preference=dynamic_ui;ui_domain=borg;ui=[borg_ui]'>[borg_ui]</a>"
	content += "<br>Donator Exclusive:<br>"
	for(var/borg_ui in donator_borg_uis)
		content += (!is_donator(src) || (borg_ui == prefs.UI_style_borg)) ? "<b>[borg_ui]</b>" : "<a href='?_src_=prefs;preference=dynamic_ui;ui_domain=borg;ui=[borg_ui]'>[borg_ui]</a>"

	content += "<br><h2>AI UI</h2>"
	for(var/ai_ui in everyone_ai_uis)
		content += ai_ui == prefs.UI_style_ai ? "<b>[ai_ui]</b>" : "<a href='?_src_=prefs;preference=dynamic_ui;ui_domain=ai;ui=[ai_ui]'>[ai_ui]</a>"
	content += "<br>Donator Exclusive:<br>"
	for(var/ai_ui in donator_ai_uis)
		content += (!is_donator(src) || (ai_ui == prefs.UI_style_ai)) ? "<b>[ai_ui]</b>" : "<a href='?_src_=prefs;preference=dynamic_ui;ui_domain=ai;ui=[ai_ui]'>[ai_ui]</a>"

	if(!is_donator(src))
		content += "<br><br><small>You do not have access to donator exclusive UIs. If you believe this is an error, please contact an admin.</small>"
	popup.set_content(content)
	popup.open(0)
