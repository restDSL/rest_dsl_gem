require 'rspec'
require 'rest_dsl/dsl'

describe RestDSL::DSLExtensions::FromFile do

  context :mixed_in do
    let(:json_file) { "#{__dir__}/fixtures/some_file.json" }
    let(:yaml_file) { "#{__dir__}/fixtures/rest_dsl.yml" }
    before { extend(RestDSL::DSLExtensions::FromFile) }

    it 'allows me to read json files as ruby hashes' do
      expect(from_file(json_file)).to be_a Hash
    end

    it 'allows me to read yaml files as ruby hashes' do
      expect(from_file(yaml_file)).to be_a Hash
    end
  end
end