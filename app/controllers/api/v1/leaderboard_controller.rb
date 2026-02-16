# frozen_string_literal: true

module Api
  module V1
    class LeaderboardController < Api::BaseController
      skip_before_action :authorize_access_request!, only: %i[index]

      def index
        rows = User.where(role: "student")
          .left_joins(:submissions)
          .group("users.id", "users.username")
          .select("users.id", "users.username", "COALESCE(SUM(COALESCE(submissions.final_score, submissions.manual_score, 0)), 0) AS total_score")
          .order("total_score DESC")
          .limit(100)

        result = rows.each_with_index.map do |row, index|
          {
            rank: index + 1,
            username: row.username.presence || "user_#{row.id}",
            total_score: row.attributes["total_score"].to_i
          }
        end

        render json: result, status: :ok
      end
    end
  end
end
