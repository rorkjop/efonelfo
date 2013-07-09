require 'efo_nelfo'

require 'turn/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'awesome_print'

Turn.config do |c|
  c.format = :progress
  c.natural = true
  c.loadpath = %w(lib spec)
end

# helper method that returns full path to csv files
def csv(filename)
  File.expand_path("../samples/#{filename}", __FILE__)
end
