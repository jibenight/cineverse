class NewsletterMailer < ApplicationMailer
  default from: "CinéVerse Newsletter <newsletter@cineverse.fr>"

  def confirmation_email(subscriber)
    @subscriber = subscriber
    @confirm_url = newsletter_confirm_url(token: subscriber.confirmation_token)
    mail(to: subscriber.email, subject: I18n.t("newsletter.confirm_subject"))
  end

  def campaign_email(campaign, subscriber)
    @campaign = campaign
    @subscriber = subscriber
    @unsubscribe_url = newsletter_unsubscribe_url(token: subscriber.confirmation_token)
    @tracking_pixel_url = newsletter_open_url(token: subscriber.confirmation_token, campaign_id: campaign.id)
    mail(to: subscriber.email, subject: campaign.subject)
  end
end
