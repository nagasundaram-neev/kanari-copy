class MyDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within 'application_helper'.
  include Devise::Controllers::UrlHelpers # Optional. eg. 'confirmation_url'
  include Devise::Mailers::Helpers

  def reset_password_instructions(record, token, opts={})
    opts[:from] = 'support@kanari.co'
    opts[:reply_to] = 'support@kanari.co'
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
    if record.role == "customer_admin" || record.role == "kanari_admin" || record.role == 'manager'
      headers['X-MC-Tags'] = "Reset Password, Business Account, system"
    elsif record.role == "user"
      headers['X-MC-Tags'] = "Reset Password, Mobile App, system"
    end
  end

end
