class Public::CustomersController < ApplicationController
  
  def index
    @customers = Customer.where(is_deleted: "有効")
  end
  
  def show
    @customer = Customer.find_by(id: params[:id])
    
    #チャット
    if customer_signed_in?
      #Entry内のuser_idがcurrent_userと同じEntry
      @currentCustomerEntry = Entry.where(customer_id: current_customer.id)
      
      #Entry内のuser_idがMYPAGEのparams.idと同じEntry
      @customerEntry = Entry.where(customer_id: @customer.id)
      
      #@user.idとcurrent_user.idが同じでなければ
      unless @customer.id == current_customer.id
        @currentCustomerEntry.each do |cc|
          @customerEntry.each do |c|
            #もしcurrent_user側のルームidと＠user側のルームidが同じであれば存在するルームに飛ぶ
            if cc.room_id == c.room_id then
              @isRoom = true
              @roomId = cc.room_id
            end
          end
        end
        
        #ルームが存在していなければルームとエントリーを作成する
        unless @isRoom
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
  end

  def cancel
    
  end
  
  def mypage
    @customer = Customer.find_by(id: current_customer.id)
  end
  

  def withdraw
    current_customer.update(is_deleted: "退会")
    reset_session
    redirect_to root_path
  end

  def edit
    @customer = Customer.find_by(id: current_customer.id)
    
  end

  def update
    @customer = Customer.find_by(id: current_customer.id)
    if @customer.update(customer_params)
      flash[:createdflag] = true
      redirect_to public_customer_mypage_path
    else
      render:edit
    end
  end

  private
  # ストロングパラメータ
  def customer_params
   params.require(:customer).permit(:name, :email, :image)
  end
end
