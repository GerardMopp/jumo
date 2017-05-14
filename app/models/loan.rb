class Loan < ActiveRecord::Base
	mount_uploader :input, LoanUploader
	mount_uploader :output, LoanUploader

	validates_presence_of :input

	def validate_source_structure
  		
  end

	after_create :process_input
	def process_input
		LoanWorker.perform_async(self.id)
	end
end
