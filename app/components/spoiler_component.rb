class SpoilerComponent < ViewComponent::Base
  def initialize(content:)
    @content = content
  end
end
