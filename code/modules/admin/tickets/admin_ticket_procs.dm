
/datum/admin_ticket/proc/test()
	user << "Ticket title is \"[title]\" for user \"[user]\""

/datum/admin_ticket/proc/add_log(nuser as mob, ndata as text)
	var/time = time2text(world.timeofday, "hh:mm")
	log += "[time] - [key_name(nuser, 1)] - [ndata]"

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
	else
		monitors -= nuser
		nuser << "You are no longer monitoring this ticket"

/datum/admin_ticket/proc/view_log(nsrc as mob)
	var/reply_link = "<a href='?src=\ref[nsrc];action=reply_to_ticket;ticket=\ref[src]'>Reply</a>"
	var/refresh_link = "<a href='?src=\ref[nsrc];action=refresh_admin_ticket;ticket=\ref[src]'>Refresh</a>"

	var/html = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html>
			<head>
				<title>Ticket Log Viewer</title>
				<style type=\"text/css\">
				</style>
				<script type='text/javascript'>
					function refresh() {
						window.location.href = '?src=\ref[nsrc];action=refresh_admin_ticket;ticket=\ref[src]'
					}

					/*setTimeout(function() { refresh(); }, 5000); */
				</script>
			</head>
			<body scroll=yes><div id=\"content\">
			<!-- <p style='margin: 8px;'>Refreshing automatically after 5 seconds</p> -->
			<p style='margin: 8px;'>[reply_link] - [refresh_link]</p>
			<p style='margin: 8px; color: [resolved ? "green" : "red"];'>[resolved ? "Is resolved" : "Is not resolved"]</p>"}
	for(var/line in log)
		html += "<p style='margin: 3px;'>[line]</p>"
	html += "<p style='margin: 8px;'>[reply_link] - [refresh_link]</p>"
	html += "</div></body></html>"

	nsrc << browse(null, "window=ViewTicketLog;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
	nsrc << browse(html, "window=ViewTicketLog;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1")