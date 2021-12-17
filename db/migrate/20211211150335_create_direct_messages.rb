class CreateDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_messages do |t|
      t.string :content
      t.integer :customer_id
      t.integer :room_id

      t.timestamps
    end
  end
end
