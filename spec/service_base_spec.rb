require 'rspec'
require 'rest_dsl/service_base'

class PostManEcho < RestDSL::ServiceBase
  self.service_name = '' # Postman echo has no service name in its url

  rest_call(:get, :echo, 'get')
  rest_call(:post, :echo, 'post')
  rest_call(:get, :auth, 'basic-auth')
  rest_call(:get, :path_params, 'get/:person/:id')
end

describe RestDSL::ServiceBase do

  let(:config) { { environments: { postman_echo: { url: 'https://postman-echo.com'} } } }
  before do
    RestDSL.configuration.merge!(config)
    PostManEcho.environment = :postman_echo
    PostManEcho.config_file = __FILE__.gsub('.rb', '.yml')
    PostManEcho.headers = nil
    PostManEcho.authentication = nil
  end

  context :inheritance do
    it 'stores the file name of the class the it was inherited from' do
      expect(PostManEcho.file_name).to eql __FILE__
    end

    it 'determines what the name of the config file should be for the service' do
      expect(PostManEcho.config_file).to eql __FILE__.gsub('.rb', '.yml')
    end
  end

  context 'headers' do
    it 'allows me to set the headers on a service by setting `self.headers =`' do
      PostManEcho.headers = {from_the_foo: 'to the bar'}
      result = PostManEcho.get_echo
      expect(result[:headers][:"from-the-foo"]).to eql('to the bar')
    end
  end

  # This usually defaults to a yaml file with the same name as the current file, residing in the same directory.
  context 'using a config file' do
    before do
      PostManEcho.config_file = "#{__dir__}/fixtures/postman_echo.yml"
    end
    it 'will load headers from the config' do
      result = PostManEcho.get_echo
      puts result.inspect if result[:headers][:header1] != "i'm a header i'm a header, i'm a header"
      expect(result[:headers][:header1]).to eql("i'm a header i'm a header, i'm a header")
    end

    it 'will load auth from the config file' do
      PostManEcho.get_auth
      expect(PostManEcho.last_response.code).to eql(200)
    end
  end

  context 'can authorize with' do
    it 'basic auth' do
      PostManEcho.authentication = {user: 'postman', password: 'password'}
      PostManEcho.get_auth
      expect(PostManEcho.last_response.code).to eql(200)
    end

    it 'token auth' do
      PostManEcho.headers = {Authorization: 'Bearer foobarbazqux1411=1/'}
      result = PostManEcho.get_echo
      expect(result[:headers][:authorization]).to eql('Bearer foobarbazqux1411=1/')
    end
  end

  context 'setting the environment' do
    it 'creates a client for a defined environment when I set its environment' do
      expect(PostManEcho.environment).to be :postman_echo
    end

    it 'will set the url for that client' do
      expect(PostManEcho.client.base_url).to eql config[:environments][:postman_echo][:url]
    end
  end

  context 'defining rest calls' do
    it 'allows me to define a get call' do
      result = PostManEcho.get_echo(params: {foo: 'bar'})
      expect(result[:args][:foo]).to eql 'bar'
    end

    it 'allows complex url args to be defined by using symbol substitution' do
      args = {id: '1', person: 'robert'}
      # TODO Gross v
      stub_const('RestClient::Request',
                 req_class =
                   class_double('RestClient::Request',
                                new: (request = instance_double('RestClient::Request', execute: instance_double('RestClient::Response', to_json: '', code: 200, body: ''))
                                )
                   )
      )
      # TODO Gross ^
      expect(req_class).to receive(:new).with({:method=>:get, :url=>"https://postman-echo.com/get/robert/1", :headers=>{}})
      expect(request).to receive(:execute)
      PostManEcho.get_path_params(url_args: args)
    end

    it 'can pass a payload to methods that use one' do
      headers = {content_type: 'application/json'}
      payload = {foo: 'bar', baz: 'qux'}
      result = PostManEcho.post_echo(headers: headers, payload: payload)
      expect(result[:json]).to match payload
    end

    it 'can also pass form data to methods that use it' do
      headers = {content_type: 'multipart/form-data'}
      payload = { 'foo': 'bar', 'baz': 'qux', multipart: true }
      result = PostManEcho.post_echo(headers: headers, form_data: payload)
      expect(result[:form]).to match payload
    end

    it 'can take a generic text body' do
      headers = {content_type: 'application/xml'}
      payload = "<customer>\n\t<first_name>Robert</first_name>\n\t<last_name>Riley</last_name>\n</customer>"
      result = PostManEcho.post_echo(headers: headers, text: payload)
      expect(result[:data]).to match payload
    end
  end

end