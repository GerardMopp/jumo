class Loan < ActiveRecord::Base
	mount_uploader :input, LoanUploader
	mount_uploader :output, LoanUploader

	after_create :process_input
	def process_input
		LoanWorker.perform_async(self.id)
	end
end
