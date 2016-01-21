//print an error message to world.log
#define ERROR(MSG) error("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
/proc/error(msg)
	world.log << "## ERROR: [msg]"

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
/proc/warning(msg)
	world.log << "## WARNING: [msg]"

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	world.log << "## NOTICE: [msg]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
#ifdef TESTING
	world.log << "## TESTING: [msg]"
#endif

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		admindiary << "#[yog_round_number]# \[[time_stamp()]]ADMIN: [text]"

/proc/log_game(text)
	if (config.log_game)
		diary << "#[yog_round_number]# \[[time_stamp()]]GAME: [text]"

/proc/log_vote(text)
	if (config.log_vote)
		diary << "#[yog_round_number]# \[[time_stamp()]]VOTE: [text]"

/proc/log_access(text)
	if (config.log_access)
		diary << "#[yog_round_number]# \[[time_stamp()]]ACCESS: [text]"

/proc/log_say(text)
	if (config.log_say)
		diary << "#[yog_round_number]# \[[time_stamp()]]SAY: [text]"

/proc/log_prayer(text)
	if (config.log_prayer)
		diary << "#[yog_round_number]# \[[time_stamp()]]PRAY: [text]"

/proc/log_law(text)
	if (config.log_law)
		diary << "#[yog_round_number]# \[[time_stamp()]]LAW: [text]"

/proc/log_ooc(text)
	if (config.log_ooc)
		diary << "#[yog_round_number]# \[[time_stamp()]]OOC: [text]"

/proc/log_whisper(text)
	if (config.log_whisper)
		diary << "#[yog_round_number]# \[[time_stamp()]]WHISPER: [text]"

/proc/log_emote(text)
	if (config.log_emote)
		diary << "#[yog_round_number]# \[[time_stamp()]]EMOTE: [text]"

/proc/log_attack(text)
	if (config.log_attack)
		diaryofmeanpeople << "#[yog_round_number]# \[[time_stamp()]]ATTACK: [text]"

/proc/log_adminsay(text)
	if (config.log_adminchat)
		admindiary << "#[yog_round_number]# \[[time_stamp()]]ADMINSAY: [text]"

/proc/log_pda(text)
	if (config.log_pda)
		diary << "#[yog_round_number]# \[[time_stamp()]]PDA: [text]"

/proc/log_chat(text)
	if (config.log_pda) //reusing this for now, can change if needed
		diary << "#[yog_round_number]# \[[time_stamp()]]CHAT: [text]"

/proc/log_comment(text)
	if (config.log_pda)
		//reusing the PDA option because I really don't think news comments are worth a config option
		diary << "#[yog_round_number]# \[[time_stamp()]]COMMENT: [text]"

