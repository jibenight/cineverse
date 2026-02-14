class CinemaPassBadgeComponent < ViewComponent::Base
  def initialize(cinema_pass:, size: :md)
    @cinema_pass = cinema_pass
    @size = size
  end

  def type_color
    case @cinema_pass.pass_type
    when "solo" then "bg-blue-500"
    when "duo" then "bg-violet-500"
    when "famille" then "bg-amber-500"
    end
  end

  def display_name
    @cinema_pass.display_name
  end

  def type_label
    I18n.t("cinema_passes.types.#{@cinema_pass.pass_type}")
  end

  def render?
    @cinema_pass.present?
  end
end
