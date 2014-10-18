class AddPhaxioBarcodeUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :phaxio_barcode_url, :string
  end
end
