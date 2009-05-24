class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'  
    @body[:url]  = "http://#{APP_CONFIG['tension']['site_url']}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{APP_CONFIG['tension']['site_url']}/"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "do-not-reply@#{APP_CONFIG['tension']['site_url']}"
    @subject     = "[#{APP_CONFIG['tension']['site_name']}] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
