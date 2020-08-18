class AddGioiTinhToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gioi_tinh, :integer
  end
end
