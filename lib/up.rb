module Up
  module Userlib
    module Vcard
            
      def vcard
        @card ||= Proc.new do 
          tmp = {}
          vcard_fields.each {|f| tmp[f.name.to_sym] = f.value }
          @card = Struct.new('Vcard', *tmp.keys)        
          tmp.each { |k,v|  @card[k] = v }
          @card
        end
      end
      
      def add_vcard_field(k,v)
        vcard_fields.create(:name => k, :value => v)
      end
      
      def collected_vcards_owners
        collected_vcards.collect(&:owner)
      end
      
      def has_vcard_of?(some_user)
        collected_vcards_owners.include?(some_user)
      end
      
    end
 
    module Introspection
      def ongoing_journey
        self.journey ||= self.journeys.create(:status => Journey::STATUSES[:ongoing])
      end

      def current_tile
        ongoing_journey.current_tile
      end

      def current_venue
       current_presence.venue
      end

      def currently_in_venue?
        !current_presence.nil?
      end

      def in_tile?(tile_id)
        current_tile.id == tile_id.to_i
      end

      def in_journey?(journey_id)
        ongoing_journey.id == journey_id.to_i
      end

      def in_venue?(venue)
        current_presence.venue == venue
      end

      def in_same_tile_that?(user_b)
        current_tile == user_b.current_tile
      end

      def in_same_venue_that?(user_b)
        self.currently_in_venue? && user_b.currently_in_venue? && (self.current_venue == user_b.current_venue)
      end
       
      def engaged_with?(u)
        #e = Engagement.first(:conditions => ["((user_id = ? AND requester_id = ?) OR (user_id = ? AND requester_id = ?)) AND finished_at IS NOT NULL AND status = ?", self.id, u.id, u.id, self.id, Engagement::STATUSES[:active]], :order => 'created_at DESC')
        e = Engagement.first(:conditions => ["(user_id IN (?,?) AND requester_id IN (?,?)) AND finished_at IS NULL AND status = ?", self.id, u.id, u.id, self.id, Engagement::STATUSES[:active]], :order => 'created_at DESC')
        !e.nil?
      end
      
      def active_engagement_with(user)
        engagements.active.with_user(user)
      end
        
    end
    
    module Verbs
  
      def give_vcard_to(recipient)
        require_engagement_with(recipient)
        give = recipient.collected_vcards.create(:vcard_owner_id => self.id)
        return give.valid? ? true : give.errors     
      end

      def exchange_vcards_with(recipient)
        require_engagement_with(recipient)
        User.transaction do 
          give_vcard_to(recipient)
          collected_vcards.create(:vcard_owner_id => recipient.id)
        end
      end
  
      
    end
    
  end
end