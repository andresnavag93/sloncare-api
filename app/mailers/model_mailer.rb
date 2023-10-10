class ModelMailer < ApplicationMailer
  
  def send_contact_request(email, name, text, locale, sloncare_email=nil, suggestion_type=nil)
    I18n.locale = locale.to_sym
    if sloncare_email
      @sloncare_email = sloncare_email
    else
      @sloncare_email = Rails.configuration.admin_mail
    end

    if suggestion_type
      @suggestion_type = suggestion_type
    else
      @suggestion_type = nil
    end


    @email = email
    @name = name
    @text = text
    msg = I18n.t 'model_mailer.request.subject'
    mail from: 'no-replay@sloncare.com', to: @sloncare_email, subject: "#{msg} #{name}."
  end

  def send_sloncard(sponsor, code, locale)
    I18n.locale = locale.to_sym
    @login_path = Rails.configuration.login_path
    @sponsor = sponsor
    @code = code
    msg = I18n.t 'model_mailer.purchase.subject'
    mail from: 'no-replay@sloncare.com', to: @sponsor.email, subject: "#{msg}."
  end

  def send_welcome_doctor(doctor, password, wallet, locale)
  	I18n.locale = locale.to_sym
  	@doctor = doctor
  	@password = password
  	@wallet = wallet
  	msg = I18n.t 'model_mailer.welcome.welcome_doctor'
    mail to: @doctor.email, subject: "#{msg} #{@doctor.name}."
  end

  def send_welcome_clinic(clinic, password, wallet, locale)
    I18n.locale = locale.to_sym
    @clinic = clinic
    @password = password
    @wallet = wallet
    msg = I18n.t 'model_mailer.welcome.welcome_clinic'
    mail to: @clinic.email, subject: "#{msg} #{@clinic.name}."
  end

  def send_welcome_beneficiary(beneficiary, password, wallet, plan, saving_level, locale)
    I18n.locale = locale.to_sym
    @beneficiary = beneficiary
    @password = password
    @wallet = wallet
    @plan = plan
    @saving_level = saving_level
    msg = I18n.t 'model_mailer.welcome.welcome_beneficiary'
    mail to: @beneficiary.email, subject: "#{msg} #{@beneficiary.name}."
  end

   def send_token_email(email, token, question1_id, question2_id, locale)
    I18n.locale = locale.to_sym
    @token = Rails.configuration.recovery_password_path + "?token="+token#+"&question1_id="+question1_id.to_s+"&question2_id="+question2_id.to_s
    @locale = locale
    @email = email
    msg = I18n.t 'model_mailer.recovery.subject'
    mail from: 'no-replay@sloncare.com', to: @email, subject: "#{msg}."
   end

  def send_password_change(email, locale)
    I18n.locale = locale.to_sym
    @email = email
    msg = I18n.t 'model_mailer.recovery_success.subject'
    mail from: 'no-replay@sloncare.com', to: @email, subject: "#{msg}."
  end

  def send_welcome_group(group, admin, password, wallet, plan, saving_level, locale, admin2=nil, password2=nil)
    I18n.locale = locale.to_sym
    @group = group
    @admin = admin
    @admin2 = admin2
    @password = password
    @password2 = password2
    @wallet = wallet
    @plan = plan
    @saving_level = saving_level
    msg = I18n.t 'model_mailer.welcome.welcome_contractor'
    mail to: @group.c_email, subject: "#{msg} #{@group.c_name}."
  end

  def send_recharge_wallet(email, amount, wallet, locale)
    I18n.locale = locale.to_sym
    @email = email
    @amount = amount
    @wallet = wallet
    msg = I18n.t 'model_mailer.recharge.subject'
    mail from: 'no-replay@sloncare.com', to: @email, subject: "#{msg}."
  end

  def send_service_request_notification(email, locale)
    I18n.locale = locale.to_sym
    @email = email
    msg = I18n.t 'model_mailer.new_order.subject'
    mail from: 'no-replay@sloncare.com', to: @email, subject: "#{msg}."
  end

  def send_verification_code(email, code, locale)
    I18n.locale = locale.to_sym
    @code = code
    msg = I18n.t 'model_mailer.code.subject'
    mail from: 'no-replay@sloncare.com', to: email, subject: "#{msg}."
  end

  def send_update_tabulators(email, service, codes_update, codes_not_found, locale)
    I18n.locale = locale.to_sym
    @service = service
    @codes_update = codes_update
    @codes_not_found = codes_not_found
    @email = email
    msg = I18n.t 'model_mailer.service_tabulator.subject'
    mail from: 'no-replay@sloncare.com', to: @email, subject: "#{msg}."
  end

  def send_recurring_payment_wallet(email, amount, wallet, locale, succeed, count=nil)
    I18n.locale = locale.to_sym
    @email = email
    @amount = amount
    @wallet = wallet
    @succeed = succeed
    @count = count
    if @succeed
      msg = I18n.t 'model_mailer.transaction.subject'
    else
      msg = I18n.t 'model_mailer.transaction.fail'
    end
    mail from: 'no-replay@sloncare.com', to: @email, subject: "#{msg}."
  end

  def send_statistic_saving_level(email, amount_saving, saving_level, variable, locale, count=nil)
    I18n.locale = locale.to_sym
    @email = email
    @amount = amount_saving
    @saving_level = saving_level
    @variable = variable
    if @variable
      msg = I18n.t 'model_mailer.statistic.subject'
    else
      msg = I18n.t 'model_mailer.statistic.fail'
    end
    @count = count
    mail from: 'no-replay@sloncare.com', to: @email, subject: "#{msg}."
  end
end