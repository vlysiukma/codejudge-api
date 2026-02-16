# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Leaderboard", type: :request do
  describe "GET /api/v1/leaderboard" do
    it "returns list without auth (public)" do
      get "/api/v1/leaderboard"
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to be_an(Array)
    end

    it "returns users with rank and total_score" do
      u = create(:user, username: "alice", role: "student")
      create(:submission, user: u, final_score: 50)
      get "/api/v1/leaderboard"
      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body.size).to be >= 1
      expect(body.first).to include("rank", "username", "total_score")
    end
  end
end
