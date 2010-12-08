require File.dirname(__FILE__) + '/../spec_helper'


describe User, 'exchanging vcards' do
  
  before do
    
    stub.instance_of(User).notify { true }    
    
    @foo = User.make!
    @ping = Ping.make!(:user => @foo)
    @vcard = VcardField.make!(:user => @foo)
    
    @bar = User.make!
    @ping2 = Ping.make!(:user => @bar, :lat => @ping.lat, :lon => @ping.lon)
    @vcard2 = VcardField.make!(:user => @bar)
    
  end
  
  context 'Not engaged users' do
  
    it 'should require engagement' do
      lambda { @foo.give_vcard_to(@bar) }.should raise_error(Exceptions::NotEngaged)
    end
    
  end
  
  context 'Engaged users' do
  
    before(:each) do
      Engagement.make!(:user => @foo, :requester => @bar)
    end
    
    it 'should be able to give vcard to other users' do
      @foo.give_vcard_to(@bar)
    
      @foo.has_vcard_of?(@bar).should be_false
      @bar.has_vcard_of?(@foo).should be_true
    end
    
  
    it 'should be able to exchange vcard with other user' do
      @foo.exchange_vcards_with(@bar)
    
      @foo.has_vcard_of?(@bar).should be_true
      @bar.has_vcard_of?(@foo).should be_true
    end
  

  end
  
  
end


describe User, 'talking' do

  before(:each) do

    stub.instance_of(User).notify { true }    

    @foo = User.make!
    @ping = Ping.make!(:user => @foo)

    @bar = User.make!
    @ping2 = Ping.make!(:user => @bar, :lat => @ping.lat, :lon => @ping.lon)


  context 'Not engaged users' do

    it 'should require engagement' do
      lambda { @foo.say(@bar, 'foo') }.should raise_error(Exceptions::NotEngaged)
    end
    

  end  

  context 'Engaged users' do

     before(:each) do
       Engagement.make!(:user => @foo, :requester => @bar)
     end

     it 'should transmit talked words' do
        @foo.say(@bar, 'foo')
        assert @bar.heard_words.first.content == 'foo'
     end  
   
   
     it 'dialogues not monologues' do
       @bar.say(@foo, 'foo')
       assert @foo.heard_words.first.content == 'foo'
     end
 
   end

  end


end
