# frozen_string_literal: true

JWTSessions.algorithm = "HS256"
JWTSessions.encryption_key = ENV.fetch("JWT_ENCRYPTION_KEY", Rails.application.secret_key_base)
JWTSessions.token_store = :redis, { redis_url: ENV.fetch("REDIS_URL", "redis://redis:6379/0") }
JWTSessions.access_exp_time = 3600
JWTSessions.refresh_exp_time = 604800
