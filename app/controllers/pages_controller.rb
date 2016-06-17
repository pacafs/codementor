class PagesController < ApplicationController


	def index
	  @my_array = []
	  @users  = User.all
	  file    = File.read('public/my_file.json')
	  data    = JSON.parse(file)
	  @mydata = data['Results'][0]['Result']['Paths']
	  @mydata.each do |x|
		x['Technologies'].each do |t|
			@my_array.push(t['Name'].downcase)
		end
	  end

	  respond_to do |format|
	    format.html
	    format.xls { send_data @users.to_xls, content_type: 'application/vnd.ms-excel', filename: 'users.xls' }
	  end

	end




end