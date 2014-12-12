/mob/living/silicon/robot/examine(mob/user)
	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"
	var/obj/act_module = get_active_hand()
	if(act_module)
		msg += "It is holding \icon[act_module] \a [act_module].\n"
	msg += "<span class='warning'>"
	if (src.getBruteLoss())
		if (src.getBruteLoss() < 60)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
	if (src.getFireLoss())
		if (src.getFireLoss() < 60)
			msg += "It looks slightly charred.\n"
		else
			msg += "<B>It looks severely burnt and heat-warped!</B>\n"
	if (src.health < -50)
		msg += "It looks barely operational.\n"
	if (src.fire_stacks < 0)
		msg += "It's covered in water.\n"
	if (src.fire_stacks > 0)
		msg += "It's coated in something flammable.\n"
	msg += "</span>"

	if(opened)
		msg += "<span class='warning'>Its cover is open and the power cell is [cell ? "installed" : "missing"].</span>\n"
	else
		msg += "Its cover is closed[locked ? "" : ", and looks unlocked"].\n"

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	msg += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responding.</span>\n"
		if(DEAD)
			var/braindead = 0
			var/BDD
			if(mind == null)
				braindead = 1
			if(!key)
				var/foundghost = 0
				if(mind)
					for(var/mob/dead/observer/G in player_list)
						if(G.mind == mind)
							foundghost = 1
							if (G.can_reenter_corpse == 0)
								foundghost = 0
							break
				if(!foundghost)
					braindead = 1
			if(braindead == 1)
				BDD += "you see a red still light on its interface"
			else
				BDD += "you see a green flashing light on its interface"
			msg += "<span class='deadsay'>It looks like its system is corrupted, [BDD].</span>\n"
	msg += "*---------*</span>"

	user << msg
