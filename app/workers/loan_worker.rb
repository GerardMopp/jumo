class LoanWorker
  include Sidekiq::Worker

  def perform(loan_id)
    @loan = Loan.find_by_id(loan_id)
    begin
      hash = {}
      SmarterCSV.process(open(@loan.input.url), {}) do |row|
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
        @loan.output = f
      end
      
      @loan.save!

      check_my_channel(loan_id)
      Pusher["loan_#{@loan.id}"].trigger('done', {
        :done => true
      })
    rescue Exception => e
      
      check_my_channel(loan_id)
      Pusher["loan_#{@loan.id}"].trigger('error', {
        :error => e.message
      })
    raise e 
    end
  end

  def format_header(value)
  	value.gsub("'", '')
  end

  def check_my_channel(loan_id)
    counter = 0
    begin
      sleep 1
      counter = counter + 1
      if counter >= 29
        return  nil
      end
      response = Pusher.get("/channels/loan_#{loan_id}")
    end while !response[:occupied]
    response
  end

end

