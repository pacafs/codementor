class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string  :url
      t.string  :tech
      t.string  :views
      t.boolean :wp
      t.boolean :ga
      t.text    :json

      t.timestamps null: false
    end
  end
end
