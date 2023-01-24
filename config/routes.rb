Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "pay_slip#new"

  post '/payslip', to: 'pay_slip#payslip_calculator'
  get '/generated_payslip', to: 'pay_slip#generated_payslip'
end
