$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "fileutils"
require "timeout"
require "tmpdir"
require "watch"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |expectations| expectations.syntax = :expect }
end
