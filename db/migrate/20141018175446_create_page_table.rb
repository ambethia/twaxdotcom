class CreatePageTable < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :fax_id
      t.string :file
      t.text :extracted_text
      t.datetime :text_extracted_at
      t.timestamps
    end
  end
end
