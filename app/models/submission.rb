# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :assignment
  belongs_to :user

  validates :source_code, presence: true
  validates :language, inclusion: { in: %w[ruby python cpp java] }
  validates :status, inclusion: { in: %w[pending running completed] }
  validates :final_score, numericality: { only_integer: true }, allow_nil: true
  validates :manual_score, numericality: { only_integer: true }, allow_nil: true
end
