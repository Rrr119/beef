#
# Copyright (c) 2006-2026 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
class Get_browser_events < BeEF::Core::Command
  def post_execute
    content = {}
    content['event_count'] = @datastore['event_count'] unless @datastore['event_count'].nil?
    content['event_types'] = @datastore['event_types'] unless @datastore['event_types'].nil?
    content['logger_running'] = @datastore['logger_running'] unless @datastore['logger_running'].nil?
    save content

    return if @datastore['event_count'].nil?

    begin
      BeEF::Core::Logger.instance.register(
        'Zombie',
        "Collected #{@datastore['event_count']} browser event(s): #{@datastore['event_types']}"
      )
    rescue StandardError => e
      print_error("Could not log browser events - Exception: #{e.message}")
    end
  end
end
