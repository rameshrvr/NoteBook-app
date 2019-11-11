class AddCreatedByToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :created_by, :string
  end
end
