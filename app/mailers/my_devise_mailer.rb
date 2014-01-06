class MyDeviseMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within 'application_helper'.
  include Devise::Controllers::UrlHelpers # Optional. eg. 'confirmation_url'
  include Devise::Mailers::Helpers
  
  def reset_password_instructions(record, token, opts={})
    opts[:from] = 'support@kanari.co'
    opts[:reply_to] = 'support@kanari.co'
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end
  
end
