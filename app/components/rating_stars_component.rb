class RatingStarsComponent < ViewComponent::Base
  def initialize(score: nil, interactive: false, size: :md)
    @score = score || 0
    @interactive = interactive
    @size = size
  end

  def star_class
    case @size
    when :sm then "w-4 h-4"
    when :md then "w-5 h-5"
    when :lg then "w-6 h-6"
    end
  end

  def stars
    (1..5).map do |i|
      if @score >= i
        :full
      elsif @score >= i - 0.5
        :half
      else
        :empty
      end
    end
  end
end
