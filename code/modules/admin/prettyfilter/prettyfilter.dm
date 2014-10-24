
/var/list/pretty_filter_items = list()

/proc/setup_pretty_filter(var/path = "config/pretty_filter.txt")
	var/list/filter_lines = file2list(path)

	for(var/line in filter_lines)
		if(!length(line))
			continue

		if(findtextEx(line,"#",1,2))
			continue

		//Split the line at every "="
		var/list/parts = text2list(line, "=")
		if(!parts.len)
			continue

		//pattern is before the first "="
		var/pattern = parts[1]
		if(!pattern)
			continue

		//replacement follows the first "="
		var/replacement = ""
		if(parts.len >= 2)
			replacement = parts[2]

		if(!replacement)
			continue

		pretty_filter_items.Add(line)

/client/proc/list_pretty_filters()
	set category = "Admin"
	set name = "Pretty Filters List"

	usr << "--- Pretty filters list"
	for(var/line in pretty_filter_items)
		var/list/parts = text2list(line, "=")
		var/pattern = parts[1]
		var/replacement = parts[2]

		usr << "[pattern] -> [replacement]"
	usr << "--- End of list"

/client/proc/test_pretty_filters(msg as text)
	set category = "Admin"
	set name = "Pretty Filters Test"

	usr << "\"[msg]\" becomes: \"[pretty_filter(msg)]\""

//Filter out and replace unwanted words, prettify sentences
/proc/pretty_filter(var/text)
	for(var/line in pretty_filter_items)
		var/list/parts = text2list(line, "=")
		var/pattern = parts[1]
		var/replacement = parts[2]

		var/regex/R = new("/\\b[pattern]\\b/[replacement]/")
		var/newtxt = R.Replace(text)
		while(newtxt)
			text = newtxt
			newtxt = R.ReplaceNext(text)

	return text