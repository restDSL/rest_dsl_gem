require 'rspec'
require 'rest_dsl/dsl'

describe RestDSL::DSLExtensions::FromFile do

  context :mixed_in do
    let(:json_file) { "#{__dir__}/fixtures/some_file.json" }
    let(:yaml_file) { "#{__dir__}/fixtures/rest_dsl.yml" }
    let(:img_file) { "#{__dir__}/fixtures/boi.jpg" }
    before { extend(RestDSL::DSLExtensions::FromFile) }

    it 'allows me to read json files as ruby hashes' do
      expect(from_file(json_file)).to be_a Hash
    end

    it 'allows me to read yaml files as ruby hashes' do
      expect(from_file(yaml_file)).to be_a Hash
    end

    it 'will return the file object if it has no defined parser for that file type' do
      expect(from_file(img_file)).to be_a File
    end
  end
end