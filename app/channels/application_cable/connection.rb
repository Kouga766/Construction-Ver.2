module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_customer

    def connect
      self.current_customer = find_verified_customer
      puts find_verified_customer
    end

    protected
    def find_verified_customer
      if verified_user = env['warden'].user(scope: :customer)
        puts "verified!"
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end