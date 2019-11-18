class CreateShareNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :share_notes do |t|
      t.integer :note_id, null: false
      t.integer :user_profile_id, null: false

      t.timestamps
    end
  end
end
