RSpec.describe RestDSL do
  it 'can load configuration information from a config file if one is provided' do
    RestDSL.config_file_location = "#{__dir__}/fixtures"
    expect(RestDSL.config[:environments][:foo]).to eql(baz: :bar)
  end
end
