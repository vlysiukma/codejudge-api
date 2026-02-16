# frozen_string_literal: true

class TestCase < ApplicationRecord
  belongs_to :assignment

  validates :input_data, presence: true
  validates :expected_output, presence: true
  validates :is_hidden, inclusion: { in: [true, false] }
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
