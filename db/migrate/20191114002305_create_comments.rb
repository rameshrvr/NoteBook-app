class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :description, null: false
      t.string :created_by, null: false
      t.integer :note_id, null: false

      t.timestamps
    end
  end
end
