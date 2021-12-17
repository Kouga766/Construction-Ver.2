class Public::RoomsController < ApplicationController
    
    def index
        @customer = current_customer
        @currentEntries = current_customer.entries
        #@currentEntriesのルームを配列にする
        myRoomIds = []
        @currentEntries.each do |entry|
          myRoomIds << entry.room.id
        end
        #@currentEntriesのルーム且つcurrent_customerでないEntryを新着順で取ってくる
        @anotherEntries = Entry.where(room_id: myRoomIds).where.not(customer_id: @customer.id).order(updated_at: :desc)
    end
    
    def show
        @room = Room.find(params[:id])
        #ルームが作成されているかどうか
        if Entry.where(:customer_id => current_customer.id, :room_id => @room.id).present?
          puts "ルームに入るよ"
          @direct_messages = @room.direct_messages
          @entries = @room.entries
          
          entry_opponent = Entry.where(:room_id => @room.id).where.not(:customer_id => current_customer.id)[0]
          opponent_customer = Customer.find(entry_opponent.customer_id)
          # 相手のユーザーIDがオンラインであれば、遷移先でオンラインアイコンを表示
          puts opponent_customer.online
          if opponent_customer.online == 'on'
            @opponent_customer_status = entry_opponent.customer_id 
          else 
            @opponent_customer_status = 0
          end
          
        else
          redirect_back(fallback_location: root_path)
        end
    end
    
    def create
        @room = Room.create(:name => "DM")
        #entryにログインユーザーを作成
        @entry1 = Entry.create(:room_id => @room.id, :customer_id => current_customer.id)
        #entryにparamsユーザーを作成
        @entry2 = Entry.create(params.require(:entry).permit(:customer_id, :room_id).merge(:room_id => @room.id))
        redirect_to public_room_path(@room.id)
    end
    
    def destroy
        room = Room.find(params[:id])
        room.destroy
        redirect_to customers_rooms_path
    end
    
end
