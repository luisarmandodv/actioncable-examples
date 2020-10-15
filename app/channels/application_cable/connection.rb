#*DTA Here!
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    #identified_by :current_user #*DTA Disable this stuff so integration_cable will work without an authenticated user. May screw up the other cables.

    def connect
      #self.current_user = find_verified_user
      #logger.add_tags 'ActionCable', current_user.name
    end

    protected
      def find_verified_user
        if verified_user = User.find_by(id: cookies.signed[:user_id])
          verified_user
        else
          #reject_unauthorized_connection
        end
      end
  end
end
