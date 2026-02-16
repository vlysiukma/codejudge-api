# frozen_string_literal: true

module Api
  module V1
    class SubmissionsController < Api::BaseController
      before_action :set_submission, only: %i[show update]

      def create
        assignment = Assignment.find(params[:assignment_id])
        submission = assignment.submissions.build(
          user: current_user,
          source_code: params[:source_code],
          language: params[:language]
        )
        if submission.save
          render json: { submission_id: submission.id }, status: :accepted
        else
          render json: { message: "Validation failed", errors: errors_format(submission) }, status: :unprocessable_entity
        end
      end

      def show
        render json: submission_report(@submission), status: :ok
      end

      def update
        @submission.assign_attributes(submission_update_params)
        if @submission.save
          render json: submission_report(@submission), status: :ok
        else
          render json: { message: "Validation failed", errors: errors_format(@submission) }, status: :unprocessable_entity
        end
      end

      private

      def set_submission
        @submission = Submission.find(params[:submission_id])
      end

      def submission_update_params
        params.permit(:instructor_comment, :manual_score)
      end

      def submission_report(submission)
        {
          id: submission.id,
          status: submission.status,
          final_score: submission.final_score.nil? ? submission.manual_score : submission.final_score,
          test_results: submission.test_results || []
        }
      end

      def errors_format(record)
        record.errors.map { |e| { field: e.attribute.to_s, message: e.full_message } }
      end
    end
  end
end
