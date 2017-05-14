class Loan < ActiveRecord::Base
	mount_uploader :input, LoanUploader
	mount_uploader :output, LoanUploader
end
