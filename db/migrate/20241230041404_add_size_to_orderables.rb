class AddSizeToOrderables < ActiveRecord::Migration[8.0]
  def change
    add_column :orderables, :size, :string
  end
end
