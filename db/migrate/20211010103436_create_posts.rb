class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :genre_id, null: false
      t.integer :user_id, null: false
      t.string :reference_url, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :release, null: false, default: true
      t.float :rate

      t.timestamps
    end
  end
end
