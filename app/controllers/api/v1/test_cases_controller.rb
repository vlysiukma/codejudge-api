# frozen_string_literal: true

module Api
  module V1
    class TestCasesController < Api::BaseController
      before_action :set_test_case, only: %i[update destroy]

      def update
        if @test_case.update(test_case_params)
          render json: @test_case, status: :ok
        else
          render json: { message: "Validation failed", errors: errors_format(@test_case) }, status: :unprocessable_entity
        end
      end

      def destroy
        @test_case.destroy!
        head :no_content
      end

      private

      def set_test_case
        @test_case = TestCase.find(params[:test_case_id])
      end

      def test_case_params
        params.permit(:input_data, :expected_output, :is_hidden, :points)
      end

      def errors_format(record)
        record.errors.map { |e| { field: e.attribute.to_s, message: e.full_message } }
      end
    end
  end
end
