class AddColumnUser < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :online, :string
  end
end
