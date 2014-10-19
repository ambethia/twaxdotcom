class AddNickAndCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string
    add_column :users, :faxes_sent_count, :integer, default: 0
  end
end
