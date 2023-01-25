module PaySlipHelper
  extend ActiveSupport::Concern

  included do

    TAX_BRACKET = [300000, 400000, 650000, 1000000, 1500000, 10000000000].freeze
    TAX_PERCENTAGE = {
      '0': 0.1,
      '1': 0.15,
      '2': 0.2,
      '3': 0.25,
      '4': 0.3,
    }.with_indifferent_access.freeze

    def net_pay
      @net_pay ||= gross_pay - pf_amount - tds - health_contribution - gis - laptop_loan_repayment - advance_repayment - gym_repayment
    end

    def tds
      @tds ||= (taxable_amount < 25001  ? 0 : calculate_tds)
    end

    def taxable_amount
      @taxable_amount ||= (gross_pay - pf_amount - gis)
    end

    def gross_pay
      @gross_pay ||= params[:base_pay].to_f
    end

    def basic_pay
      @basic_pay ||= gross_pay / 2
    end

    def pf_amount
      return 0 unless params[:on_probation].to_f.zero?

      @pf_amount ||= (basic_pay * params[:pf_in_percentage].to_f) / 100
    end

    def gis
      return 0 unless params[:on_probation].to_f.zero?

      if basic_pay >= 60000
        500.0
      elsif basic_pay >= 30000 && basic_pay <= 59999
        400
      elsif basic_pay >= 16000 && basic_pay <= 29999
        300
      else
        200
      end
    end

    def calculate_tds(looping_amount = 25100, total = 0)
      return calculate_high_tax if taxable_amount > 167400
      return total if taxable_amount < looping_amount

      total += if looping_amount <= 33300
                 10
               elsif looping_amount == 33400
                 13
               elsif looping_amount >= 33401 && looping_amount <= 54100
                 15
               elsif looping_amount == 54200
                 17
               elsif looping_amount >= 54201 && looping_amount <= 83300
                 20
               elsif looping_amount == 83400
                 23
               elsif looping_amount >= 83401 && looping_amount <= 125100
                 25
               elsif looping_amount >= 125101 && looping_amount <= 167400
                 30
               end

      calculate_tds(looping_amount + 100, total)
    end

    def calculate_high_tax
      x = taxable_amount - 125000
      y = x * 0.3
      z = y + 20208
      a = y + z
    end

    def health_contribution
      @health_contribution ||= gross_pay * 0.01
    end

    def laptop_loan_repayment
      @laptop_loan_repayment ||= params[:laptop_loan_amount_per_month].to_f
    end

    def advance_repayment
      @advance_repayment ||= params[:advance_repayment].to_f
    end

    def gym_repayment
      @gym_repayment ||= params[:gym_repayment].to_f
    end
  end
end
