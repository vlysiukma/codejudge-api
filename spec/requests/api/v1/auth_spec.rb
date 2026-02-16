# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/register" do
    let(:valid_params) do
      { email: "newuser@example.com", password: "password123", username: "newuser" }
    end

    it "creates a user and returns JWT" do
      post "/api/v1/auth/register", params: valid_params, as: :json
      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body).to include("access_token", "token_type", "expires_in")
      expect(body["token_type"]).to eq("Bearer")
      expect(body["access_token"]).to be_present
    end

    it "returns 422 with invalid params" do
      post "/api/v1/auth/register", params: { email: "bad", password: "short" }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      body = response.parsed_body
      expect(body).to include("message", "errors")
      expect(body["message"]).to eq("Validation failed")
    end

    it "returns 422 when email already taken" do
      create(:user, email: "taken@example.com")
      post "/api/v1/auth/register", params: valid_params.merge(email: "taken@example.com"), as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "login@example.com", password: "password123") }

    it "returns JWT for valid credentials" do
      post "/api/v1/auth/login", params: { email: "login@example.com", password: "password123" }, as: :json
      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body).to include("access_token", "token_type", "expires_in")
      expect(body["token_type"]).to eq("Bearer")
    end

    it "returns 401 for wrong password" do
      post "/api/v1/auth/login", params: { email: "login@example.com", password: "wrong" }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 for unknown email" do
      post "/api/v1/auth/login", params: { email: "nobody@example.com", password: "password123" }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
