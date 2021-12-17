class DirectMessageBroadcastJob < ApplicationJob
  queue_as :default

    def perform(direct_message)
      Entry.where(:room_id => direct_message.room_id).update(updated_at: Time.now)
      sender_user = Customer.find(direct_message.customer_id)
      receiver_users_list = Entry.where(:room_id => direct_message.room_id).pluck(:customer_id) # DirectMessageが送信されたRoomの所属Userをリストで返却
      ActionCable.server.broadcast "room_channel_#{direct_message.room_id}", direct_message: render_direct_message(direct_message)
      ActionCable.server.broadcast "appearance_channel", sender_user: sender_user, receiver_users_list: receiver_users_list, event: "notify"
    end

    private

    def render_direct_message(direct_message)
      ApplicationController.renderer.render partial: 'public/direct_messages/direct_message', locals: { direct_message: direct_message }
    end
end
