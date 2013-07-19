def generate_invoice(job, invoice)
	canvas = Magick::Image.new(1137, 579) {self.background_color = "white"}
	
	header = Magick::Draw.new
	header.font_family = 'helvetica'
	header.font_weight = 900
	header.pointsize = 15
	bold_text = Magick::Draw.new
	bold_text.font_family = 'helvetica'
	bold_text.font_weight = 600
	bold_text.pointsize = 11
	text = Magick::Draw.new
	text.font_family = 'helvetica'
	text.pointsize = 11
	total = Magick::Draw.new
	total.font_family = 'helvetica'
	total.pointsize = 11
	total.gravity = Magick::NorthEastGravity
	total_text = Magick::Draw.new
	total_text.font_family = 'helvetica'
	total_text.pointsize = 13
	total_text.font_weight = 600
	total_text_bold = Magick::Draw.new
	total_text_bold.font_family = 'helvetica'
	total_text_bold.pointsize = 13
	total_text_bold.font_weight = 600
	total_text_bold.gravity = Magick::NorthEastGravity
	total_bold = Magick::Draw.new
	total_bold.font_family = 'helvetica'
	total_bold.pointsize = 11
	total_bold.font_weight = 600
	total_bold.gravity = Magick::NorthEastGravity
	business_title = Magick::Draw.new
	business_title.font_family = 'helvetica'
	business_title.pointsize = 16
	business_title.gravity = Magick::NorthEastGravity
	business_info = Magick::Draw.new
	business_info.font_family = 'helvetica'
	business_info.pointsize = 14
	business_info.gravity = Magick::NorthEastGravity
	banner1 = Magick::Draw.new
	banner1.fill("#ab0534")
	banner1.polygon(5,140,1087,140,1087,155,5,155)
	banner1.draw(canvas)
	banner2 = Magick::Draw.new
	banner2.fill("#ab0534")
	banner2.polygon(459,503,1087,503,1087,518,459,518)
	banner2.draw(canvas)
	banner3 = Magick::Draw.new
	banner3.fill("#ab0534")
	banner3.polygon(5,556,1087,556,1087,558,5,558)
	banner3.draw(canvas)
	border1 = Magick::Draw.new
	border1.fill("black")
	border1.polyline(5,200,1087,200)
	border1.draw(canvas)
	banner4 = Magick::Draw.new
	banner4.fill("#f2f2f2")
	banner4.polygon(5,204,1087,204,1087,219,5,219)
	banner4.draw(canvas)
	banner5 = Magick::Draw.new
	banner5.fill("#f2f2f2")
	banner5.stroke("black").stroke_width(2)
	banner5.polygon(459,402,1087,402,1087,425,459,425)
	banner5.draw(canvas)
	border2 = Magick::Draw.new
	border2.fill("black")
	border2.polyline(5,223,1087,223)
	border2.draw(canvas)
	border3 = Magick::Draw.new
	border3.fill("black")
	border3.polyline(459,261,1087,261)
	border3.draw(canvas)
	border4 = Magick::Draw.new
	border4.fill("black")
	border4.polyline(459,280,1087,280)
	border4.draw(canvas)
	border5 = Magick::Draw.new
	border5.fill("black")
	border5.polyline(459,318,1087,318)
	border5.draw(canvas)
	border6 = Magick::Draw.new
	border6.fill("black")
	border6.polyline(459,341,1087,341)
	border6.draw(canvas)
	border7 = Magick::Draw.new
	border7.fill("black")
	border7.polyline(459,396,1087,396)
	border7.draw(canvas)
	border8 = Magick::Draw.new
	border8.fill("black")
	border8.polyline(459,431,1087,431)
	border8.draw(canvas)
	
	header.annotate(canvas, 50,0,8,18, 'PROPOSAL -- Web Development/Update Services') {self.fill = 'black'}
	
	bold_text.annotate(canvas, 0,0,8,65, 'CLIENT:') {self.fill = 'black'}
	job.clients.each do |client|
		text.annotate(canvas, 0,0,97,65, client.first_name + " " + client.last_name) {self.fill = 'black'}
	end
	bold_text.annotate(canvas, 0,0,201,65, 'DATE:') {self.fill = 'black'}
	text.annotate(canvas, 0,0,311,65, invoice.date.month.to_s+'/'+invoice.date.day.to_s+'/'+invoice.date.year.to_s) {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,8,86, 'CONTRACT:') {self.fill = 'black'}
	text.annotate(canvas, 0,0,97,86, 'TBD') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,201,86, 'ORDER #:') {self.fill = 'black'}
	text.annotate(canvas, 0,0,311,86, 'TBD') {self.fill = 'black'}
	
	business_title.annotate(canvas, 0,0,52,30, 'Gtwo Development') {self.fill = 'black'}
	business_info.annotate(canvas, 0,0,52,53, '200 Travertine') {self.fill = 'black'}
	business_info.annotate(canvas, 0,0,52,74, 'San Antonio, Texas 78213-2522') {self.fill = 'black'}
	business_info.annotate(canvas, 0,0,52,95, 'www.gtwodevelopment.net') {self.fill = 'black'}
	
	t = Time.now
	fy1 = invoice.fiscal_years.first(:year => t.year)
	fy2 = invoice.fiscal_years.first(:year => t.year + 1)
	
	if invoice.business_rate == :Time_and_Materials
		fy1hours = fy1.estimated_hours.to_s
		fy2hours = fy2.estimated_hours.to_s
		fy1rate = fy1.client_rate.to_s
		fy2rate = fy2.client_rate.to_s
		hours_sub = fy1.estimated_hours + fy2.estimated_hours
		lab_sub1 = fy1.estimated_hours * fy1.client_rate 
		lab_sub2 = fy2.estimated_hours * fy2.client_rate
		lab_sub = lab_sub1 + lab_sub2 
		trav_sub = invoice.travel_cost*lab_sub
		lab_trav_sub = trav_sub+lab_sub
		tax_sub = invoice.state_tax*lab_trav_sub
		total_cost = tax_sub+lab_trav_sub+invoice.hosting
		hosting = invoice.hosting
		invoice.total_cost = total_cost
	else
		fy1hours = "0"
		fy2hours = "0"
		fy1rate = "0"
		fy2rate = "0"
		hours_sub = 0
		lab_sub1 = 0
		lab_sub2 = 0
		lab_sub = 0
		trav_sub = 0
		lab_trav_sub = 0
		tax_sub = 0
		hosting = 0
		total_cost = invoice.total_cost
	end
	
	bold_text.annotate(canvas, 0,0,8,181, 'CLIN') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,201,181, 'LABOR CATEGORY') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,406,181, 'PERSONNEL') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,649,167, "FY#{fy1.year-2000}") {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,632,182, 'ESTIMATED') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,643,197, 'HOURS') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,710,182, "FY#{fy1.year-2000} #{invoice.business_rate == :Time_and_Materials ? 'T&M' : 'Flat'} RATE".upcase) {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,829,167, "FY#{fy2.year-2000}") {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,812,182, 'ESTIMATED') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,823,197, 'HOURS') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,904,174, 'PROPOSED') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,895,189, "FY#{fy2.year-2000} #{invoice.business_rate == :Time_and_Materials ? 'T&M' : 'Flat'} RATE".upcase) {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,1014,182, 'TOTAL') {self.fill = 'black'}
	
	text.annotate(canvas, 0,0,8,216, "000#{invoice.id} (#{invoice.business_rate == :Time_and_Materials ? 'T&M' : 'Flat'})".upcase) {self.fill = 'black'}
	text.annotate(canvas, 0,0,201,216, invoice.labor_category) {self.fill = 'black'}
	text.annotate(canvas, 0,0,406,216, 'Gtwo Team') {self.fill = 'black'}
	text.annotate(canvas, 0,0,656,216, fy1hours) {self.fill = 'black'}
	text.annotate(canvas, 0,0,736,216, "$%.2f" % fy1rate) {self.fill = 'black'}
	text.annotate(canvas, 0,0,839,216, fy2hours) {self.fill = 'black'}
	text.annotate(canvas, 0,0,920,216, "$%.2f" % fy2rate) {self.fill = 'black'}
	
	total.annotate(canvas, 0,0,66,207, "$%.2f" % lab_sub) {self.fill = 'black'}
	total.annotate(canvas, 0,0,66,230, "$%.2f" % lab_sub1) {self.fill = 'black'}
	total.annotate(canvas, 0,0,66,245, "$%.2f" % lab_sub2) {self.fill = 'black'}
	total_bold.annotate(canvas, 0,0,66,265, "$%.2f" % lab_sub) {self.fill = 'black'}
	total.annotate(canvas, 0,0,66,288, "$%.2f" % trav_sub) {self.fill = 'black'}
	total.annotate(canvas, 0,0,66,302, "$%.2f" % trav_sub) {self.fill = 'black'}
	total_bold.annotate(canvas, 0,0,66,325, "$%.2f" % trav_sub) {self.fill = 'black'}
	total.annotate(canvas, 0,0,66,350, "$%.2f" % lab_trav_sub) {self.fill = 'black'}
	total.annotate(canvas, 0,0,66,365, "$%.2f" % tax_sub) {self.fill = 'black'}
	total.annotate(canvas, 0,0,66,380, "$%.2f" % hosting) {self.fill = 'black'}
	total_text_bold.annotate(canvas, 0,0,66,409, "$%.2f" % total_cost) {self.fill = 'black'}
	
	text.annotate(canvas, 0,0,474,239, "Subtotal FY#{fy1.year-2000}Labor Costs") {self.fill = 'black'}
	text.annotate(canvas, 0,0,474,254, "Subtotal FY#{fy2.year-2000}Labor Costs") {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,474,274, 'SUBTOTAL LABOR COST') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,656,274, "#{hours_sub}") {self.fill = 'black'}
	text.annotate(canvas, 0,0,474,297, 'Travel Costs') {self.fill = 'black'}
	text.annotate(canvas, 0,0,649,311, "%.2f%" % invoice.travel_cost) {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,474,334, 'SUBTOTAL TRAVEL COSTS') {self.fill = 'black'}
	text.annotate(canvas, 0,0,474,359, 'Subtotal Labor and Travel Costs') {self.fill = 'black'}
	text.annotate(canvas, 0,0,474,374, 'State Tax') {self.fill = 'black'}
	text.annotate(canvas, 0,0,649,374, "%.2f%" % invoice.state_tax) {self.fill = 'black'}
	text.annotate(canvas, 0,0,474,389, "Hosting (1 #{invoice.hosting_rate})") {self.fill = 'black'}
	total_text.annotate(canvas, 0,0,474,418, 'TOTAL NOT TO EXCEED COST') {self.fill = 'black'}
	bold_text.annotate(canvas, 0,0,474,500, 'SUBMITTED BY') {self.fill = 'black'}
	text.annotate(canvas, 0,0,710,500, 'Gtwo Development') {self.fill = 'black'}
	
	text.annotate(canvas, 0,0,7,553, "This is a #{invoice.business_rate.to_s.split('_').join(' ')} contract.") {self.fill = 'black'}
	text.annotate(canvas, 0,0,7,570, 'Gtwo Development Costing Template') {self.fill = 'black'}
	
	canvas.write("./public/invoices/invoice-#{invoice.id}.png")
end
