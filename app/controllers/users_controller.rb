class UsersController < ApplicationController
  
  def index
    respond_to do |format|
      format.html
      format.csv { send_data User.to_csv, filename: "users-#{Date.today}.csv" }
      format.json { render json: User.find(20) }
    end
  end

  def users
  	respond_to do |format|
      format.json { render json: User.all_users }
    end
  end

  def blogs
  	respond_to do |format|
      format.json { render json: Blog.all_blogs }
    end
  end

  def get_blog
    respond_to do |format|
      format.json { render json: Blog.get_blog(params["blog"]) }
    end
  end


end