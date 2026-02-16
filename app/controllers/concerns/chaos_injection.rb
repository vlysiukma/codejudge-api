# frozen_string_literal: true

# Optional query params for API consumers to test error handling and retries.
# Only active in development/test or when ENABLE_CHAOS_INJECTION is set.
#
# Query params:
#   inject_error_pct   (1-100) Chance to return a random 4xx/5xx instead of normal response.
#   inject_timeout_pct (1-100) Chance to sleep then return 504 Gateway Timeout.
#   inject_timeout_sec (optional) Seconds to sleep when timeout is triggered (default: 2).
#
# Example: GET /api/v1/assignments?inject_error_pct=20&inject_timeout_pct=10&inject_timeout_sec=3
module ChaosInjection
  extend ActiveSupport::Concern

  INJECTABLE_ERROR_STATUSES = [
    400, 401, 403, 404, 422, 500, 502, 503
  ].freeze

  ERROR_MESSAGES = {
    400 => "Bad Request (injected)",
    401 => "Unauthorized (injected)",
    403 => "Forbidden (injected)",
    404 => "Not Found (injected)",
    422 => "Unprocessable Entity (injected)",
    500 => "Internal Server Error (injected)",
    502 => "Bad Gateway (injected)",
    503 => "Service Unavailable (injected)"
  }.freeze

  included do
    prepend_before_action :maybe_inject_chaos
  end

  private

  def maybe_inject_chaos
    return unless chaos_injection_enabled?

    # Timeout: sleep then 504 (so client can test timeout/retry)
    timeout_pct = chaos_param_int(:inject_timeout_pct)
    if timeout_pct && timeout_pct.between?(1, 100) && rand(100) < timeout_pct
      sec = chaos_param_float(:inject_timeout_sec) || 2.0
      sec = 0.1 if sec > 60 # cap to avoid accidental long sleeps
      sleep(sec)
      render json: { message: "Gateway Timeout (injected)", injected: true }, status: :gateway_timeout
      return
    end

    # Error: random 4xx/5xx
    error_pct = chaos_param_int(:inject_error_pct)
    if error_pct && error_pct.between?(1, 100) && rand(100) < error_pct
      status = INJECTABLE_ERROR_STATUSES.sample
      message = ERROR_MESSAGES[status]
      render json: { message: message, injected: true, status: status }, status: status
      return
    end
  end

  def chaos_injection_enabled?
    return false if Rails.env.production? && ENV["ENABLE_CHAOS_INJECTION"] != "true"
    chaos_param_int(:inject_error_pct).present? || chaos_param_int(:inject_timeout_pct).present?
  end

  def chaos_param_int(key)
    raw = request.query_parameters[key.to_s]
    return nil if raw.blank?
    raw.to_i
  end

  def chaos_param_float(key)
    raw = request.query_parameters[key.to_s]
    return nil if raw.blank?
    raw.to_f
  end
end
