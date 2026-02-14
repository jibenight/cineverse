class CountdownComponent < ViewComponent::Base
  def initialize(date:)
    @date = date
  end

  def days_remaining
    (@date - Date.current).to_i
  end

  def render?
    @date.present? && @date > Date.current
  end
end
