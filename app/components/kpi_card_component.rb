class KpiCardComponent < ViewComponent::Base
  def initialize(label:, value:, icon: nil, delta: nil, delta_period: "vs semaine dernière")
    @label = label
    @value = value
    @icon = icon
    @delta = delta
    @delta_period = delta_period
  end

  def delta_positive?
    @delta.present? && @delta > 0
  end

  def delta_display
    return nil unless @delta
    prefix = delta_positive? ? "+" : ""
    "#{prefix}#{@delta}%"
  end
end
