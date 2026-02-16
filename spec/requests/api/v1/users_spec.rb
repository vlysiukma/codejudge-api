# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user) }
  let(:auth_headers) { auth_headers_for(user) }

  describe "GET /api/v1/current_user" do
    it "returns 401 without auth" do
      get "/api/v1/current_user"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns current user with auth" do
      get "/api/v1/current_user", headers: auth_headers
      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body).to include("id" => user.id, "email" => user.email, "role" => user.role)
    end
  end
end
