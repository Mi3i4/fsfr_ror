class AddAnsweredToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :answered, :text
  end
end
