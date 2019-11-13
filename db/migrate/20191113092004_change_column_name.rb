class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
  	rename_column :notes, :public, :public_view
  end
end
