class AddConfigTable < ActiveRecord::Migration
  def change
    create_table :hacks do |t|
      t.string :name
      t.text :value
    end

    add_index :hacks, :name

    Hack.set('video_url', 'https://zippy.gfycat.com/GlitteringBadAnglerfish.mp4')
  end
end
