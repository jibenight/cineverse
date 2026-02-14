class UserAvatarComponent < ViewComponent::Base
  def initialize(user:, size: :md, show_online: true, show_pass: false)
    @user = user
    @size = size
    @show_online = show_online
    @show_pass = show_pass
  end

  def size_class
    case @size
    when :sm then "w-8 h-8"
    when :md then "w-10 h-10"
    when :lg then "w-16 h-16"
    when :xl then "w-24 h-24"
    end
  end

  def avatar_url
    if @user.avatar.attached?
      url_for(@user.avatar.variant(resize_to_fill: [200, 200]))
    else
      "https://ui-avatars.com/api/?name=#{CGI.escape(@user.username)}&background=F59E0B&color=fff&size=200"
    end
  rescue StandardError
    "https://ui-avatars.com/api/?name=#{CGI.escape(@user.username)}&background=F59E0B&color=fff&size=200"
  end

  def online_indicator_class
    case @size
    when :sm then "w-2 h-2"
    when :md then "w-3 h-3"
    when :lg then "w-3.5 h-3.5"
    when :xl then "w-4 h-4"
    end
  end
end
