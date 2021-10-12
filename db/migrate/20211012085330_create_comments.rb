class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      
      t.integer :user_id
      t.integer :post_id
      t.text :comment, null: false
      t.float :rate

      t.timestamps
    end
  end
end
