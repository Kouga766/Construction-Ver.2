class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance_channel"
  end

  def unsubscribed
    current_customer.away
  end

  def appear()
    current_customer.appear
  end

  def away()
    
  end
end