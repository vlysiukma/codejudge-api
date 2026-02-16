# frozen_string_literal: true

class Assignment < ApplicationRecord
  has_many :test_cases, dependent: :destroy
  has_many :submissions, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true
  validates :difficulty, inclusion: { in: %w[easy medium hard] }, allow_blank: true
  validates :max_score, numericality: { greater_than_or_equal_to: 0 }
end
