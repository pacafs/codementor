class Blog < ActiveRecord::Base

	# def self.all_blogs
 #  			blogs = []
	#   		Blog.where(wp: true, ga: true).each do |b|
	#   			blogs.push(b.url)
	#   		end
 #  		return blogs
 #  	end


  	def self.import_blogs
		xlsx = Roo::Spreadsheet.open('public/import.xlsx')
		counter = 0
		xlsx.sheet('Sheet1').each do |x|
			puts "#{x[0]} - #{x[1]} - #{x[2]} - #{x[3]} - #{x[4]} - #{x[5]}"
			blog = Blog.where("url LIKE ?", "%#{x[0]}%")
			blog.first.update_attributes(last_3_month_visits: x[1], avg_monthly_visits: x[2], avg_visit_duration: x[3], pages_per_visit: x[4], bounce_rate: x[5])
			puts "Blog updated with success!"
			if blog.first != nil
				counter += 1
			end
		end	
		puts counter
  	end

  	def self.all_blogs
		xlsx = Roo::Spreadsheet.open('public/import.xlsx')
		counter = 0
		blogs = []
		xlsx.sheet('Sheet1').each do |x|
			blog = Blog.where("url LIKE ?", "%#{x[0]}%")
			blogs.push(blog.first.url)
			if blog.first != nil
				counter += 1
			end
		end	
		return blogs
  	end

  	def self.get_blog(params)
  		blog = Blog.where("url LIKE ?", "%#{params}%")
  		return blog
  	end

  	


end