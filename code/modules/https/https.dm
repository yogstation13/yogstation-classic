
var/auth_key = null

/proc/renew_discord_token()
	auth_key = file2text(file("config/discord_auth.txt"))

/proc/send_discord_message(var/message, var/channel_id)
	if(!config.usediscordbot)
		return
	if(!auth_key)
		renew_discord_token()
	shell("py bot/discord.py [auth_key] [channel_id] \"[message]\"")