class AddGpointToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gpoint, :integer
  end
end
