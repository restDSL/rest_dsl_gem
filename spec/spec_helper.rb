require 'bundler/setup'
require 'rest_dsl'

RSpec.configure do |config|
  config.order = :random
  config.profile_examples = 10
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.expose_dsl_globally = true
  config.warnings = false
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
end