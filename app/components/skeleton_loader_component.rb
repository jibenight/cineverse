class SkeletonLoaderComponent < ViewComponent::Base
  def initialize(type: :card, count: 1)
    @type = type
    @count = count
  end
end
