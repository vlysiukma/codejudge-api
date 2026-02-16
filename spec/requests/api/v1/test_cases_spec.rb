# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::TestCases", type: :request do
  let!(:user) { create(:user) }
  let(:auth_headers) { auth_headers_for(user) }
  let(:assignment) { create(:assignment) }

  describe "GET /api/v1/assignments/:id/test_cases" do
    it "requires auth" do
      get "/api/v1/assignments/#{assignment.id}/test_cases"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns test cases" do
      create_list(:test_case, 2, assignment: assignment)
      get "/api/v1/assignments/#{assignment.id}/test_cases", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(2)
    end
  end

  describe "POST /api/v1/assignments/:id/test_cases" do
    it "creates test case" do
      post "/api/v1/assignments/#{assignment.id}/test_cases",
        params: { input_data: "1 2", expected_output: "3", points: 5 },
        headers: auth_headers,
        as: :json
      expect(response).to have_http_status(:created)
      expect(response.parsed_body["input_data"]).to eq("1 2")
    end
  end

  describe "PATCH /api/v1/test_cases/:test_case_id" do
    let(:test_case) { create(:test_case, assignment: assignment) }

    it "updates test case" do
      patch "/api/v1/test_cases/#{test_case.id}",
        params: { points: 10 },
        headers: auth_headers,
        as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["points"]).to eq(10)
    end
  end

  describe "DELETE /api/v1/test_cases/:test_case_id" do
    let(:test_case) { create(:test_case, assignment: assignment) }

    it "deletes test case" do
      delete "/api/v1/test_cases/#{test_case.id}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
      expect(TestCase.find_by(id: test_case.id)).to be_nil
    end
  end
end
