class AddFaxNumberToFax < ActiveRecord::Migration
  def change
    add_column :faxes, :phaxio_id, :string
    add_column :faxes, :fax_number, :string
    add_column :faxes, :metadata, :string
    add_column :faxes, :payload, :json
  end
end
