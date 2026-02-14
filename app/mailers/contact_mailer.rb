class ContactMailer < ApplicationMailer
  def contact_form(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: "hello@cineverse.fr", subject: "Contact CinéVerse: #{name}", reply_to: email)
  end
end
