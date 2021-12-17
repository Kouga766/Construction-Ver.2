class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #　アソシエーション
  has_many :reviews, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  # チャット機能用アソシエーション
  has_many :entries
  has_many :direct_messages
  has_many :rooms, through: :entries
  #　アソシエーション

  attachment :image

  # enum
  enum is_deleted:  { 退会: true, 有効: false }
  # enum

  def appear()
    self.update(online: 'on')
    ActionCable.server.broadcast "appearance_channel", customer_id: self.id, event: "appear"
  end

  def away()
    self.update(online: 'off')
    ActionCable.server.broadcast "appearance_channel", customer_id: self.id, event: "away"
  end


end
