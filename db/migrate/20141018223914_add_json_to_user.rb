class AddJsonToUser < ActiveRecord::Migration
  def change
    add_column :users, :oauth_data, :json
  end
end
