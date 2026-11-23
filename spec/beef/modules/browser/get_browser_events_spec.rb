#
# Copyright (c) 2006-2026 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#
# Unit tests for the get_browser_events command module.
#

require_relative '../../../spec_helper'
require_relative '../../../../modules/browser/get_browser_events/module'

RSpec.describe Get_browser_events do
  let(:logger) { instance_double(BeEF::Core::Logger) }

  before do
    allow(BeEF::Core::Logger).to receive(:instance).and_return(logger)
    allow(logger).to receive(:register)
  end

  describe '#post_execute' do
    it 'saves the collected browser event summary' do
      instance = build_command_instance(
        described_class,
        'event_count' => '3',
        'event_types' => 'click:2,keys:1',
        'logger_running' => 'true',
        'cid' => '0'
      )

      results = run_post_execute(instance)

      expect(results).to include(
        'event_count' => '3',
        'event_types' => 'click:2,keys:1',
        'logger_running' => 'true'
      )
    end

    it 'registers a server-side event when events were collected' do
      instance = build_command_instance(
        described_class,
        'event_count' => '3',
        'event_types' => 'click:2,keys:1',
        'logger_running' => 'true',
        'cid' => '0'
      )

      run_post_execute(instance)

      expect(logger).to have_received(:register).with(
        'Zombie',
        'Collected 3 browser event(s): click:2,keys:1'
      )
    end

    it 'handles an empty datastore without registering an event' do
      instance = build_command_instance(described_class, 'result' => '', 'results' => '', 'cid' => '0')

      results = run_post_execute(instance)

      expect(results).to eq({})
      expect(logger).not_to have_received(:register)
    end
  end
end
