class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :bio
      t.string  :skills
      t.string  :experience
      t.string  :social
      t.string  :company
      t.string  :blog
      t.integer :blog_post_count

      t.timestamps null: false
    end
  end
end



