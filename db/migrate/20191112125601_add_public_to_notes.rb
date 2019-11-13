class AddPublicToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :public, :boolean

    Note.find_each do |note|
    	note.update!(public: false)
    end

    change_column_null :notes, :public, false
  end
end
