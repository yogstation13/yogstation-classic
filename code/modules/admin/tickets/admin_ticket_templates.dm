
/proc/get_html(title as text, js as text, css as text, content as text)
	var/html = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html>
			<head>
				<title>Ticket Log Viewer</title>
				<link rel='stylesheet' type='text/css' href='icons.css'>
				<link rel='stylesheet' type='text/css' href='shared.css'>
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
					margin: 2px 2px 2px 2px;
					cursor:default;
					display: inline-block;
				}

				a:hover, .linkActive:hover {
					background: #507aac;
				}

				img {
					border: 0px;
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

				.unclaimed {
					color: #f00;
				}

				.monitor {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 2px;
					padding: 2px
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
					padding: 4px;
				}

				.emboldened {
					font-weight: bold;
				}

				.user-info-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 0px 4px 1px 15px;
					padding: 2px 2px 2px 4px;
				}

				.title-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px;
					text-align: center;
					font-size: 15px;
					font-weight: bold;
				}

				.control-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px;
				}

				.resolved-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px;
				}

				.user-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px;
				}

				.ticket-bar {
					background-color: #202020;
					border: solid 1px #404040;
					margin: 4px;
					padding: 4px;
				}

				.large-font {
					font-size: 18px;
				}

				.medium-font {
					font-size: 15px;
				}

				.normal-font {
					font-size: 12px;
				}

				.small-font {
					font-size: 10px;
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

				.admin {
					color: blue;
				}

				#monitors {
					margin: 2px 4px 2px 4px;
					padding: 4px;
				}

				.shown {
					display: block;
				}

				.hidden {
					display: none;
				}

				[css]
				</style>

				<script src="libraries.min.js"></script>
				<script type='text/javascript'>
					function add_message(message) {
						$('#messages').prepend('<p class=\"message-bar\" style=\"display: none;\">'+message+'</p>');

						$('.message-bar').fadeIn();
					}

					function handling_user(user) {
						$('#primary-admin').html(user);
					}

					function set_monitors(monitors) {
						if(!monitors || monitors.length <= 3) {
							$('#monitors').fadeOut();
						} else {
							$('#monitors').fadeIn();
						}

						$('#monitors').html(monitors);
					}

					function set_resolved(resolved) {
						$('#resolved').removeClass('resolved');
						$('#resolved').removeClass('unresolved');

						if(resolved == 1) {
							$('#resolved').addClass('resolved');
							$('#resolved').html('Is resolved');
						} else {
							$('#resolved').addClass('unresolved');
							$('#resolved').html('Is not resolved');
						}
					}

					$(function() {
						$('.user-info-bar').fadeTo(1, 0.8);
						$('.info-bar').fadeTo(1, 0.8);
						$('.control-bar').fadeTo(1, 0.8);
						$('.resolved-bar').fadeTo(1, 0.8);
						$('.user-bar').fadeTo(1, 0.8);
						$('.ticket-bar').fadeTo(1, 0.8);
					});

					[js]
				</script>
			</head>
			<body scroll='yes'><div id='content'>
			<h1 id='header'>[title]</h1>
			<br />
			[content]
			</div></body></html>"}
	return html;

