# frozen_string_literal: true

module Api
  module V1
    class AssignmentsController < Api::BaseController
      skip_before_action :authorize_access_request!, only: %i[index show]

      before_action :set_assignment, only: %i[show update destroy]

      def index
        scope = Assignment.all
        scope = scope.where(difficulty: params[:difficulty]) if params[:difficulty].present?
        page = (params[:page] || 1).to_i
        limit = (params[:limit] || 10).to_i
        limit = 100 if limit > 100
        @assignments = scope.offset((page - 1) * limit).limit(limit)
        render json: @assignments, status: :ok
      end

      def show
        render json: @assignment, status: :ok
      end

      def create
        assignment = Assignment.new(assignment_params)
        if assignment.save
          render json: assignment, status: :created
        else
          render json: { message: "Validation failed", errors: errors_format(assignment) }, status: :unprocessable_entity
        end
      end

      def update
        if @assignment.update(assignment_params)
          render json: @assignment, status: :ok
        else
          render json: { message: "Validation failed", errors: errors_format(@assignment) }, status: :unprocessable_entity
        end
      end

      def destroy
        @assignment.destroy!
        head :no_content
      end

      private

      def set_assignment
        @assignment = Assignment.find(params[:id])
      end

      def assignment_params
        params.permit(:title, :description, :difficulty, :max_score)
      end

      def errors_format(record)
        record.errors.map { |e| { field: e.attribute.to_s, message: e.full_message } }
      end
    end
  end
end
