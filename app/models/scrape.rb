class Scrape
	
	# attr_accessor :name, :bio, :skills, :experience, :social, :company, :blog, :blog_post_count
	attr_accessor :url, :tech, :views, :wp, :ga, :json

	# def start
	# 	xlsx = Roo::Spreadsheet.open('public/test.xlsx')
	# 	xlsx.sheet('FILTERED').each do |x|
	# 		scrape(x[1])
	# 	end	
	# 	puts "SUCCESSS"
	# end

	# def scrape(url)	
	# 	begin
	# 		doc = Nokogiri::HTML(open(url, :allow_redirections => :all))
	# 		doc.css('script').remove
	# 		skills_array = []
	# 		exp_array = []
	# 		social_array = []

	# 		# Get from Codementor
	# 		self.name = doc.css(".pageTitle").text
	# 		self.bio = doc.css(".about").text

	# 		skl = doc.css(".customizeBadge")
	# 		skl.each do |s|
	# 		    skills_array.push(s)
	# 		end
	# 		self.skills = skills_array.join(", ")

	# 		exp = doc.css(".info-title")
	# 		exp.each do |e|
	# 		    exp_array.push(e.text)
	# 		end
	# 		self.experience = exp_array.join(", ")

	# 		scl = doc.css(".socialIcon a")
	# 		scl.each do |a|
	# 			social_array.push(a['href'])
	# 		end
	# 		self.social = social_array.join(", ")
			

	# 		social_index = social_array.index{|s| s.include?("github")}
	# 		if social_index
	# 			github_url = social_array[social_index]
	# 			scrape_github(github_url)
	# 		end
		    
	# 	    user = User.new(
	# 			name: self.name,
	# 			bio: self.bio,
	# 			skills: self.skills,
	# 			experience: self.experience,
	# 			social: self.social,
	# 			company: self.company,
	# 			blog: self.blog
	# 			#blog_post_count: self.blog_post_count
	# 		)
	# 		user.save
	# 		puts "Users: " + User.count.to_s


	# 	rescue OpenURI::HTTPError => e
	# 		puts "Codementor Invalid"
	# 	end	

	# end


	# def scrape_github(url)
	# 	begin
	# 		doc = Nokogiri::HTML(open(url, :allow_redirections => :all))
	# 		doc.css('script').remove
	# 		self.company = doc.css("li[itemprop='worksFor']").text
	# 		self.blog = doc.css(".url").text
	# 	rescue OpenURI::HTTPError => e
	# 		puts "Github Invalid!"
	# 	end	
	# end


	# def built_with
	# 	array = []
	# 	xlsx = Roo::Spreadsheet.open('public/blogs.xlsx')
	# 	xlsx.sheet('Blogs').each do |x|
	# 		array.push(strip_url(x[0]))
	# 	end
	# 	array.each do |a|
	# 		built_with_api(a)
	# 	end
	# end

	def strip_url(url)
		  url.sub!(/https\:\/\/www./, '') if url.include? "https://www."
		  url.sub!(/http\:\/\/www./, '')  if url.include? "http://www."
		  url.sub!(/http\:\/\//, '')      if url.include? "http://"
		  url.sub!(/https\:\/\//, '')     if url.include? "https://"
		  url.sub!(/www./, '')            if url.include? "www."
		  built_with_api(url)
	end

	def built_with_api(my_url)
		begin
		my_array = []
		response = Net::HTTP.get_response("api.builtwith.com", "http://api.builtwith.com/v9/api.json?KEY=ca3f0ec7-697b-4acc-9a25-c578f4ab91f4&LOOKUP=#{my_url}")
		data    = JSON.parse(response.body)
	    mydata = data['Results'][0]['Result']['Paths']
	    mydata.each do |x|
		  x['Technologies'].each do |t|
			my_array.push(t['Name'].downcase)
		  end
	    end
	    self.tech = my_array
	    self.url = my_url
	    self.wp = my_array.include? 'wordpress'
	    self.ga = my_array.include? 'google analytics'
	    self.json = data

	    create_blog

		rescue Exception => e
		 	puts "Something went wrong with Built_With!"
		end	
	end


	def create_blog

		blog = Blog.new(
			 	url: self.url,
				tech: self.tech,
				wp: self.wp,
				ga: self.ga,
				json: self.json
		)
		blog.save

		if blog.wp == true && blog.ga == true
			puts "You're using WORDPRESS and GOOGLE ANALYTICS!"
			puts "Work with us?"
		else
			puts "Infelizmente não estás ou outra por isso....vai pó caralho!!!"
		end

		puts "Blogs: " + Blog.count.to_s
		puts "Success"
	end


	# def find_blogs
	# 	array = []
	# 	missing_array = []
	# 	xlsx = Roo::Spreadsheet.open('public/blogs.xlsx')
	# 	xlsx.sheet('Blogs').each do |x|
	# 		array.push(strip_url(x[0]))
	# 	end
	# 	array.each do |a|
	# 		missing_array.push(a) if Blog.find_by(url: a) == nil
	# 	end
	# 	puts missing_array
	# 	puts missing_array.size
	# end

	def match_users
		xlsx = Roo::Spreadsheet.open('public/my_test.xlsx')
		workbook = WriteExcel.new('ruby.xls')
		worksheet  = workbook.add_worksheet
		i = 0
		xlsx.sheet('Sheet1').each do |user|
			match(user,xlsx,worksheet,i)
			i += 1
		end
		workbook.close
	end

	def match(user,xlsx,worksheet,i)
		my_user = User.where("blog like ?", "%#{user[0]}%").first
		puts xlsx.sheet('Sheet1').cell(i,1) #blog
		puts xlsx.sheet('Sheet1').cell(i,2) #name
		puts xlsx.sheet('Sheet1').cell(i,3) #skills
		puts xlsx.sheet('Sheet1').cell(i,4) #experience 

		worksheet.write(i, 2, my_user.name)
		worksheet.write(i, 3, my_user.skills)       
	end


	def start_out

		file = File.open("public/code2.json", "r") 
		data = file.read 
		hash = JSON.parse(data)

		xlsx = Roo::Spreadsheet.open('public/similar.xlsx')
		xlsx.sheet('test').each do |x|
			#hash["startUrl"].push("https://pro.similarweb.com/#/website/audience-overview/" + x[0] + "/*/999/3m?webSource=Total")
			hash["startUrl"].push(x[0])
		end

		puts hash["startUrl"]
		puts "########"
		puts "########"
		puts hash.to_json
		hash = []
		continue(xlsx)

	end

	def continue(xlsx)
		workbook = WriteExcel.new('ruby.xls')
		worksheet  = workbook.add_worksheet
		i = 0
		xlsx.sheet('test').each do |url|
			end_out(url,xlsx,worksheet,i)
			i += 1
		end
		workbook.close
	end

	def end_out(url,xlsx,worksheet,i)
		
		doc = Nokogiri::HTML(open(url[0], :allow_redirections => :all))
		doc.css('script').remove

		title = doc.css(".fullpost h2").text
		tags_array = []
		tags = doc.css(".tags a")
		tags.each do |t|
			tags_array.push(t.text)
		end

		worksheet.write(i, 2, title)
		worksheet.write(i, 3, tags_array.to_s)   

		puts "Success!!"
		puts title
		puts tags_array
	end


end