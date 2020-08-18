class AddQueQuanToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :que_quan, :string
  end
end
