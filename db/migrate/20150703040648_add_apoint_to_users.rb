class AddApointToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apoint, :integer
  end
end
