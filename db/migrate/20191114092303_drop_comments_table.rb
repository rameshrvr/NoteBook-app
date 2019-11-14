class DropCommentsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :comments
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
