class UserMailer < ActionMailer::Base
  default from: AppConfig[:default_from_email]

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Kanari')
  end
end
