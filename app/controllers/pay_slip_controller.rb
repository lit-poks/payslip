class PaySlipController < ApplicationController
  include PaySlipHelper

  def new
  end

  def generated_payslip
    set_payslip
  end

  def payslip_calculator
    @calculated_payslip = {
      gross_pay: ,
      tds: ,
      health_contribution: ,
      gis: ,
      laptop_loan_repayment: ,
      advance_repayment: ,
      other_deductables: ,
      net_pay:
    }
    session[:payslip] = @calculated_payslip

    respond_to do |format|
      format.html { redirect_to  generated_payslip_url }
    end
  end

  private

  def filtered_params
    @filtered_params ||= params.permit(
      [:base_pay, :pf_in_percentage, :laptop_loan_amount_per_month, :advance_repayment, :other_deductables]
    )
  end

  def set_payslip
    @calculated_payslip = session[:payslip] if session[:payslip]
  end
end
