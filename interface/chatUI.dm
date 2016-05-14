#define WRITTENIC	1
#define WRITTENOOC	2


/client
	//1 is cached IC input, 2 is cached OOC input, 3 is previous tab
	var/list/chatData[3]
	var/tabchatFlags



client/proc/initializeChatUI()
	if(holder)
		winset(src, "tabchat", "tabs = +icpane,+oocpane,+adminlogpane")
		winset(src, "adminlogoutput", "style=[url_encode(chatStyle())]")

	winset(src, "oocoutput", "style=[url_encode(chatStyle())]")
	chatData[3] = "icpane"

//so as to not refactor every call to ooc from the code, this is necessary to set up the tabs, this is what shows up in the verb list
client/verb/send_ooc()
	set name = "Send OOC"
	set category = "OOC"

	winset(src, "tabchat", "current-tab=oocpane")
	tab_changed("oocpane")

	var/msg = input("Type in your OOC message", "OOC message", )
	ooc(msg)

client/verb/cycle_tabs_right()
	set hidden = 1

	var/current_tab = winget(src, "tabchat", "current-tab")
	chatData[3] = current_tab
	switch(current_tab)
		if("icpane")
			winset(src, "tabchat", "current-tab=oocpane")
			tab_changed("oocpane")
		if("oocpane")
			if(holder)
				winset(src, "tabchat", "current-tab=adminlogpane")
				tab_changed("adminlogpane")
			else
				winset(src, "tabchat", "current-tab=icpane")
				tab_changed("icpane")
		if("adminlogpane")
			winset(src, "tabchat", "current-tab=icpane")
			tab_changed("icpane")

client/verb/cycle_tabs_left()
	set hidden = 1

	var/current_tab = winget(src, "tabchat", "current-tab")
	chatData[3] = current_tab
	switch(current_tab)
		if("icpane")
			if(holder)
				winset(src, "tabchat", "current-tab=adminlogpane")
				tab_changed("adminlogpane")
			else
				winset(src, "tabchat", "current-tab=oocpane")
				tab_changed("oocpane")
		if("oocpane")
			winset(src, "tabchat", "current-tab=icpane")
			tab_changed("icpane")
		if("adminlogpane")
			winset(src, "tabchat", "current-tab=oocpane")
			tab_changed("oocpane")

client/verb/tab_changed(var/new_tab as text)
	set hidden = 1

	var/list/fastData = chatData
	switch(new_tab)
		if("adminlogpane")
			return
		if("icpane")
			setInputPrefix(new_tab)
			fastData[2] = winget(src, "input", "text")
			if(length(fastData[1]) > 6)
				winset(src, "input", "text = [cachedInput[1]]")
			else
				winset(src, "input", "text=\"say \\\"")
		else
			setInputPrefix(new_tab)
			fastData[1] = winget(src, "input", "text")
			if(length(fastData[2]) > 6)
				winset(src, "input", "text = [cachedInput[2]]")
			else
				winset(src, "input", "text=\"ooc \\\"")

//Handles Chat button for commands
client/verb/handleSayButton()
	set hidden = 1

	setInputPrefix(winget(src, "tabchat", "current-tab"))


//Handles input verb commands
client/proc/setInputPrefix(var/current_tab)
	if(winget(src, "saybutton", "is-checked"))
		switch(current_tab)
			if("icpane")
				winset(src, "input", "command=\"!say \\\"")
			else
				winset(src, "input", "command=\"!ooc \\\"")
	else
		winset(src, "input", "command=")

client/verb/delete_line()
	set hidden = 1

	var/current_tab = winget(src, "tabchat", "current-tab")
	switch(current_tab)
		if("icpane")
			winset(src, "input", "text=\"say \\\"")
		if("oocpane")
			winset(src, "input", "text=\"ooc \\\"")



