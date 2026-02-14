class Rack::Attack
  # Rate limit login attempts
  throttle("logins/ip", limit: 5, period: 60.seconds) do |req|
    req.ip if req.path == "/users/sign_in" && req.post?
  end

  # Rate limit signups
  throttle("signups/ip", limit: 3, period: 1.hour) do |req|
    req.ip if req.path == "/users" && req.post?
  end

  # Rate limit newsletter subscriptions
  throttle("newsletter/ip", limit: 3, period: 1.hour) do |req|
    req.ip if req.path == "/newsletter/subscribe" && req.post?
  end

  # Rate limit API search
  throttle("search/ip", limit: 30, period: 60.seconds) do |req|
    req.ip if req.path.start_with?("/search")
  end

  # Rate limit affiliate clicks
  throttle("affiliate/user", limit: 10, period: 60.seconds) do |req|
    if req.path.start_with?("/affiliate/redirect")
      req.env["warden"]&.user&.id || req.ip
    end
  end

  # Rate limit contact form
  throttle("contact/ip", limit: 3, period: 1.hour) do |req|
    req.ip if req.path == "/contact" && req.post?
  end

  # Rate limit report creation
  throttle("reports/ip", limit: 10, period: 1.hour) do |req|
    req.ip if req.path == "/reports" && req.post?
  end

  # Rate limit newsletter token endpoints (confirm & unsubscribe)
  throttle("newsletter_tokens/ip", limit: 10, period: 60.seconds) do |req|
    req.ip if req.path.start_with?("/newsletter/confirm/") || req.path.start_with?("/newsletter/unsubscribe/")
  end
end
