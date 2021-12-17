class AddImageIdToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :image_id, :string
  end
end
