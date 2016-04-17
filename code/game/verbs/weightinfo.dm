/client/verb/weightstats()
	set name = "Antag Weight Stats"
	set category = "OOC"
	set desc = "Shows information about your current antagonist weight."

	if(dbcon.IsConnected())
		var/ckey_listed = list()
		for (var/mob/new_player/player in player_list)
			ckey_listed += get_ckey(player.mind)

		var/ckey_for_sql = list2string(ckey_listed, "', '")

		var/DBQuery/q = dbcon.NewQuery("SELECT `antag_weight` FROM [format_table_name("player")] WHERE `ckey`='[key]'")
		var/DBQuery/q_total = dbcon.NewQuery("SELECT `antag_weight` FROM [format_table_name("player")] WHERE `ckey` IN ('[ckey_for_sql]')")
		if(!q.Execute())
			src << "An error occured, try again later."
			return
		var/weight = text2num(q.item[1])
		src << "Your current antagonist weight is [max(min(weight,400),25)]/400."

		if(!q_total.Execute())
			src << "Could not fetch statistics."
			return

		var/total = 0
		while(q_total.NextRow())
			total += text2num(q_total.item[1])

		src << "You account for [(weight/total)*100]% of the antagonist weight on the server right now."
		src << "You will likely be an antagonist within the next [round(100/((weight/total)*560))] rounds." //5.6 being the average number of antagonists in a round
		//as determined by about 5 seconds of shitty math on a napkin
	else
		src << "No database connection detected!"
