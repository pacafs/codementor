class AddNewDataToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :last_3_month_visits, :integer
    add_column :blogs, :avg_monthly_visits, :integer
    add_column :blogs, :avg_visit_duration, :string
    add_column :blogs, :pages_per_visit, :integer
    add_column :blogs, :bounce_rate, :integer
  end
end
