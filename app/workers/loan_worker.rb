class LoanWorker
  include Sidekiq::Worker

  def perform(*args)
    loan = Loan.find_by_id(args[0])
    begin
      hash = {}
      SmarterCSV.process(loan.input.path, {}) do |row|
        network = format_header(row[0][:network])
        month = Date.parse(format_header(row[0][:date])).strftime('%B')
        product = format_header(row[0][:product])
        hash["#{network} - #{product} - #{month}"]  = 0 unless hash.has_key?("#{network} - #{product} - #{month}")
        hash["#{network} - #{product} - #{month}"] += row[0][:amount].to_f 
      end

      full_filename = "#{Rails.root}/tmp/#{Time.now.strftime("%Y%m%d%H%M%S").downcase}/Output.csv"
      Dir.mkdir( "#{Rails.root}/tmp/#{Time.now.strftime("%Y%m%d%H%M%S").downcase}") unless File.exists?("#{Rails.root}/tmp/#{Time.now.strftime("%Y%m%d%H%M%S").downcase}")
      CSV.open(full_filename, "wb") do |csv|
        headers = ['Network', 'Product', 'Month', 'Aggregate']
        csv << headers
        hash.each do |key, value|
          csv << key.split(' - ') + [value]
        end
      end

      File.open(full_filename) do |f|
        loan.output = f
      end
      
      loan.save!
      Pusher["loan_#{loan.id}"].trigger('done', {
        :done => true
      })
    rescue Exception => e
      Pusher["loan_#{loan.id}"].trigger('error', {
        :error => e
      })
    raise e 
    end
  end

  def format_header(value)
  	value.gsub("'", '')
  end

end

