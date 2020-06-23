class CreatePolygons < ActiveRecord::Migration[6.0]
  def change
    create_table :polygons do |t|
      t.text :value

      t.timestamps
    end
  end
end
