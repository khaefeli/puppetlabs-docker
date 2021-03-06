#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def node_update(availability, role, nodeid)
  cmd_string = 'docker node update'
  cmd_string += " --availability #{availability}" unless availability.nil?
  cmd_string += " --role #{role}" unless role.nil?
  cmd_string += " #{nodeid}" unless nodeid.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
availability = params['availability']
role = params['role']
nodeid = params['nodeid']

begin
  result = node_update(availability, role, nodeid)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
