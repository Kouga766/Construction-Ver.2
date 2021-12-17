class DirectMessage < ApplicationRecord
    
    validates :content, presence: true, length: {in: 1..200}

    #　アソシエーション
    belongs_to :customer
    belongs_to :room
    #　アソシエーション
    
    #ブロードキャスト
    after_create_commit { DirectMessageBroadcastJob.perform_later self }
end
