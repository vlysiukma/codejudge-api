# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Assignments", type: :request do
  let!(:user) { create(:user) }
  let(:auth_headers) { auth_headers_for(user) }

  describe "GET /api/v1/assignments" do
    it "returns list without auth (public)" do
      create_list(:assignment, 2)
      get "/api/v1/assignments"
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(2)
    end

    it "filters by difficulty" do
      create(:assignment, difficulty: "easy")
      create(:assignment, difficulty: "hard")
      get "/api/v1/assignments", params: { difficulty: "easy" }
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.all? { |a| a["difficulty"] == "easy" }).to be true
    end
  end

  describe "GET /api/v1/assignments/:id" do
    it "returns assignment without auth (public)" do
      a = create(:assignment)
      get "/api/v1/assignments/#{a.id}"
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["id"]).to eq(a.id)
    end

    it "returns 404 for missing" do
      get "/api/v1/assignments/99999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/assignments" do
    it "requires auth" do
      post "/api/v1/assignments", params: { title: "New Assignment", description: "Desc" }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "creates assignment with valid params" do
      post "/api/v1/assignments", params: { title: "Valid Title Here", description: "Description", difficulty: "easy" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
      expect(response.parsed_body["title"]).to eq("Valid Title Here")
    end
  end

  describe "PATCH /api/v1/assignments/:id" do
    let(:assignment) { create(:assignment) }

    it "requires auth" do
      patch "/api/v1/assignments/#{assignment.id}", params: { title: "Updated" }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "updates with auth" do
      patch "/api/v1/assignments/#{assignment.id}", params: { title: "Updated Title Here" }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["title"]).to eq("Updated Title Here")
    end
  end

  describe "DELETE /api/v1/assignments/:id" do
    let(:assignment) { create(:assignment) }

    it "requires auth" do
      delete "/api/v1/assignments/#{assignment.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "deletes with auth" do
      delete "/api/v1/assignments/#{assignment.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(Assignment.find_by(id: assignment.id)).to be_nil
    end
  end
end
