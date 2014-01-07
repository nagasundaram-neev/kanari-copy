class UserMailer < ActionMailer::Base
  default from: AppConfig[:default_from_email]

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Kanari')
  end

  def welcome_email_business(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Kanari')
  end

  def request_email_to_share_details(reachoutuser,feedback,contacted_user)
    @user = reachoutuser
    @feedback = feedback
    @outlet = @feedback.outlet
    @contacted_user_id = contacted_user.id
    @host = "#{default_url_options[:protocol]}://#{default_url_options[:host]}"
    mail(from: 'Kanari Team <notifications@kanari.co>', to: @user.email, subject: "The manager at #{@outlet.name} wants to contact you")
    headers['X-MC-Tags'] = "Reach Out, User Request"
    headers['X-MC-Track'] = "opens, clicks"
    headers['X-MC-TrackingDomain'] = "track.kanari.co"
  end

  def customer_accepted_email_to_share_details(feedback,user)
    @manager_user = user
    @feedback = feedback
    @customer_user = @feedback.user
    mail(from: 'Kanari Team <notifications@kanari.co>', to: @manager_user.email, subject: 'Kanari: Your Reach Out request has been accepted')
    headers['X-MC-Tags'] = "Reach Out, Manager Response"
    headers['X-MC-Track'] = "opens, clicks"
    headers['X-MC-TrackingDomain'] = "track.kanari.co"
  end
end
