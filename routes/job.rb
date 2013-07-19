get '/jobs', :auth => :user do
	@jobs = Job.all(:order => :name.asc)
	@clients = Client.all(:order => :last_name.asc)
	erb :jobs
end

post '/jobs/create', :auth => :user do
	j = Job.new
	j.name = params[:name]
	j.objective = params[:objective]
	j.save
	if !params[:clients].nil?
		params[:clients].each do |client|
			name = client.split(" , ")
			c = Client.first(:last_name => name[0], :first_name => name[1])
			ClientJob.create(:job_id => j.id, :client_id => c.id)
		end
	end
	users = User.all
	users.each do |user| 
		$tube.put({"user" => user, "subject" => j.name, "text" => "Job <a href=\"/jobs?job=#{j.id}\">#{j.name}</a> was created."}.to_json)
		message_gen
	end
	redirect back
end

post '/jobs/update/:id', :auth => :user do
	j = Job.get(params[:id])
	j.name = params[:name]
	j.objective = params[:objective]
	j.save
	if params[:clients].nil? == false
		cj = ClientJob.all(:job_id => j.id)
                cj.destroy		
		params[:clients].each do |client|
			name = client.split(" , ")
			c = Client.first(:last_name => name[0], :first_name => name[1])
			ClientJob.create(:job_id => j.id, :client_id => c.id)
		end
	else
		cj = ClientJob.all(:job_id => j.id)
		cj.destroy
	end
	redirect back
end

get '/jobs/destroy/:id', :auth => :user do
	j = Job.get(params[:id])
	cj = ClientJob.all(:job_id => j.id)
	ji = j.invoice
	if !ji.nil? 
		y = ji.fiscal_years
		y.destroy
	  ji.destroy
	end
	cj.destroy
	j.destroy
	redirect back
end

get '/jobs/:id/invoices', :auth => :user do
	@job = Job.get(params[:id])
	@invoice = @job.invoice
	erb :invoices, :layout => (request.xhr? ? false : :layout)
end

get '/invoices/destroy/:id', :auth => :user do
  i = Invoice.get(params[:id])
  y = i.fiscal_years
  y.destroy
	i.destroy
  redirect back
end	

post '/jobs/:id/invoices/create', :auth => :user do
	i = Invoice.new
	i.date = Time.now
	i.labor_category = params[:category]
	i.business_rate = params[:business_rate].split(" ").join("_")
	i.travel_cost = params[:travel]
	i.hosting = params[:host]
	i.hosting_rate = params[:host_rate] == "Half Year" ? :HalfYear : params[:host_rate]
	i.state_tax = 0.00
	i.contract = "TBD"
	i.order_number = 0
	i.total_cost = params[:business_rate].split(" ").join("_") == "Flat_Rate" ? params[:flat] : 0
	j = Job.get(params[:id])
	i.job_id = j.id
	i.save
	t = Time.now
	fy1 = FiscalYear.create(:year => t.year, :invoice_id => i.id)
	fy1.estimated_hours = params[:FY1hours]
	fy1.client_rate = params[:FY1rate]
	fy2 = FiscalYear.create(:year => t.year+1, :invoice_id => i.id)
	fy2.estimated_hours = params[:FY2hours]
	fy2.client_rate = params[:FY2rate]
	fy1.save
	fy2.save
	generate_invoice(j, i)
	redirect back
end

post '/invoices/update/:id', :auth => :user do
	i = Invoice.get(params[:id])
	i.labor_category = params[:category]
	date = Time.new(params[:year],params[:month],params[:day],0,0,0, "-06:00")
	i.date = date
	i.business_rate = params[:business_rate].split(" ").join("_")
	i.travel_cost = params[:travel]
	i.hosting = params[:host]
	i.hosting_rate = params[:host_rate] == "Half Year" ? :HalfYear : params[:host_rate]
	i.state_tax = 0.00
	i.contract = "TBD"
	i.order_number = 0
	i.total_cost = params[:business_rate].split(" ").join("_") == "Flat_Rate" ? params[:flat] : 0
	i.save
	t = Time.now
	fy1 = FiscalYear.first_or_create({:year => t.year}, {:invoice_id => i.id})
	fy1.estimated_hours = params[:FY1hours]
	fy1.client_rate = params[:FY1rate]
	fy2 = FiscalYear.first_or_create({:year => t.year+1}, {:invoice_id => i.id})
	fy2.estimated_hours = params[:FY2hours]
	fy2.client_rate = params[:FY2rate]
	generate_invoice(i.job, i)
	redirect back
end
