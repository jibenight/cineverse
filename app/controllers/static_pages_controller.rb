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
    # Handle contact form submission
    ContactMailer.contact_form(params[:name], params[:email], params[:message]).deliver_later
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
