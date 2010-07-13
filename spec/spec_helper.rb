# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require File.expand_path(File.dirname(__FILE__) + "/blueprints")

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  
  config.before(:each) { Machinist.reset_before_test }
  
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses its own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end


include OAuth::Helper

# Functional test helpers
def oauth_helper_for_client(client)
  # gonna do everything but actually create a sig, cause its a pain
  OAuth::Signature::HMAC::SHA1.any_instance.stubs(:==).returns(true)
  OAuth::Client::Helper.new(@request, {:consumer => client})
end

def oauth_helper_for_client_and_user(client, user)
  token = AccessToken.find_or_create_by_user_id_and_client_id(user.id, client.id)
  OAuth::Signature::HMAC::SHA1.any_instance.stubs(:==).returns(true)
  OAuth::Client::Helper.new(@request, {:consumer => client, :token => token})
end

# Integration test helper
def oauth_header_for_method_uri_client_user_and_params(method, uri, client, user, params={})
  token = AccessToken.find_or_create_by_user_id_and_client_id(user.id, client.id)
  request = OAuth::RequestProxy.proxy(
     "method"       => method,
     "uri"               => uri,
     "parameters" => {
       "oauth_consumer_key"       => client.key,
       "oauth_token"                     => token.token,
       "oauth_signature_method" => "HMAC-SHA1",
       "oauth_timestamp"             => generate_timestamp,
       "oauth_nonce"                    => generate_nonce,
       "oauth_version"                  => '1.0'
     }.merge(params).reject { |k,v| v.to_s == "" }
  )

  signature = OAuth::Signature.sign request,
    :consumer_secret => client.secret,
    :token_secret       => token.secret

  request.parameters["oauth_signature"] = signature
  request.oauth_header
end