class User < ActiveRecord::Base
  
	def as_xls(options = {})
	  {
	      "Id" => id,
	      "Name" => name,
	      "Bio" => bio,
	      "Skills" => skills,
	      "Experience" => experience,
	      "Social" => social,
	      "Company" => company,
	      "Blog" => blog
	  }
	end

	def self.to_csv
    	attributes = %w{name skills}

	    CSV.generate(headers: true) do |csv|
	      csv << attributes

	      all.each do |user|
	        csv << attributes.map{ |attr| user.send(attr) }
	      end
	    end

  	end

  	def self.all_users
  		blogs = []
  		users = []
  		Blog.where(wp: true, ga: true).each do |b|
  			blogs.push(b.url)
  		end
  		blogs.each do |b|
  			user = User.where("blog LIKE ?", "%#{b}%")
  			users.push(user)
  		end
  		return users
  	end




end