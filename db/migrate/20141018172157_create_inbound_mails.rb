class CreateInboundMails < ActiveRecord::Migration
  def change
    create_table :inbound_mails do |t|
      t.json :data

      t.timestamps null: false
    end
  end
end
