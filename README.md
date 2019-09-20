# RestDsl

A simple dsl for defining rest service consumers in applications.  Mostly intended for test framework use.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rest_dsl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rest_dsl

## Usage

Create a config in your project root
```yaml
# ./config/rest_dsl.yml
:environments:
  :postman_prod:
    :url: 'https://postman-echo.com'
```

Create a service class
```ruby
# some_dir/postman_echo.rb
class PostmanEcho < RestDSL::ServiceBase
  self.service_name = '' # Postman echo has no service name in its url

  rest_call(:get, :echo, 'get')
  rest_call(:post, :echo, 'post')
  rest_call(:get, :auth, 'basic-auth')
end
```
and an associated yaml file
Note: Uses symbolized keys
```yml
# some_dir/postman_echo.yml
:postman_echo_prod: # The name of my environment
  :credentials:
    :user: 'some_user_name'
    :password: 'some_password'
  :headers:
    :some_header: 'foo' 
```

Make calls to your hearts content
```ruby
PostmanEcho.environment = :postman_echo_prod
PostmanEcho.get_echo(params: {word: 'cow'})
```

All services are defined as singletons, if you truly need more than one instance for any reason, 
you can always just dup it into a new constant.  See the specs for more advanced use until I get a chance to write up
more documentation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/castone22/rest_dsl_gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RestDsl project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rest_dsl/blob/master/CODE_OF_CONDUCT.md).
