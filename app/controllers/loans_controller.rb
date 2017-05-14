class LoansController < ApplicationController

	def new
		@loan = Loan.new
	end

	def index
		@loans = Loan.all
	end

	def create
		@loan = Loan.new(loan_params)
		respond_to do |format|
      if @loan.save
        format.html { redirect_to loan_path(@loan), notice: 'File Uploaded' }
      else
        format.html { render action: 'new' }	
      end
    end
	end

	def show
		@loan = Loan.find_by_id(params[:id])
	end

 private

    def loan_params
      params.require(:loan).permit(:input)
    end


end
