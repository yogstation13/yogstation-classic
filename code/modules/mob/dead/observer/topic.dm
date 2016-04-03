/mob/dead/observer/Topic(href, href_list, hsrc)
	if("search_mob" in href_list)
		var/name = href_list["target_name"]
		var/ref = locate(href_list["target_ref"])

		if(!name || !ref)
			return

		ManualFollow(ref)
	..()