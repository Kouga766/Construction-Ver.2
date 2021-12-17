class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:room]}"
  end
  
  #切断されたとき
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    DirectMessage.create! content: data['direct_message'], customer_id: current_customer.id, room_id: params['room']
  end
  
end