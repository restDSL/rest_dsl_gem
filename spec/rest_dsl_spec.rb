RSpec.describe RestDSL do
  it 'can load configuration information from a config file if one is provided' do
    RestDSL.config_file_location = "#{__dir__}/fixtures"
    expect(RestDSL.config[:environments][:my_environment]).to eql(url: 'localhost:3000/myservice/person')
  end
end
