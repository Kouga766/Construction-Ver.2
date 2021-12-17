class Room < ApplicationRecord
    
   # チャット機能用アソシエーション
   has_many :entries, dependent: :destroy
   has_many :direct_messages, dependent: :destroy
   has_many :customers, through: :entries
   
end
