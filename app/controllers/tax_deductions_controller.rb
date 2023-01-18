class TaxDeductionsController < ApplicationController
  before_action :fetch_deduction, only: %i[show edit update destroy]
  def index
    if authorised_admin? 
      @tax_deductions = TaxDeduction.all
    elsif authorised_employee?
      @tax_deductions = TaxDeduction.where(employee_id: current_user.id)
    else
      flash[:alert] = "Unauthorized User" 
      redirect_to root_path
    end
  end

  def show
    @tax_deduction = TaxDeduction.find(params[:id])
    if authorised_admin? || authorised_employee?
      @tax_deduction = TaxDeduction.find(params[:id])
    else
      flash[:alert] = "Unauthorized User" 
      redirect_to root_path
    end
  end

  def new
    @tax_deduction = TaxDeduction.new
  end

  def create
    binding.pry
    @tax_deduction = TaxDeduction.new(tax_deduction_params)    
    if authorised_employee? &&  @tax_deduction.save
        flash[:notice] = "Sucessfully, saved the employee's tax_deduction details"
        redirect_to tax_deductions_path
    else
      flash[:notice] = "Unauthorised user or invalid details"
      redirect_to edit_salary_path(@existing_salary)
    end
  end

  def edit 
  end

  def update
    if authorised_employee? && @tax_deduction.update(tax_deduction_params) 
        flash[:notice] = 'Sucessfully, updated the attendance of employee'
        redirect_to tax_deductions_path
    else
      flash[:notice] = 'Unauthorised user'
      redirect_to tax_deductions_path
    end
  end


  def destroy   
    if @tax_deduction.destroy && authorised_employee?
      flash[:notice] = 'tax_deduction destroyed' 
      redirect_to tax_deductions_path
    else
      flash[:alert] = 'Unauthorized User'
      redirect_to tax_deductions_path
    end
  end

  protected

  def fetch_deduction
    @tax_deduction = TaxDeduction.find(params[:id]) 
  end

  def tax_deduction_params
    params.require(:tax_deduction).permit(:tax_type, :ammount, :employee_id, :financial_year)
  end
end
