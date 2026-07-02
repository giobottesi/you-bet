# Rate limiting and abusive-request blocking. Counters live in Rails.cache (solid_cache).
class Rack::Attack
  # Integer ENV lookup with a default, so limits are tunable per environment without a deploy.
  def self.env_int(name, default)
    ENV[name].presence&.to_i || default
  end

  ### Throttles ###

  # Simulation creation: the expensive, abuse-prone path. Keyed per IP.
  throttle("simulations/ip",
           limit: env_int("SIMULATION_THROTTLE_LIMIT", 10),
           period: env_int("SIMULATION_THROTTLE_PERIOD", 60)) do |request|
    request.ip if request.post? && request.path.start_with?("/simulations")
  end

  # General traffic ceiling: catches broad flooding across all paths. Keyed per IP.
  throttle("req/ip",
           limit: env_int("GENERAL_THROTTLE_LIMIT", 300),
           period: env_int("GENERAL_THROTTLE_PERIOD", 300)) do |request|
    request.ip unless request.path.start_with?("/assets", "/up")
  end

  ### Fail2Ban ###

  # Ban IPs probing for common exploit paths (WordPress, PHP, dotfiles). Opt-in via ENV.
  if ENV["FAIL2BAN_ENABLED"].present?
    blocklist("fail2ban/probes") do |request|
      Rack::Attack::Fail2Ban.filter("probes/#{request.ip}",
                                     maxretry: env_int("FAIL2BAN_MAXRETRY", 3),
                                     findtime: env_int("FAIL2BAN_FINDTIME", 600),
                                     bantime: env_int("FAIL2BAN_BANTIME", 3600)) do
        ScannerProbe.match?(request.path)
      end
    end
  end

  # Suspicious paths no legitimate visitor requests — signals a scanner.
  module ScannerProbe
    PATTERN = %r{\A/(?:wp-|xmlrpc|\.env|\.git|phpmyadmin)}i
    def self.match?(path) = PATTERN.match?(path)
  end

  ### Response ###

  # 429 with Retry-After so well-behaved clients back off instead of hammering.
  self.throttled_responder = lambda do |request|
    retry_after = (request.env["rack.attack.match_data"] || {})[:period]
    [ 429,
     { "Content-Type" => "application/json", "Retry-After" => retry_after.to_s },
     [ { error: "Too many requests. Retry in #{retry_after}s." }.to_json ] ]
  end
end
