class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :post_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked, default: false, null:

      t.timestamps
    end

    add_index :notifications, :visiter_id
    add_index :notifications, :visited_id
    add_index :notifications, :post_id
    add_index :notifications, :comment_id
  end
end
