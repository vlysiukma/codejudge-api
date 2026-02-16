# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Submissions", type: :request do
  let!(:user) { create(:user) }
  let(:auth_headers) { auth_headers_for(user) }
  let(:assignment) { create(:assignment) }

  describe "POST /api/v1/assignments/:id/submit" do
    it "creates submission and returns 202" do
      post "/api/v1/assignments/#{assignment.id}/submit",
        params: { source_code: "def add(a,b); a+b; end", language: "ruby" },
        headers: auth_headers,
        as: :json
      expect(response).to have_http_status(:accepted)
      expect(response.parsed_body).to include("submission_id")
    end

    it "returns 401 without auth" do
      post "/api/v1/assignments/#{assignment.id}/submit",
        params: { source_code: "code", language: "ruby" },
        as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/submissions/:submission_id" do
    let(:submission) { create(:submission, assignment: assignment, user: user) }

    it "returns submission report" do
      get "/api/v1/submissions/#{submission.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body).to include("id", "status", "final_score", "test_results")
    end
  end

  describe "PATCH /api/v1/submissions/:submission_id" do
    let(:submission) { create(:submission, assignment: assignment, user: user) }

    it "updates instructor_comment and manual_score" do
      patch "/api/v1/submissions/#{submission.id}",
        params: { instructor_comment: "Good job", manual_score: 90 },
        headers: auth_headers,
        as: :json
      expect(response).to have_http_status(:ok)
      submission.reload
      expect(submission.instructor_comment).to eq("Good job")
      expect(submission.manual_score).to eq(90)
    end
  end
end
