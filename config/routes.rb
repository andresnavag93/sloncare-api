Rails.application.routes.draw do
  resources :subscribers, only: [:create]
  
  #GET
    get 'countries/', to: 'locations#search_countries'
    get 'countries/:id/states/', to: 'locations#search_root'
    get 'states/:id/cities/', to: 'locations#search_root'
    get 'countries/:id/', to: 'locations#show'
    get 'locales/', to: 'tbl_attributes#search_root', :id => 1
    get 'plans/', to: 'tbl_attributes#search_root', :id => 2
    get 'priorities/', to: 'tbl_attributes#search_root', :id => 3
    get 'payments/', to: 'tbl_attributes#search_root', :id => 5
    get 'protocols/', to: 'tbl_attributes#search_root', :id => 6
    get 'saving_levels/', to: 'tbl_attributes#search_root', :id => 7
    get 'security_questions/', to: 'tbl_attributes#search_root', :id => 8
    get 'blood_types/', to: 'tbl_attributes#search_root', :id => 9
    get 'races/', to: 'tbl_attributes#search_root', :id => 10
    get 'weight_units/', to: 'tbl_attributes#search_root', :id => 11
    get 'size_units/', to: 'tbl_attributes#search_root', :id => 12
    get 'genders/', to: 'tbl_attributes#search_root', :id => 13
    get 'suggestions/', to: 'tbl_attributes#search_root', :id => 15
    get 'fees/', to: 'tbl_attributes#search_root', :id => 16
    get 'service_types/', to: 'tbl_attributes#search_root', :id => 18
    get 'currency/', to: 'tbl_attributes#search_root', :id => 19
    get 'status/', to: 'tbl_attributes#search_root', :id => 21
    get 'income_types/', to: 'tbl_attributes#search_root', :id => 22
    get 'assign_area/', to: 'tbl_attributes#search_root', :id => 23
    get 'high_types/', to: 'tbl_attributes#search_root', :id => 24
    get 'provider_types/', to: 'tbl_attributes#search_root', :id => 25
    get 'record_types/', to: 'tbl_attributes#search_root', :id => 26
    get 'transacs_types/', to: 'tbl_attributes#search_root', :id => 27

  #SPECIALTIES
    get 'specialties/', to: 'specialties#index'
    get 'provider/specialties/', to: 'specialties#index_provider'
    get 'doctors/specialties/', to: 'specialties#index_doctor'
    get 'clinics/specialties/', to: 'specialties#index_clinic'
    get 'specialties/:id/subspecialties/', to: 'specialties#subspecialties'
    get 'service_types/:id/specialties/', to: 'specialties#search_services_specialties' 

  #SLONCARDS
    post 'information/mail/', to: 'sponsors#landing_email_server'
    post 'sloncards/', to: 'transacs#buy_sloncard_code'

  #GROUPS
    post 'groups/:type/', to: 'groups#create' 
    get 'groups/:id', to: 'groups#show' 
    put 'groups/:id', to: 'groups#update' 
    get 'groups/:id/beneficiaries/', to: 'groups#beneficiaries'
    

    get 'groups/:id/credit_card/', to: 'groups#get_creditcard'
    put 'groups/:id/credit_card/', to: 'groups#put_creditcard'
    delete 'groups/:id/credit_card/', to: 'groups#delete_creditcard'

  #BENEFICIARIES
    post 'beneficiaries/', to: 'beneficiaries#create'
    get 'beneficiaries/:id', to: 'beneficiaries#show'
    get 'beneficiaries/wallets/:wallet_id', to: 'beneficiaries#show_wallet'
    put 'beneficiaries/:id', to: 'beneficiaries#update'
    get 'beneficiaries/:id/credit_card/', to: 'beneficiaries#get_creditcard'
    put 'beneficiaries/:id/credit_card/', to: 'beneficiaries#put_creditcard'
    delete 'beneficiaries/:id/credit_card/', to: 'beneficiaries#delete_creditcard'

  #BENEFICIARIES-GROUP
    post 'groups/:id/new/beneficiaries/', to: 'beneficiarie#new_beneficiary_to_group'
    post 'groups/:id/beneficiaries/', to: 'beneficiaries#beneficiary_to_group'
    get 'groups/:group_id/beneficiaries/:id', to: 'beneficiaries#show_beneficiary_to_group'
    put 'groups/:group_id/beneficiaries/:id/', to: 'beneficiaries#update_beneficiary_in_group'
    delete 'groups/:id/beneficiaries/:beneficiary_id/', to: 'beneficiaries#delete_beneficiary_to_group'

  #DOCTOR
    get 'showing/doctors/', to: 'doctors#showing_index'
    post 'doctors/', to: 'doctors#create'
    get 'doctors/:id', to: 'doctors#show'
    put 'doctors/:id', to: 'doctors#update'

  #CLINIC
    get 'showing/clinics/', to: 'clinics#showing_index'
    post 'clinics/', to: 'clinics#create'
    get 'clinics/:id', to: 'clinics#show'
    put 'clinics/:id', to: 'clinics#update'

  #PROVIDERS
    post 'providers/', to: 'providers#create' 
    get 'providers/:id', to: 'providers#show'  
    put 'providers/:id', to: 'providers#update' 

  #ARTICLES
    resources :articles, except: :index
    get 'articles/range/:init/:end/', to: 'articles#pagination'
    get 'not/articles/:id/range/:init/:end/', to: 'articles#pagination_without'

  #AUTHENTICATION
    post 'new/auth/' => 'authentication#auth_user'
    post 'new/auth/admin/' => 'authentication#auth_user_admin'
    get 'auth/token/verify/' => 'authentication#verify_token'
    delete 'logout/' => 'authentication#logout'

  #PASSWORD RECOVERY
    post 'send/recovery/token/' => 'recovery_passwords#send_email'
    get 'security/questions/' => 'recovery_passwords#security_questions'
    put 'verify/security/questions/' => 'recovery_passwords#verify_answers'
    put 'recovery/change/password/' => 'recovery_passwords#change_recovery_password'
    put 'change/password/' => 'recovery_passwords#change_user_password'

  #WALLETS
    put 'recharge/wallets/:id/', to: 'wallets#recharge_wallets'
    get 'wallets/:id/transacs/range/:init/:end/', to: 'wallets#nested_pagination'
    put 'wallets/:id/withdraw/', to: 'wallets#withdraw_money'
    get 'pending/transacs/:type/range/:init/:end/', to: 'wallets#pending_transacs'
    get 'checked/transacs/:type/range/:init/:end/', to: 'wallets#checked_transacs'
    put 'check/transacs/:id/', to: 'wallets#check_transacs'
    get 'wallets/:id/available/', to: 'wallets#wallet_money_available'
    #get 'users/wallets/:wallet_id', to: 'beneficiaries#show_wallet'

  #SERVICES TYPES GETS SPECIALTIES - TABS
    get 'service_types/:id/tabulators/', to: 'tabulators#search_services' 
    get 'service_types/:id/specialties/:specialty_id/tabulators/', to: 'tabulators#index_tabulators'
    get 'service_types/:id/record_types/:record_id/tabulators/', to: 'tabulators#search_services_records'
    get 'service_types/:id/specialties/:specialty_id/tabulators/:tabulator_id/cities/:city_id/providers/', to: 'tabulators#search_providers'

  #SERVICE ORDER
    get 'users/:user_id/section/:type/service_orders/:init/:end/', to: 'service_orders#index'
    get 'users/:user_id/service_orders/:id', to: 'service_orders#show'
    delete 'service_orders/:id/', to: 'service_orders#close_order_query'
    get 'section/:type/service_orders/:init/:end/', to: 'service_orders#index_admin'
    #delete 'clean/service_orders/:id/', to: 'service_orders#destroy'
    
    #Beneficiaries
    post 'beneficiaries/service_orders/:service_type', to: 'service_orders#beneficiary_create' 
    put 'beneficiaries/service_orders/:id/', to: 'service_orders#beneficiary_update_status_verify'
    #Providers
    put 'providers/service_orders/:id/', to: 'service_orders#provider_update_status_sent'
    put 'providers/service_orders/:id/caused/', to: 'service_orders#provider_update_status_caused'
    put 'users/:user_id/service_codes/', to: 'service_orders#create_code'
    post 'providers/service_orders/:service_type', to: 'service_orders#provider_create'
    
    #OrderRecord
    post 'service_orders/:id/order_records/', to: 'order_records#create'
    put 'service_orders/:id/order_records/:order_record_id/', to: 'order_records#update'
    delete 'service_orders/:id/order_records/:order_record_id/', to: 'order_records#destroy'
    
  #PROVIDER SERVICES
    get 'users/:user_id/service_types/:service_type_id/specialties/:specialty_id/tabulators/', to: 'user_tabs#index_user' 
    get 'providers_users/:user_id/service_types/:service_type_id/specialties/:specialty_id/tabulators/', to: 'user_tabs#provider_index_user' 
    put 'users/:user_id/service_types/:service_type_id/specialties/:specialty_id/tabulators/', to: 'user_tabs#update'

  #SUGGESTIONS
    get 'suggestions_types/', to: 'tbl_attributes#search_root', :id => 15
    post 'suggestions', to: 'suggestions#create'
    get 'suggestions/:init/:end', to: 'suggestions#pagination'
    get 'suggestions/:suggestion_type_id/:init/:end', to: 'suggestions#pagination_type'

  #ADMIN FUNCTIONALITIES
    post 'administrators/', to: 'user_accesses#admin_create'
    get 'administrators/', to: 'user_accesses#admin_index'
    get 'administrators/:id', to: 'user_accesses#admin_show'
    delete 'administrators/:id/', to: 'user_accesses#admin_delete'
    get 'providers/inactive/:init/:end/', to: 'user_accesses#inactive_providers'
    get 'providers/active/:init/:end/', to: 'user_accesses#active_providers'
    put 'users/active/:id/', to: 'user_accesses#inactive_user'
    get 'users/:id/', to: 'user_accesses#user_show'
    get 'users/wallets/:id/', to: 'user_accesses#user_wallet_show'

  #CSV
    put 'service_types/:id/tabulators/csv/', to: 'csv#update_tabulators'

  #STATISCS
    get '/statistics/count/plans/beneficiaries/:month/:year', to: 'statistics#count_plans_beneficiaries'
    get '/statistics/count/plans/:month/:year', to: 'statistics#count_plans'
    get '/statistics/count/users/:month/:year', to: 'statistics#count_users'
    get '/statistics/count/sloncards/:month/:year', to: 'statistics#count_sloncards'
    get '/statistics/count/active/sloncards/:month/:year', to: 'statistics#count_active_sloncards'
    get '/statistics/count/suggestions/:month/:year', to: 'statistics#count_suggestions'
    get '/statistics/count/services/types/:month/:year', to: 'statistics#count_services_types'
    get '/statistics/money/fees/:month/:year', to: 'statistics#money_fees'
    get '/statistics/money/gateways/payments/:month/:year', to: 'statistics#money_gateways_payments'
    
  #Notificactions resources :notifications
    get 'notifications/:init/:end/', to: 'notifications#index'
    post 'notifications/', to: 'notifications#create'
    delete 'notifications/:id', to: 'notifications#destroy'
  # Health
    get 'health/', to: 'notifications#health'
    get '.well-known/acme-challenge/:id', to: 'notifications#ssl'

  # ONLY SYS ADMIN
    post 'specialties/', to: 'specialties#create' 
    put 'specialties/:id', to: 'specialties#update' 

    post 'tabulators/', to: 'tabulators#create' 
    put 'tabulators/:id', to: 'tabulators#update' 

    post 'tbl_attributes/', to: 'tbl_attributes#create' 
    put 'tbl_attributes/:id', to: 'tbl_attributes#update'

    #post 'locations/', to: 'locations#create' 
    #put 'locations/:id', to: 'locations#update' 
end
