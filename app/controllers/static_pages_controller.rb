class StaticPagesController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def about
    @page = StaticPage.find_by(slug: :about)
  end

  def contact
    @page = StaticPage.find_by(slug: :contact)
  end

  def send_contact
    name = params[:name].to_s.strip
    email = params[:email].to_s.strip
    message = params[:message].to_s.strip

    if name.blank? || email.blank? || message.blank?
      redirect_to contact_path, alert: "Tous les champs sont obligatoires."
      return
    end

    if name.length > 100
      redirect_to contact_path, alert: "Le nom ne doit pas dépasser 100 caractères."
      return
    end

    if message.length > 5000
      redirect_to contact_path, alert: "Le message ne doit pas dépasser 5000 caractères."
      return
    end

    unless email.match?(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/)
      redirect_to contact_path, alert: "L'adresse email n'est pas valide."
      return
    end

    ContactMailer.contact_form(name, email, message).deliver_later
    redirect_to contact_path, notice: "Message envoyé !"
  end

  def faq
    @page = StaticPage.find_by(slug: :faq)
  end

  def privacy
    @page = StaticPage.find_by(slug: :privacy)
  end

  def terms
    @page = StaticPage.find_by(slug: :terms)
  end
end
