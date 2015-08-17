require 'efo_nelfo'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'
require 'awesome_print'

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

# helper method that returns full path to csv files
def csv(filename)
  File.expand_path("../samples/#{filename}", __FILE__)
end

# Add 'its' to minitest - copied from https://github.com/agileanimal/its-minitest (gem doesn't work)
class MiniTest::Spec
  def self.its attribute, &block
    describe "verify subject.#{attribute} for"  do
      let(:inner_subject) { subject.send(attribute) }

      it "verify subject.#{attribute} for" do
        inner_subject.instance_eval &block
      end
    end
  end
end
