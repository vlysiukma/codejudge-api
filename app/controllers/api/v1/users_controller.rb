# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::BaseController
      def current
        render json: {
          id: current_user.id,
          email: current_user.email,
          role: current_user.role
        }, status: :ok
      end
    end
  end
end
