class Invoice
	include DataMapper::Resource
	property :id, Serial
	property :date, DateTime
	property :contract, String
	property :order_number, Integer
	property :business_rate, Enum[ :Time_and_Materials, :Flat_Rate ], :default => :Time_and_Materials
	property :labor_category, String
	property :travel_cost, Float
	property :state_tax, Float
	property :hosting_rate, Enum[ :Hour, :Day, :Month, :Quarter, :HalfYear, :Year ], :default => :Month
	property :hosting, Float
	property :total_cost, Float
	belongs_to :job, :child_key => [:job_id]
	has n, :fiscal_years, :child_key => [:invoice_id]
end

class FiscalYear
	include DataMapper::Resource
	property :id, Serial
	property :year, Integer
	property :estimated_hours, Integer
	property :client_rate, Float
	belongs_to :invoice, :child_key => [:invoice_id]
end
