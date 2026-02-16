# frozen_string_literal: true

module AuthHelper
  def auth_headers_for(user)
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    tokens = session.login
    { "Authorization" => "Bearer #{tokens[:access]}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelper
end
