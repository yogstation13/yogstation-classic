#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist

/proc/load_whitelist()
	var/list/whitelistkeys = file2list(WHITELISTFILE)
	whitelist = list()
	for(var/key in whitelistkeys)
		whitelist |= ckey(key)

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist || !whitelist.len)
		return 0
	return ("[M.ckey]" in whitelist)

#undef WHITELISTFILE