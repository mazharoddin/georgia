module Georgia
  class Notifier < ActionMailer::Base

    include SendGrid

    def notify_admins(message, url)
      @message = message
      @url = url
      domain_name = Rails.application.config.action_mailer.smtp_settings[:domain]
      emails_to = Georgia::User.admins.map(&:email)
      unless emails_to.empty?
        mail(
          from: "do-not-reply@#{domain_name}",
          to: emails_to,
          subject: @message
          )
      end
    end

    def notify_editors(message, url)
      @message = message
      @url = url
      domain_name = Rails.application.config.action_mailer.smtp_settings[:domain]
      emails_to = Georgia::User.editors.map(&:email)
      unless emails_to.empty?
        mail(
          from: "do-not-reply@#{domain_name}",
          to: emails_to,
          subject: @message
          )
      end
    end

  end
end