proc/chatStyle()
	return {"
body					{font-family: Verdana, sans-serif;}

h1, h2, h3, h4, h5, h6	{color: #0000ff;	font-family: Georgia, Verdana, sans-serif;}

em						{font-style: normal;	font-weight: bold;}

/*
.motd					{color: #638500;	font-family: Verdana, sans-serif;}
.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6
	{color: #638500;	text-decoration: underline;}
.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover
	{color: #638500;}
*/

.italics				{					font-style: italic;}

.prefix					{					font-weight: bold;}

.ooc					{					font-weight: bold;}
.adminobserverooc		{color: #0099cc;	font-weight: bold;}
.adminooc				{color: #700038;	font-weight: bold;}

.adminobserver			{color: #996600;	font-weight: bold;}
.admin					{color: #386aff;	font-weight: bold;}

.name					{					font-weight: bold;}

.say					{}
.deadsay				{color: #5c00e6;}
.radio					{color: #008000;}
.sciradio				{color: #993399;}
.comradio				{color: #aca82d;}
.secradio				{color: #b22222;}
.medradio				{color: #337296;}
.engradio				{color: #fb5613;}
.suppradio				{color: #a8732b;}
.servradio				{color: #6eaa2c;}
.syndradio				{color: #6d3f40;}
.centcomradio			{color: #686868;}
.aiprivradio			{color: #ff00ff;}

.yell					{					font-weight: bold;}

.alert					{color: #ff0000;}
h1.alert, h2.alert		{color: #000000;}

.emote					{					font-style: italic;}
.selecteddna			{color: #ffffff; 	background-color: #001B1B}

.attack					{color: #ff0000;}
.disarm					{color: #990000;}
.passive				{color: #660000;}

.userdanger				{color: #ff0000;	font-weight: bold; font-size: 3;}
.danger					{color: #ff0000;}
.warning				{color: #ff0000;	font-style: italic;}
.announce 				{color: #228b22;	font-weight: bold;}
.boldannounce			{color: #ff0000;	font-weight: bold;}
.rose					{color: #ff5050;}
.info					{color: #0000CC;}
.notice					{color: #000099;}
.boldnotice				{color: #000099;	font-weight: bold;}
.adminnotice			{color: #0000ff;}
.unconscious			{color: #0000ff;	font-weight: bold;}
.suicide				{color: #ff5050;	font-style: italic;}
.green					{color: #03ff39;}
.shadowling				{color: #3b2769;}

.cyberman				{color: #066600; font-family: "Courier New", cursive, sans-serif; font-weight: bold; font-size: 2;}
.cybermancollective		{color: #066600; font-family: "Courier New", cursive, sans-serif; font-weight: bold; font-size: 4;}

.newscaster				{color: #800000;}
.ghostalert				{color: #5c00e6;	font-style: italic; font-weight: bold;}

.alien					{color: #543354;}
.noticealien			{color: #00c000;}
.alertalien				{color: #00c000;	font-weight: bold;}
.borer            {color: #804000;}

.interface				{color: #330033;}

.sans					{font-family: "Comic Sans MS", cursive, sans-serif;}
.robot					{font-family: "Courier New", cursive, sans-serif;}

.big					{font-size: 3;}
.reallybig				{font-size: 4;}
.greentext				{color: #00FF00;	font-size: 3;}
.redtext				{color: #FF0000;	font-size: 3;}

BIG IMG.icon 			{width: 32px; height: 32px;}

.memo					{color: #638500;	text-align: center;}
.memoedit				{text-align: center;	font-size: 2;}

.ticket-status {
	color: #000099;
	font-weight: bold;
}

.ticket-text-sent {
	color: #000099;
	font-weight: bold;
}

.ticket-text-received {
	color: #ff0000;
	font-weight: bold;
}

.ticket-text-monitored {
	color: #ff00ff;
	font-weight: bold;
}

.ticket-header-recieved {
	color: #ff0000;
	font-weight: bold;
	font-size: 15px;
}

.ticket-admin-reply {
	color: #ff0000;
	font-weight: bold;
	font-style: italic;
}

"}
