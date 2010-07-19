#.merge(oauth_helper_for_client(clients(:some_consumer)).oauth_parameters)
require File.dirname(__FILE__) + '/../spec_helper'

describe PingsController, "getting a request token" do
  
  before do
    @user = User.make!
    @client = ClientApplication.make!(:user => @user)
    @access_token = OauthToken.make!(:user => @user, :client_application => @client)
  end
  
  it 'should create a ping' do
    post :index, {:format => 'xml'}.merge(oauth_helper_for_client_and_user(@client, @user).oauth_parameters)
  end

end