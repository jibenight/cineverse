module ApplicationHelper
  include Pagy::Frontend

  def sidebar_link(label, path, icon_name)
    active = current_page?(path)
    tag.a(href: path, class: "flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition #{active ? 'bg-amber-500/10 text-amber-500 font-medium' : 'text-neutral-600 dark:text-neutral-400 hover:bg-neutral-100 dark:hover:bg-neutral-800'}") do
      feather_icon(icon_name, class: "w-5 h-5") + tag.span(label)
    end
  end

  def icon_link(path, icon_name)
    active = current_page?(path)
    tag.a(href: path, class: "p-2 rounded-lg transition #{active ? 'bg-amber-500/10 text-amber-500' : 'text-neutral-500 hover:bg-neutral-100 dark:hover:bg-neutral-800'}") do
      feather_icon(icon_name, class: "w-5 h-5")
    end
  end

  def mobile_nav_link(path, icon_name, label)
    active = current_page?(path)
    tag.a(href: path, class: "flex flex-col items-center gap-0.5 px-3 py-1 text-xs transition #{active ? 'text-amber-500' : 'text-neutral-500'}") do
      feather_icon(icon_name, class: "w-5 h-5") + tag.span(label)
    end
  end

  def feather_icon(name, **options)
    css_class = options.delete(:class) || "w-5 h-5"
    case name
    when "home"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6") }
    when "film"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M7 4v16M17 4v16M3 8h4m10 0h4M3 12h18M3 16h4m10 0h4M4 20h16a1 1 0 001-1V5a1 1 0 00-1-1H4a1 1 0 00-1 1v14a1 1 0 001 1z") }
    when "calendar"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z") }
    when "trending-up"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M13 7h8m0 0v8m0-8l-8 8-4-4-6 6") }
    when "search"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z") }
    when "message-circle"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z") }
    when "bookmark"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z") }
    when "bell"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9") }
    when "tag"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z") }
    when "user"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z") }
    when "settings"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z") + tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M15 12a3 3 0 11-6 0 3 3 0 016 0z") }
    when "shield"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z") }
    when "log-in"
      tag.svg(class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") { tag.path("stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1") }
    else
      tag.span("?", class: css_class)
    end
  end
end
