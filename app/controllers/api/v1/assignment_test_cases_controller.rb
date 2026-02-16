# frozen_string_literal: true

module Api
  module V1
    class AssignmentTestCasesController < Api::BaseController
      before_action :set_assignment

      def index
        render json: @assignment.test_cases, status: :ok
      end

      def create
        test_case = @assignment.test_cases.build(test_case_params)
        if test_case.save
          render json: test_case, status: :created
        else
          render json: { message: "Validation failed", errors: errors_format(test_case) }, status: :unprocessable_entity
        end
      end

      private

      def set_assignment
        @assignment = Assignment.find(params[:assignment_id])
      end

      def test_case_params
        p = params.permit(:input_data, :expected_output, :is_hidden, :points)
        p[:is_hidden] = true if p[:is_hidden].nil?
        p[:points] = 5 if p[:points].nil?
        p
      end

      def errors_format(record)
        record.errors.map { |e| { field: e.attribute.to_s, message: e.full_message } }
      end
    end
  end
end
