class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.integer  :liker_id
      t.integer :likeable_id
      t.string :likeable_type, null: false
      t.timestamps
    end

    add_index :likes, :liker_id
    add_index :likes, :likeable_type
    add_index :likes, :likeable_id
    add_index :likes, [:likeable_id, :liker_id, :likeable_type], unique: true

  end
end
