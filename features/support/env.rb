require 'simplecov'
SimpleCov.start

require_relative 'cyberdojo_scenario'

World do
  CyberDojo::Scenario.new
end

