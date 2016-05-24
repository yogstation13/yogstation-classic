
/proc/log_yogstat_data(var/url)
	if(!config.yogstats_key)
		return
	if(!config.use_yogstats)
		return

	spawn(-1) world.Export("[config.yogstats_url]/[url]&key=[config.yogstats_key]")