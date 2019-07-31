require 'rest_dsl/client'

describe RestDSL::Client do
  let(:config) { { environments: { postman_echo: { url: 'https://postman-echo.com'} } } }
  before { RestDSL.configuration.merge!(config) }
  context :new do
    it 'raises a UndefinedEnvironmentError when created with an unknown environment' do
      expect { RestDSL::Client.new('bloof') }.to raise_exception(RestDSL::UndefinedEnvironmentError)
    end

    it 'creates a service object if it\'s given a base url' do
      service = RestDSL::Client.new(base_url: 'https://postman-echo.com')
      expect(service).to be_a RestDSL::Client
    end

    it 'can load environment definitions from the RestDSL Config' do
      service = RestDSL::Client.new(:postman_echo)
      expect(service.environments.keys).to include(:postman_echo)
    end
  end

  context :execute do
    it 'can make get requests against a webservice' do
      service = RestDSL::Client.new(base_url: 'https://postman-echo.com')
      headers = {accept: 'application/json'}
      auth = {user: 'foo', password: 'bar'}
      result = service.execute(:get, 'get?bar=baz', headers, **auth)
      expect(result[:args][:bar]).to eq 'baz'
    end

    it 'can make post requests against a webservice' do
      service = RestDSL::Client.new(base_url: 'https://postman-echo.com')
      headers = {accept: 'application/json'}
      auth = {user: 'foo', password: 'bar'}
      payload = {body: "I've got a lovely bunch of coconuts, here they are all dancing in the rain"}
      result = service.execute(:post, 'post?bar=baz', headers, payload: payload, **auth)
      aggregate_failures('The response should contain both the body and params') do
        expect(result[:args][:bar]).to eq 'baz'
        expect(result[:json][:body]).to eq "I've got a lovely bunch of coconuts, here they are all dancing in the rain"
      end
    end


  end
end