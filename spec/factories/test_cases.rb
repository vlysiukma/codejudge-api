# frozen_string_literal: true

FactoryBot.define do
  factory :test_case do
    association :assignment
    input_data { "1 2" }
    expected_output { "3" }
    is_hidden { true }
    points { 5 }
  end
end
