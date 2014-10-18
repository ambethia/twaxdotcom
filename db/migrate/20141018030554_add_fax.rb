class AddFax < ActiveRecord::Migration
  def change
    create_table :faxes do |t|
      t.integer :user_id
      t.string  :file
      t.timestamps
    end
  end
end
