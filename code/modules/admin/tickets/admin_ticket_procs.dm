
/datum/admin_ticket/proc/test()
	user << "Ticket title is \"[title]\" for user \"[user]\""

/datum/admin_ticket/proc/add_log(nuser as mob, ndata as text)
	var/time = time2text(world.timeofday, "hh:mm")
	log += "[time] - <b>[nuser]</b> - [ndata]"

	var/found = 0

	for(var/M in monitors)
		M << "\"[ndata]\" added to ticket by [nuser]"
		if(M == nuser)
			found = 1

	if(nuser != user)
		nuser << "\"[ndata]\" added to your ticket by [nuser]"
	else if(!found)
		nuser << "Your reply has been noted"

/datum/admin_ticket/proc/toggle_monitor(nuser as mob)
	var/found = 0
	for(var/M in monitors)
		if(M == nuser)
			found = 1

	if(!found)
		monitors += nuser
		nuser << "You are now monitoring this ticket"
		user << "[nuser] is now monitoring your ticket"
	else
		monitors -= nuser
		nuser << "You are no longer monitoring this ticket"
		user << "[nuser] is no longer monitoring your ticket"

/datum/admin_ticket/proc/view_log(mob/nsrc as mob)
	var/reply_link = "<a href='?src=\ref[nsrc];action=reply_to_ticket;ticket=\ref[src]'>Reply</a>"
	var/refresh_link = "<a href='?src=\ref[nsrc];action=refresh_admin_ticket;ticket=\ref[src]'>Refresh</a>"

	var/html = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html>
			<head>
				<title>Ticket Log Viewer</title>
				<style type='text/css'>

				body {
					padding: 10;
					margin: 0;
					font-size: 12px;
					color: #ffffff;
					line-height: 170%;
					font-family: Verdana, Geneva, sans-serif;
				    background: #272727 url(uiBackground.png) 50% 0 repeat-x;
					overflow-x: hidden;
				}

				hr {
					background-color: #40628a;
					height: 1px;
				}

				a, a:link, a:visited, a:active, .link, .linkOn, .linkOff, .selected, .disabled {
					color: #ffffff;
					text-decoration: none;
					background: #40628a;
					border: 1px solid #161616;
					padding: 2px 2px 2px 2px;
					margin: 0 2px 2px 0;
					cursor:default;
				}

				a:hover, .linkActive:hover {
					background: #507aac;
				}

				p {
					padding: 0px;
					margin: 0px;
				}

				h1, h2, h3, h4, h5, h6 {
					margin: 0;
					padding: 16px 0 8px 0;
					color: #517087;
					clear: both;
				}

				h1 {
					font-size: 15px;
				}

				h2 {
					font-size: 14px;
				}

				h3 {
					font-size: 13px;
				}

				h4 {
					font-size: 12px;
				}

				.notice {
					background: url(uiNoticeBackground.jpg) 0 0 repeat;
					color: #15345A;
					font-size: 12px;
					font-style: italic;
					font-weight: bold;
					padding: 3px 8px 2px 8px;
					margin: 4px;
				}

				div.notice {
					clear: both;
				}

				#header {
					margin: 3px;
					padding: 0px;
				}

				.info-bar {
					margin: 4px;
					padding: 4px
				}

				.user-info-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 0px 4px 1px 15px;
					padding: 2px 2px 2px 4px;
				}

				.control-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px
				}

				.resolved-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px
				}

				.user-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px
				}

				.message-bar {
					margin: 3px;
				}

				.resolved {
					color: green;
				}

				.unresolved {
					color: red;
				}

				</style>

				<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
				<script type='text/javascript'>
					function refresh() {
						window.location.href = '?src=\ref[nsrc];action=refresh_admin_ticket;ticket=\ref[src]'
					}

					function add_message(message) {
						$('#messages').append('<p class=\"message-bar\">'+message+'</p>');
					}

					$(function() {
						$('.user-info-bar').fadeTo(1, 0.8);
						$('.info-bar').fadeTo(1, 0.8);
						$('.control-bar').fadeTo(1, 0.8);
						$('.resolved-bar').fadeTo(1, 0.8);
						$('.user-bar').fadeTo(1, 0.8);
					});
				</script>
			</head>
			<body scroll='yes'><div id='content'>
			<h1 id='header'>Admin Ticket Interface</h1>
			<!-- <p class='info-bar'>Refreshing automatically after 5 seconds</p> -->
			<br /><p class='control-bar'>[reply_link] [refresh_link]</p>
			<p class='resolved-bar [resolved ? "resolved" : "unresolved"]'>[resolved ? "Is resolved" : "Is not resolved"]</p>"}

	var/mob/M = usr.client.mob

	if(usr.client.holder)
		html += {"<div class='user-bar'>
			<p>[key_name(user, 1)]</p>"}

		html += {"<p style='margin-top: 5px;'>
				<a href='?_src_=holder;adminmoreinfo=[ref_mob]'>?</a>
				<a href='?pp=[ref_mob]'>PP</a> <a href='?vv=[ref_mob]'>VV</a>
				<a href='?sm=[ref_mob]'>SM</a> <a href='?jmp=[ref_mob]'>JMP</a>
				<a href='?src=\ref[user];action=monitor_admin_ticket;ticket=\ref[src]'>(Un)Monitor</a>
				<a href='?src=\ref[user];action=resolve_admin_ticket;ticket=\ref[src]'>(Un)Resolve</a>
			</p>
			</div>"}

		if(M)
			if(M.mind.assigned_role)
				html += "<p class='user-info-bar'>Role: [M.mind.assigned_role]</p>"
				if(M.mind.special_role)
					html += "<p class='user-info-bar'>Antagonist: [M.mind.special_role]</p>"
				else
					html += "<p class='user-info-bar'>Antagonist: No</p>"

			var/turf/T = get_turf(M)
			var/location = ""
			if(isturf(T))
				if(isarea(T.loc))
					location = "([M.loc == T ? "at " : "in [M.loc] at "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
				else
					location = "([M.loc == T ? "at " : "in [M.loc] at "] [T.x], [T.y], [T.z])"
			html += "<p class='user-info-bar'>Location: [location]</p>"

	html += "<div id='messages'>"
	for(var/line in log)
		html += "<p class='message-bar'>[line]</p>"
	html += "</div>"
	html += "<p class='control-bar'>[reply_link] [refresh_link]</p>"
	html += "<br /></div></body></html>"

	nsrc << browse(null, "window=ViewTicketLog")
	nsrc << browse(html, "window=ViewTicketLog")